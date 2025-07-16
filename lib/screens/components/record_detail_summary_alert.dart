import 'package:flutter/material.dart';

import '../../collections/action_name.dart';
import '../../collections/category_name.dart';
import '../../collections/record_detail.dart';
import '../../extensions/extensions.dart';

class RecordDetailSummaryAlert extends StatefulWidget {
  const RecordDetailSummaryAlert({
    super.key,
    required this.yearmonth,
    required this.categoryNameList,
    required this.actionNameList,
    required this.recordDetailList,
  });

  final String yearmonth;
  final List<CategoryName> categoryNameList;
  final List<ActionName> actionNameList;
  final List<RecordDetail> recordDetailList;

  @override
  State<RecordDetailSummaryAlert> createState() => _RecordDetailSummaryAlertState();
}

class _RecordDetailSummaryAlertState extends State<RecordDetailSummaryAlert> {
  List<RecordDetail> monthlyRecordDetailList = <RecordDetail>[];

  ///
  @override
  void initState() {
    super.initState();

    makeMonthlyRecordDetailList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.yearmonth), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),

                Expanded(child: displayMonthlyRecordDetailList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void makeMonthlyRecordDetailList() {
    for (final RecordDetail element in widget.recordDetailList) {
      if (widget.yearmonth == '${element.date.split('-')[0]}-${element.date.split('-')[1]}') {
        monthlyRecordDetailList.add(element);
      }
    }
  }

  ///
  Widget displayMonthlyRecordDetailList() {
    final List<Widget> list = <Widget>[];

    final Map<String, List<int>> categoryActionRecordDetailMap = <String, List<int>>{};

    for (final CategoryName element in widget.categoryNameList) {
      for (final ActionName element2 in widget.actionNameList) {
        final List<int> prices = <int>[];
        for (final RecordDetail element3 in monthlyRecordDetailList) {
          if (element.name.trim() == element3.category.trim() && element2.name.trim() == element3.action.trim()) {
            prices.add(element3.price);
          }
        }

        categoryActionRecordDetailMap['${element.name}|${element2.name}'] = prices;
      }
    }

    final Map<String, int> categoryActionPriceMap = <String, int>{};

    categoryActionRecordDetailMap.forEach((String key, List<int> value) {
      if (value.isNotEmpty) {
        int sum = 0;
        for (final int element in value) {
          sum += element;
        }
        categoryActionPriceMap[key] = sum;
      }
    });

    int sum = 0;
    categoryActionPriceMap.forEach((String key, int value) {
      final List<String> exKey = key.split('|');

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),

          child: Row(
            children: <Widget>[
              Expanded(child: Text(exKey[0])),
              Expanded(child: Text(exKey[1])),
              Expanded(
                child: Container(alignment: Alignment.topRight, child: Text(value.toString().toCurrency())),
              ),
            ],
          ),
        ),
      );

      sum += value;
    });

    list.add(const SizedBox(height: 20));

    list.add(
      Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),

        child: Row(
          children: <Widget>[
            const Expanded(child: SizedBox.shrink()),
            const Expanded(child: SizedBox.shrink()),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
              ),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(child: Column(children: list));
  }
}
