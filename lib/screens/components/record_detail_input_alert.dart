import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/record.dart';
import '../../extensions/extensions.dart';

class RecordDetailInputAlert extends ConsumerStatefulWidget {
  const RecordDetailInputAlert({super.key, required this.isar, required this.date, this.record});

  final Isar isar;
  final String date;
  final Record? record;

  @override
  ConsumerState<RecordDetailInputAlert> createState() => _RecordDetailInputAlertState();
}

class _RecordDetailInputAlertState extends ConsumerState<RecordDetailInputAlert> {
  final List<TextEditingController> _priceTecs = <TextEditingController>[];

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    try {
      _makeTecs();
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  Future<void> _makeTecs() async {
    for (int i = 0; i < 10; i++) {
      _priceTecs.add(TextEditingController(text: ''));
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
                children: <Widget>[const Text('Record Detail Input'), Text(widget.date)],
              ),
              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),

              Expanded(child: _displayInputParts()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < 10; i++) {
      // final String item = spendTimePlacesControllerState.spendItem[i];
      // final String time = spendTimePlacesControllerState.spendTime[i];
      // final int price = spendTimePlacesControllerState.spendPrice[i];
      // final String place = spendTimePlacesControllerState.spendPlace[i];

      list.add(
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5,
                right: 15,
                child: Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                ),
              ),
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _priceTecs[i],
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        hintText: '金額(10桁以内)',
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                      ),
                      style: const TextStyle(fontSize: 12),

                      // onChanged: (String value) =>
                      //     spendTimePlacesNotifier.setSpendPrice(pos: i, price: (value == '') ? 0 : value.toInt()),
                      //
                      //
                      //
                      onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                      focusNode: focusNodeList[i],
                      onTap: () => context.showKeyboard(focusNodeList[i]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
