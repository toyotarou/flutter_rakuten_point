import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/action_name.dart';
import '../../collections/category_name.dart';
import '../../collections/record.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/records_repository.dart';
import '../../utilities/functions.dart';
import '../home_screen.dart';
import '../parts/error_dialog.dart';

class RecordInputAlert extends ConsumerStatefulWidget {
  const RecordInputAlert({super.key, required this.isar, this.categoryNameList, this.actionNameList, this.record});

  final Isar isar;
  final List<CategoryName>? categoryNameList;
  final List<ActionName>? actionNameList;
  final Record? record;

  @override
  ConsumerState<RecordInputAlert> createState() => _RecordInputAlertState();
}

class _RecordInputAlertState extends ConsumerState<RecordInputAlert> with ControllersMixin<RecordInputAlert> {
  // List<String> categoryNames = <String>[];
  //
  //
  //
  //

  TextEditingController priceEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    // categoryNames = <String>[
    //   '',
    //   if (widget.categoryNameList case final List<CategoryName> list?) ...list.map((CategoryName e) => e.name),
    // ];
    //
    //

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());

    if (widget.record != null) {
      // ignore: always_specify_types
      Future(() {
        appParamNotifier.setSelectedDate(date: widget.record!.date);
      });

      priceEditingController.text = widget.record!.price.toString();
    }
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
                children: <Widget>[Text('レコード管理'), SizedBox.shrink()],
              ),
              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
              _displayInputParts(),

              //              Expanded(child: displayActionNameList()),
            ],
          ),
        ),
      ),
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
                const SizedBox(height: 10),

                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _showDP(),
                      child: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                    ),

                    const SizedBox(width: 10),

                    Expanded(child: Text(appParamState.selectedDate)),
                  ],
                ),

                // const SizedBox(height: 10),
                //
                // // ignore: always_specify_types
                // DropdownButton(
                //   isExpanded: true,
                //   dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                //   iconEnabledColor: Colors.white,
                //   items:
                //       categoryNames.map((String e) {
                //         // ignore: always_specify_types
                //         return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)));
                //       }).toList(),
                //   value: appParamState.selectedCategory,
                //
                //   onChanged: (String? value) {
                //     appParamNotifier.setSelectedCategory(category: value!);
                //   },
                // ),

                // const SizedBox(height: 10),
                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children:
                //       widget.actionNameList!.map((ActionName e) {
                //         return GestureDetector(
                //           onTap: () {
                //             appParamNotifier.setSelectedAction(action: e.name);
                //           },
                //           child: CircleAvatar(
                //             backgroundColor:
                //                 (e.name == appParamState.selectedAction)
                //                     ? Colors.yellowAccent.withValues(alpha: 0.3)
                //                     : Colors.blueGrey.withValues(alpha: 0.6),
                //
                //             child: Text(e.name, style: const TextStyle(fontSize: 10, color: Colors.black)),
                //           ),
                //         );
                //       }).toList(),
                // ),
                const SizedBox(height: 20),

                TextField(
                  controller: priceEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: '金額(10桁以内)',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[0],
                  onTap: () => context.showKeyboard(focusNodeList[0]),
                ),

                const SizedBox(height: 10),

                if (widget.record != null)
                  ElevatedButton(
                    onPressed: () {
                      _updateRecord();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('更新'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      _inputRecord();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('登録'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _showDP() async {
    final DateTime? selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      appParamNotifier.setSelectedDate(date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _inputRecord() async {
    bool errFlg = false;

    if (priceEditingController.text.trim() == '' || appParamState.selectedDate == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[priceEditingController.text.trim(), 10],
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

    final Record record =
        Record()
          ..date = appParamState.selectedDate
          ..price = priceEditingController.text.trim().toInt();

    // ignore: always_specify_types
    RecordsRepository().inputRecord(isar: widget.isar, record: record).then((value) {
      if (mounted) {
        priceEditingController.clear();

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
  Future<void> _updateRecord() async {
    bool errFlg = false;

    if (priceEditingController.text.trim() == '' || appParamState.selectedDate == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[priceEditingController.text.trim(), 10],
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
      await RecordsRepository().getRecord(isar: widget.isar, id: widget.record!.id).then((Record? value) async {
        value!
          ..date = appParamState.selectedDate
          ..price = priceEditingController.text.trim().toInt();

        await RecordsRepository().updateRecord(isar: widget.isar, record: value)
        // ignore: always_specify_types
        .then((value) {
          if (mounted) {
            priceEditingController.clear();

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
}
