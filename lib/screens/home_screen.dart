import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/action_name.dart';
import '../collections/category_name.dart';
import '../collections/record.dart';
import '../collections/record_detail.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../repository/action_names_repository.dart';
import '../repository/category_names_repository.dart';
import '../repository/record_details_repository.dart';
import '../repository/records_repository.dart';
import 'components/action_name_input_alert.dart';
import 'components/category_name_input_alert.dart';
import 'components/csv_data/data_export_alert.dart';
import 'components/csv_data/data_import_alert.dart';

// import 'components/record_detail_list_alert.dart';
//
//

import 'components/record_detail_list_alert.dart';
import 'components/record_input_alert.dart';
import 'parts/rakuten_points_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  List<CategoryName>? categoryNameList;

  List<ActionName>? actionNameList;

  List<Record>? recordList;

  List<RecordDetail>? recordDetailList;

  Map<String, List<RecordDetail>> recordDetailMap = <String, List<RecordDetail>>{};

  ///
  void _init() {
    _makeCategoryNameList();

    _makeActionNameList();

    _makeRecordList();

    _makeRecordDetailList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rakuten Point'),

        centerTitle: true,

        actions: <Widget>[
          IconButton(
            onPressed: () {
              RakutenPointsDialog(
                context: context,
                widget: RecordInputAlert(
                  isar: widget.isar,

                  // categoryNameList: categoryNameList,
                  // actionNameList: actionNameList,
                  //
                  //
                  //
                ),
              );
            },
            icon: const Icon(Icons.input),
          ),
        ],
      ),

      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 70, right: 10, bottom: 10, left: 10),

              // ignore: always_specify_types
              child: FutureBuilder(
                future: getFutureRecordList(),

                builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // ignore: literal_only_boolean_expressions
                        if (appParamState.selectedListYearmonth !=
                            '${snapshot.data![index].date.split('-')[0]}-${snapshot.data![index].date.split('-')[1]}') {
                          return const SizedBox.shrink();
                        }

                        int sagaku = 0;
                        if (index > 0) {
                          sagaku = snapshot.data![index - 1].price - snapshot.data![index].price;
                        }

                        return ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                            ),

                            child: DefaultTextStyle(
                              style: const TextStyle(fontSize: 12),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    alignment: Alignment.topLeft,

                                    child: (index == 0)
                                        ? const SizedBox.shrink()
                                        : GestureDetector(
                                            onTap: () {
                                              RakutenPointsDialog(
                                                context: context,
                                                widget: RecordDetailListAlert(
                                                  isar: widget.isar,
                                                  date: recordList![index].date,

                                                  sagaku: sagaku,

                                                  recordDetailList:
                                                      recordDetailMap[recordList![index].date] ?? <RecordDetail>[],
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.blueGrey.withValues(alpha: 0.2),
                                              radius: 15,
                                            ),
                                          ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(snapshot.data![index].date),

                                        if (index == 0)
                                          Text(snapshot.data![index].price.toString().toCurrency())
                                        else
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(snapshot.data![index].price.toString().toCurrency()),

                                              Text(
                                                sagaku.toString().toCurrency(),
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  IconButton(
                                    onPressed: () {
                                      RakutenPointsDialog(
                                        context: context,
                                        widget: RecordInputAlert(
                                          isar: widget.isar,

                                          // categoryNameList: categoryNameList,
                                          // actionNameList: actionNameList,
                                          //
                                          //
                                          //
                                          //
                                          record: snapshot.data![index],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          Positioned(top: 10, right: 10, left: 10, child: displayYearmonthList()),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.blueGrey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100),

              TextButton(
                onPressed: () {
                  RakutenPointsDialog(
                    context: context,
                    widget: CategoryNameInputAlert(isar: widget.isar, categoryNameList: categoryNameList),
                  );
                },
                child: const Text('input category'),
              ),

              TextButton(
                onPressed: () {
                  RakutenPointsDialog(
                    context: context,
                    widget: ActionNameInputAlert(isar: widget.isar, actionNameList: actionNameList),
                  );
                },
                child: const Text('input action'),
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              TextButton(
                onPressed: () => RakutenPointsDialog(
                  context: context,
                  widget: DataExportAlert(isar: widget.isar),
                ),
                child: const Text('データエクスポート'),
              ),
              TextButton(
                onPressed: () => RakutenPointsDialog(
                  context: context,
                  widget: DataImportAlert(isar: widget.isar),
                ),
                child: const Text('データインポート'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayYearmonthList() {
    final DateTime startDate = DateTime(2024, 3, 12);

    final DateTime today = DateTime.now();

    final int diff = today.difference(startDate).inDays;

    final List<String> yearmonthList = <String>[];
    for (int i = 0; i < diff; i++) {
      final String yearmonth = startDate.add(Duration(days: i)).yyyymm;
      if (!yearmonthList.contains(yearmonth)) {
        yearmonthList.add(yearmonth);
      }
    }

    return SizedBox(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: yearmonthList.map((String e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  appParamNotifier.setSelectedListYearmonth(yearmonth: e);
                },
                child: CircleAvatar(
                  backgroundColor: (e == appParamState.selectedListYearmonth)
                      ? Colors.yellowAccent.withValues(alpha: 0.2)
                      : Colors.blueGrey.withValues(alpha: 0.2),

                  child: Text(e, style: const TextStyle(fontSize: 10)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ///
  Future<List<Record>> getFutureRecordList() async {
    List<Record> list = <Record>[];

    await RecordsRepository().getRecordList(isar: widget.isar).then((List<Record>? value) {
      if (value != null) {
        list = value;
      }
    });

    return list;
  }

  //
  //
  //
  //
  //
  // ///
  // Widget displayYearmonthList() {
  //   final List<String> yearmonth = <String>[];
  //
  //   recordList?.forEach((Record element) {
  //     final List<String> exDate = element.date.split('-');
  //
  //     if (!yearmonth.contains('${exDate[0]}-${exDate[1]}')) {
  //       yearmonth.add('${exDate[0]}-${exDate[1]}');
  //     }
  //   });
  //
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: yearmonth.map((String e) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 5),
  //           child: GestureDetector(
  //             onTap: () {
  //               appParamNotifier.setSelectedListYearmonth(yearmonth: e);
  //             },
  //             child: CircleAvatar(
  //               backgroundColor: (e == appParamState.selectedListYearmonth)
  //                   ? Colors.yellowAccent.withValues(alpha: 0.2)
  //                   : Colors.blueGrey.withValues(alpha: 0.2),
  //
  //               child: Text(e, style: const TextStyle(fontSize: 10)),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
  //
  //
  //
  //
  //
  //

  ///
  Future<void> _makeCategoryNameList() async => CategoryNamesRepository()
      .getCategoryNameList(isar: widget.isar)
      .then((List<CategoryName>? value) => categoryNameList = value);

  ///
  Future<void> _makeActionNameList() async => ActionNamesRepository()
      .getActionNameList(isar: widget.isar)
      .then((List<ActionName>? value) => actionNameList = value);

  ///
  Future<void> _makeRecordList() async =>
      RecordsRepository().getRecordList(isar: widget.isar).then((List<Record>? value) => recordList = value);

  //
  //
  //
  //
  //
  // ///
  // Widget displayRecordList() {
  //   final List<Widget> list = <Widget>[];
  //
  //   if (recordList != null) {
  //     for (int i = 0; i < recordList!.length; i++) {
  //       final int sagaku = (i == 0) ? 0 : recordList![i - 1].price - recordList![i].price;
  //
  //       if (appParamState.selectedListYearmonth ==
  //           '${recordList![i].date.split('-')[0]}-${recordList![i].date.split('-')[1]}') {
  //         list.add(
  //           Container(
  //             decoration: BoxDecoration(
  //               border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
  //             ),
  //
  //             child: Row(
  //               children: <Widget>[
  //                 Container(
  //                   width: 50,
  //                   alignment: Alignment.topLeft,
  //
  //                   child: (i == 0)
  //                       ? const SizedBox.shrink()
  //                       : GestureDetector(
  //                           onTap: () {
  //                             RakutenPointsDialog(
  //                               context: context,
  //                               widget: RecordDetailListAlert(
  //                                 isar: widget.isar,
  //                                 date: recordList![i].date,
  //
  //                                 sagaku: sagaku,
  //
  //                                 recordDetailList: recordDetailMap[recordList![i].date] ?? <RecordDetail>[],
  //                               ),
  //                             );
  //                           },
  //
  //                           child: CircleAvatar(backgroundColor: Colors.blueGrey.withValues(alpha: 0.2), radius: 15),
  //                         ),
  //                 ),
  //
  //                 Expanded(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       Text(recordList![i].date),
  //
  //                       if (i == 0)
  //                         Text(recordList![i].price.toString().toCurrency())
  //                       else
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children: <Widget>[
  //                             Text(recordList![i].price.toString().toCurrency()),
  //
  //                             Text(sagaku.toString().toCurrency(), style: const TextStyle(color: Colors.grey)),
  //                           ],
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 const SizedBox(width: 20),
  //
  //                 IconButton(
  //                   onPressed: () {
  //                     RakutenPointsDialog(
  //                       context: context,
  //                       widget: RecordInputAlert(
  //                         isar: widget.isar,
  //
  //                         // categoryNameList: categoryNameList,
  //                         // actionNameList: actionNameList,
  //                         //
  //                         //
  //                         //
  //                         record: recordList![i],
  //                       ),
  //                     );
  //                   },
  //                   icon: Icon(Icons.edit, color: Colors.white.withValues(alpha: 0.3)),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //   return SingleChildScrollView(
  //     child: DefaultTextStyle(
  //       style: const TextStyle(fontSize: 12),
  //       child: Column(children: list),
  //     ),
  //   );
  // }
  //
  //
  //
  //
  //

  ///
  Future<void> _makeRecordDetailList() async {
    recordDetailMap = <String, List<RecordDetail>>{};

    return RecordDetailsRepository().getRecordDetailList(isar: widget.isar).then((List<RecordDetail>? value) {
      recordDetailList = value;

      if (value != null) {
        for (final RecordDetail element in value) {
          (recordDetailMap[element.date] ??= <RecordDetail>[]).add(element);
        }
      }
    });
  }
}
