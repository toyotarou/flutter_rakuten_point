import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/action_name.dart';
import '../collections/category_name.dart';
import '../collections/record.dart';
import '../collections/record_detail.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import 'components/action_name_input_alert.dart';
import 'components/category_name_input_alert.dart';
import 'components/csv_data/data_export_alert.dart';
import 'components/csv_data/data_import_alert.dart';
import 'components/record_detail_list_alert.dart';
import 'components/record_detail_summary_alert.dart';
import 'components/record_input_alert.dart';
import 'parts/rakuten_points_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  List<String> yearmonthList = <String>[];

  List<GlobalKey> globalKeyList = <GlobalKey<State<StatefulWidget>>>[];

  List<GlobalKey> globalKeyList2 = <GlobalKey<State<StatefulWidget>>>[];

  ///
  @override
  void initState() {
    super.initState();

    //-------------------------------------------------------//
    final DateTime startDate = DateTime(2024, 3, 12);

    final DateTime today = DateTime.now();

    final int diff = today.difference(startDate).inDays;

    for (int i = 0; i < diff + 1; i++) {
      final String yearmonth = startDate.add(Duration(days: i)).yyyymm;
      if (!yearmonthList.contains(yearmonth)) {
        yearmonthList.add(yearmonth);
      }
    }
    //-------------------------------------------------------//

    // ignore: always_specify_types
    globalKeyList = List.generate(300, (int index) => GlobalKey());

    // ignore: always_specify_types
    globalKeyList2 = List.generate(300, (int index) => GlobalKey());

    // ignore: always_specify_types
    Future(() {
      appParamNotifier.setSelectedListYearmonth(yearmonth: DateTime.now().yyyymm);
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return FutureBuilder(
      future: Future.wait(<Future<List<Object>>>[
        widget.isar.categoryNames.where().findAll(),
        widget.isar.actionNames.where().findAll(),
        widget.isar.records.where().findAll(),
        widget.isar.recordDetails.where().findAll(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<List<Object>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('エラー: ${snapshot.error}');
        } else {
          final List<CategoryName> categoryNameList = snapshot.data![0] as List<CategoryName>;
          final List<ActionName> actionNameList = snapshot.data![1] as List<ActionName>;
          final List<Record> recordList = snapshot.data![2] as List<Record>;
          final List<RecordDetail> recordDetailList = snapshot.data![3] as List<RecordDetail>;

          final Map<String, Record> recordMap = <String, Record>{};
          for (final Record element in recordList) {
            recordMap[element.date] = element;
          }

          final Map<String, List<RecordDetail>> recordDetailMap = <String, List<RecordDetail>>{};
          for (final RecordDetail element in recordDetailList) {
            (recordDetailMap[element.date] ??= <RecordDetail>[]).add(element);
          }

          //================================//
          if (!appParamState.isOpenedRakutenPointDialog) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              scrollToIndex(
                yearmonthList.indexWhere((String element) => element == appParamState.selectedListYearmonth),
              );

              scrollToIndex2(
                yearmonthList.indexWhere((String element) => element == appParamState.selectedListYearmonth),
              );
            });
          }
          //================================//

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

                  Expanded(
                    child: displayRecordList(
                      recordMap: recordMap,
                      recordDetailMap: recordDetailMap,
                      categoryNameList: categoryNameList,
                      actionNameList: actionNameList,
                      recordDetailList: recordDetailList,
                    ),
                  ),

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

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                          RakutenPointsDialog(
                            context: context,
                            widget: CategoryNameInputAlert(isar: widget.isar, categoryNameList: categoryNameList),
                            clearBarrierColor: true,
                            executeFunctionWhenDialogClose: true,
                            from: 'HomeScreen',
                            ref: ref,
                          );
                        },
                        child: const Row(children: <Widget>[Text('カテゴリデータ'), SizedBox.shrink()]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                          RakutenPointsDialog(
                            context: context,
                            widget: ActionNameInputAlert(isar: widget.isar, actionNameList: actionNameList),
                            clearBarrierColor: true,
                            executeFunctionWhenDialogClose: true,
                            from: 'HomeScreen',
                            ref: ref,
                          );
                        },
                        child: const Row(children: <Widget>[Text('アクションデータ'), SizedBox.shrink()]),
                      ),
                    ),

                    Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                          RakutenPointsDialog(
                            context: context,
                            widget: DataExportAlert(isar: widget.isar),
                            clearBarrierColor: true,
                            executeFunctionWhenDialogClose: true,
                            from: 'HomeScreen',
                            ref: ref,
                          );
                        },
                        child: const Row(children: <Widget>[Text('データエクスポート'), SizedBox.shrink()]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                          RakutenPointsDialog(
                            context: context,
                            widget: DataImportAlert(isar: widget.isar),
                            clearBarrierColor: true,
                            executeFunctionWhenDialogClose: true,
                            from: 'HomeScreen',
                            ref: ref,
                          );
                        },
                        child: const Row(children: <Widget>[Text('データインポート'), SizedBox.shrink()]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  ///
  Widget displayYearmonthList() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < yearmonthList.length; i++) {
      list.add(
        Padding(
          key: globalKeyList2[i],

          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => appParamNotifier.setSelectedListYearmonth(yearmonth: yearmonthList[i]),
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
  Widget displayRecordList({
    required Map<String, Record> recordMap,
    required Map<String, List<RecordDetail>> recordDetailMap,
    required List<CategoryName> categoryNameList,
    required List<ActionName> actionNameList,
    required List<RecordDetail> recordDetailList,
  }) {
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
                children: <Widget>[
                  Text(yearmonth),

                  GestureDetector(
                    onTap: () {
                      RakutenPointsDialog(
                        context: context,
                        widget: RecordDetailSummaryAlert(
                          yearmonth: yearmonth,
                          categoryNameList: categoryNameList,
                          actionNameList: actionNameList,
                          recordDetailList: recordDetailList,
                        ),

                        clearBarrierColor: true,
                      );
                    },
                    child: const Icon(Icons.list),
                  ),
                ],
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

      //-----------------------------------------------//
      int sum = 0;

      ////////////////////////// 同数チェック
      int recordDetailCategoryCount = 0;
      int recordDetailActionCount = 0;
      int recordDetailPriceCount = 0;
      ////////////////////////// 同数チェック

      if (recordDetailMap[date] != null) {
        for (final RecordDetail element in recordDetailMap[date]!) {
          sum += element.price;

          if (element.category != '') {
            recordDetailCategoryCount++;
          }

          if (element.action != '') {
            recordDetailActionCount++;
          }

          if (element.price != 0) {
            recordDetailPriceCount++;
          }
        }
      }

      ////////////////////////// 同数チェック
      final Map<int, String> countCheck = <int, String>{};
      countCheck[recordDetailCategoryCount] = '';
      countCheck[recordDetailActionCount] = '';
      countCheck[recordDetailPriceCount] = '';
      ////////////////////////// 同数チェック

      Color circleAvatarColor = (countCheck.length == 1 && sum == sagaku)
          ? Colors.yellowAccent.withValues(alpha: 0.1)
          : Colors.transparent;

      if (recordMap[date] == null || i == 0) {
        circleAvatarColor = Colors.transparent;
      }

      //-----------------------------------------------//

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.screenSize.height / 12),

            child: Padding(
              padding: const EdgeInsets.all(5),

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 12),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(date),

                              Text((recordMap[date] != null) ? recordMap[date]!.price.toString().toCurrency() : ''),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                                      RakutenPointsDialog(
                                        context: context,
                                        widget: RecordInputAlert(
                                          isar: widget.isar,
                                          date: date,
                                          record: recordMap[date],
                                        ),
                                        clearBarrierColor: true,
                                        executeFunctionWhenDialogClose: true,
                                        from: 'HomeScreen',
                                        ref: ref,
                                      );
                                    },
                                    child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.4)),
                                  ),

                                  const SizedBox(width: 20),

                                  CircleAvatar(radius: 10, backgroundColor: circleAvatarColor),
                                ],
                              ),

                              Expanded(
                                child: (i == 0 || recordMap[date] == null)
                                    ? const Column(children: <Widget>[SizedBox.shrink(), SizedBox.shrink()])
                                    : Column(
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 60,
                    child: (recordMap[date] != null && i > 0)
                        ? IconButton(
                            onPressed: () {
                              appParamNotifier.setIsOpenedRakutenPointDialog(flag: true);

                              RakutenPointsDialog(
                                context: context,
                                widget: RecordDetailListAlert(
                                  isar: widget.isar,
                                  date: date,
                                  record: recordMap[date],
                                  sagaku: sagaku,
                                  recordDetail: recordDetailMap[date],
                                ),
                                clearBarrierColor: true,
                                executeFunctionWhenDialogClose: true,
                                from: 'HomeScreen',
                                ref: ref,
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
      );

      keepYearmonth = yearmonth;

      if (recordMap[date] != null) {
        lastPrice = recordMap[date]!.price;
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Future<void> scrollToIndex(int index) async {
    final BuildContext target = globalKeyList[index].currentContext!;

    await Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 1000));
  }

  ///
  Future<void> scrollToIndex2(int index) async {
    final BuildContext target = globalKeyList2[index].currentContext!;

    await Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 1000));
  }
}
