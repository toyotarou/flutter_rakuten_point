import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/action_name.dart';
import '../../extensions/extensions.dart';
import '../../repository/action_names_repository.dart';
import '../../utilities/functions.dart';
import '../home_screen.dart';
import '../parts/error_dialog.dart';

class ActionNameInputAlert extends ConsumerStatefulWidget {
  const ActionNameInputAlert({super.key, required this.isar, this.actionNameList});

  final Isar isar;
  final List<ActionName>? actionNameList;

  @override
  ConsumerState<ActionNameInputAlert> createState() => _ActionNameInputAlertState();
}

class _ActionNameInputAlertState extends ConsumerState<ActionNameInputAlert> {
  TextEditingController actionNameEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  bool isEditing = false;

  int actionId = 0;

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('アクション名管理'), SizedBox.shrink()],
              ),
              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
              _displayInputParts(),

              Expanded(child: displayActionNameList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayActionNameList() {
    final List<Widget> list = <Widget>[];

    widget.actionNameList?.forEach((ActionName element) {
      list.add(
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(element.name),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      actionNameEditingController.text = element.name;

                      setState(() {
                        isEditing = true;

                        actionId = element.id;
                      });
                    },

                    icon: Icon(Icons.edit, color: Colors.white.withValues(alpha: 0.3)),
                  ),

                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(id: element.id);
                    },
                    icon: Icon(Icons.delete, color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(
      child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: Column(children: list)),
    );
  }

  ///
  Widget _displayInputParts() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                TextField(
                  controller: actionNameEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'アクション名(30文字以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[0],
                  onTap: () => context.showKeyboard(focusNodeList[0]),
                ),

                const SizedBox(height: 20),

                if (isEditing)
                  ElevatedButton(
                    onPressed: () {
                      _updateActionName();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('更新'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      _inputActionName();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('登録'),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputActionName() async {
    bool errFlg = false;

    if (actionNameEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[actionNameEditingController.text.trim(), 30],
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
          // ignore: use_build_context_synchronously
          context: context,
          title: '登録できません。',
          content: '値を正しく入力してください。',
        ),
      );

      return;
    }

    final ActionName actionName = ActionName()..name = actionNameEditingController.text.trim();

    // ignore: always_specify_types
    ActionNamesRepository().inputActionName(isar: widget.isar, actionName: actionName).then((value) {
      if (mounted) {
        actionNameEditingController.clear();

        Navigator.pop(context);
        Navigator.pop(context);

        // ignore: inference_failure_on_instance_creation, always_specify_types
        Navigator.pushReplacement(
          context,
          // ignore: inference_failure_on_instance_creation, always_specify_types
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar)),
        );
      }
    });
  }

  ///
  Future<void> _updateActionName() async {
    bool errFlg = false;

    if (actionNameEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[actionNameEditingController.text.trim(), 30],
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
          // ignore: use_build_context_synchronously
          context: context,
          title: '登録できません。',
          content: '値を正しく入力してください。',
        ),
      );

      return;
    }

    await widget.isar.writeTxn(() async {
      await ActionNamesRepository().getActionName(isar: widget.isar, id: actionId).then((ActionName? value) async {
        value!.name = actionNameEditingController.text.trim();

        await ActionNamesRepository().updateActionName(isar: widget.isar, actionName: value)
        // ignore: always_specify_types
        .then((value) {
          if (mounted) {
            actionNameEditingController.clear();

            Navigator.pop(context);
            Navigator.pop(context);

            // ignore: inference_failure_on_instance_creation, always_specify_types
            Navigator.pushReplacement(
              context,
              // ignore: inference_failure_on_instance_creation, always_specify_types
              MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar)),
            );
          }
        });
      });
    });
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
      onPressed: () {
        _deleteActionName(id: id);

        Navigator.pop(context);
      },
      child: const Text('はい'),
    );

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteActionName({required int id}) async {
    // ignore: always_specify_types
    ActionNamesRepository().deleteActionName(isar: widget.isar, id: id).then((value) {
      if (mounted) {
        actionNameEditingController.clear();

        Navigator.pop(context);
        Navigator.pop(context);

        // ignore: inference_failure_on_instance_creation, always_specify_types
        Navigator.pushReplacement(
          context,
          // ignore: inference_failure_on_instance_creation, always_specify_types
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar)),
        );
      }
    });
  }
}
