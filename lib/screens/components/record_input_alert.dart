import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/record.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/records_repository.dart';
import '../../utilities/functions.dart';
import '../home_screen.dart';
import '../parts/error_dialog.dart';

class RecordInputAlert extends ConsumerStatefulWidget {
  const RecordInputAlert({super.key, required this.isar, required this.date, this.record});

  final Isar isar;
  final String date;
  final Record? record;

  @override
  ConsumerState<RecordInputAlert> createState() => _RecordInputAlertState();
}

class _RecordInputAlertState extends ConsumerState<RecordInputAlert> with ControllersMixin<RecordInputAlert> {
  TextEditingController priceEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());

    if (widget.record != null) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text('Record Input'), Text(widget.date)],
              ),
              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),

              _displayInputParts(),
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

                const SizedBox(height: 20),

                if (widget.record != null)
                  ElevatedButton(
                    onPressed: () => _updateRecord(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('更新'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => _inputRecord(),
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
  Future<void> _inputRecord() async {
    bool errFlg = false;

    if (priceEditingController.text.trim() == '') {
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

    final Record record = Record()
      ..date = widget.date
      ..price = priceEditingController.text.toInt();

    // ignore: always_specify_types
    RecordsRepository().inputRecord(isar: widget.isar, record: record).then((value) {
      priceEditingController.clear();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      appParamNotifier.setSelectedListYearmonth(yearmonth: '${widget.date.split('-')[0]}-${widget.date.split('-')[1]}');

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,

        // ignore: inference_failure_on_instance_creation, always_specify_types
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar)),
      );
    });
  }

  ///
  Future<void> _updateRecord() async {
    bool errFlg = false;

    if (priceEditingController.text.trim() == '') {
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

    await RecordsRepository().deleteRecord(isar: widget.isar, id: widget.record!.id).then((value) {
      final Record record = Record()
        ..date = widget.date
        ..price = priceEditingController.text.toInt();

      // ignore: always_specify_types
      RecordsRepository().inputRecord(isar: widget.isar, record: record).then((value) {
        priceEditingController.clear();

        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        appParamNotifier.setSelectedListYearmonth(
          yearmonth: '${widget.date.split('-')[0]}-${widget.date.split('-')[1]}',
        );

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,

          // ignore: inference_failure_on_instance_creation, always_specify_types
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen(isar: widget.isar)),
        );
      });
    });
  }
}
