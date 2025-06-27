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

  Map<String, Record> recordMap = <String, Record>{};

  List<RecordDetail>? recordDetailList;

  Map<String, List<RecordDetail>> recordDetailMap = <String, List<RecordDetail>>{};

  List<GlobalKey> globalKeyList = <GlobalKey<State<StatefulWidget>>>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    globalKeyList = List.generate(300, (int index) => GlobalKey());

    _makeCategoryNameList();

    _makeActionNameList();

    _makeRecordList();

    _makeRecordDetailList();

    // ignore: always_specify_types
    Future(() {
      appParamNotifier.setSelectedListYearmonth(yearmonth: DateTime.now().yyyymm);
    });
  }

  //
  // ///
  // void _init() {
  //   _makeCategoryNameList();
  //
  //   _makeActionNameList();
  //
  //   _makeRecordList();
  //
  //   _makeRecordDetailList();
  // }
  //
  //
  //

  ///
  @override
  Widget build(BuildContext context) {
    // // ignore: always_specify_types
    // Future(_init);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rakuten Point'),

        centerTitle: true,

        actions: <Widget>[
          IconButton(
            onPressed: () {
              appParamNotifier.setSelectedListYearmonth(yearmonth: DateTime.now().yyyymm);

              Navigator.pushReplacement(
                context,
                // ignore: inference_failure_on_instance_creation, always_specify_types
                MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar)),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            displayYearmonthList(),

            Expanded(child: displayRecordList()),

            const SizedBox(height: 50),
          ],
        ),
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
                    clearBarrierColor: true,
                  );
                },
                child: const Text('input category'),
              ),

              TextButton(
                onPressed: () {
                  RakutenPointsDialog(
                    context: context,
                    widget: ActionNameInputAlert(isar: widget.isar, actionNameList: actionNameList),
                    clearBarrierColor: true,
                  );
                },
                child: const Text('input action'),
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              TextButton(
                onPressed: () => RakutenPointsDialog(
                  context: context,
                  widget: DataExportAlert(isar: widget.isar),
                  clearBarrierColor: true,
                ),
                child: const Text('データエクスポート'),
              ),
              TextButton(
                onPressed: () => RakutenPointsDialog(
                  context: context,
                  widget: DataImportAlert(isar: widget.isar),
                  clearBarrierColor: true,
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
  Widget displayRecordList() {
    final List<Widget> list = <Widget>[];

    final DateTime startDate = DateTime(2024, 3, 12);

    final DateTime today = DateTime.now();

    final int diff = today.difference(startDate).inDays;

    int lastPrice = 0;

    String keepYearmonth = '';

    int j = 0;
    for (int i = 0; i < diff + 1; i++) {
      final String date = startDate.add(Duration(days: i)).yyyymmdd;

      final String yearmonth = startDate.add(Duration(days: i)).yyyymm;

      if (keepYearmonth != yearmonth) {
        list.add(
          Container(
            key: globalKeyList[j],
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(yearmonth), const SizedBox.shrink()],
              ),
            ),
          ),
        );

        j++;
      }

      int sagaku = 0;
      if (recordMap[date] != null) {
        sagaku = lastPrice - recordMap[date]!.price;
      }

      int sum = 0;
      if (recordDetailMap[date] != null) {
        for (final RecordDetail element in recordDetailMap[date]!) {
          sum += element.price;
        }
      }

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.screenSize.height / 12),

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(date),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () {
                            RakutenPointsDialog(
                              context: context,
                              widget: RecordInputAlert(isar: widget.isar, date: date, record: recordMap[date]),
                              clearBarrierColor: true,
                            );
                          },
                          child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text((recordMap[date] != null) ? recordMap[date]!.price.toString().toCurrency() : ''),

                          const SizedBox(height: 5),

                          if (i == 0 || recordMap[date] == null)
                            const Column(children: <Widget>[SizedBox.shrink(), SizedBox.shrink()])
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  sagaku.toString().toCurrency(),
                                  style: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  sum.toString().toCurrency(),
                                  style: TextStyle(color: Colors.purpleAccent.withValues(alpha: 0.6)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 60,
                      child: (recordMap[date] != null && i > 0)
                          ? IconButton(
                              onPressed: () {
                                RakutenPointsDialog(
                                  context: context,
                                  widget: RecordDetailListAlert(
                                    isar: widget.isar,
                                    date: date,
                                    record: recordMap[date],

                                    sagaku: sagaku,
                                  ),
                                  clearBarrierColor: true,
                                );
                              },
                              icon: Icon(Icons.info_outline, color: Colors.white.withValues(alpha: 0.4)),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      keepYearmonth = yearmonth;

      if (recordMap[date] != null) {
        lastPrice = recordMap[date]!.price;
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Widget displayYearmonthList() {
    final List<Widget> list = <Widget>[];

    final DateTime startDate = DateTime(2024, 3, 12);

    final DateTime today = DateTime.now();

    final int diff = today.difference(startDate).inDays;

    final List<String> yearmonthList = <String>[];
    for (int i = 0; i < diff + 1; i++) {
      final String yearmonth = startDate.add(Duration(days: i)).yyyymm;
      if (!yearmonthList.contains(yearmonth)) {
        yearmonthList.add(yearmonth);
      }
    }

    for (int i = 0; i < yearmonthList.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSelectedListYearmonth(yearmonth: yearmonthList[i]);

              scrollToIndex(i);
            },
            child: CircleAvatar(
              backgroundColor: (yearmonthList[i] == appParamState.selectedListYearmonth)
                  ? Colors.yellowAccent.withValues(alpha: 0.2)
                  : Colors.blueGrey.withValues(alpha: 0.2),

              child: Text(yearmonthList[i], style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 50,

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: list),
      ),
    );
  }

  ///
  Future<void> _makeCategoryNameList() async => CategoryNamesRepository()
      .getCategoryNameList(isar: widget.isar)
      .then((List<CategoryName>? value) => categoryNameList = value);

  ///
  Future<void> _makeActionNameList() async => ActionNamesRepository()
      .getActionNameList(isar: widget.isar)
      .then((List<ActionName>? value) => actionNameList = value);

  ///
  Future<void> _makeRecordList() async {
    recordMap.clear();

    return RecordsRepository().getRecordList(isar: widget.isar).then((List<Record>? value) {
      recordList = value;

      if (value != null) {
        for (final Record element in value) {
          recordMap[element.date] = element;
        }
      }
    });
  }

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

  ///
  Future<void> scrollToIndex(int index) async {
    final BuildContext target = globalKeyList[index].currentContext!;

    await Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 1000));
  }
}
