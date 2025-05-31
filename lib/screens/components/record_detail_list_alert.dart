import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/record_detail.dart';
import '../../extensions/extensions.dart';

class RecordDetailListAlert extends ConsumerStatefulWidget {
  const RecordDetailListAlert({
    super.key,
    required this.isar,
    required this.date,
    required this.recordDetailList,
    required this.sagaku,
  });

  final Isar isar;
  final String date;
  final int sagaku;

  final List<RecordDetail> recordDetailList;

  @override
  ConsumerState<RecordDetailListAlert> createState() => _RecordDetailListAlertState();
}

class _RecordDetailListAlertState extends ConsumerState<RecordDetailListAlert> {
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
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(widget.date), Text(widget.sagaku.toString().toCurrency())],
                  ),

                  ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                    child: const Text('input'),
                  ),
                ],
              ),

              Divider(color: Colors.white.withValues(alpha: 0.3), thickness: 5),

              Expanded(child: displayRecordDetailList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayRecordDetailList() {
    final List<Widget> list = <Widget>[];

    int sum = 0;
    for (final RecordDetail element in widget.recordDetailList) {
      list.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text(element.category), Text(element.action)],
              ),
            ),

            Text(element.price.toString().toCurrency()),
          ],
        ),
      );

      sum += element.price;
    }

    list.add(const Divider());

    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[const SizedBox.shrink(), Text(sum.toString().toCurrency())],
      ),
    );

    if (widget.sagaku != sum) {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox.shrink(),
            Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
          ],
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
