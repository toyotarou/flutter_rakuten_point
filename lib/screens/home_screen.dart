import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/action_name.dart';
import '../collections/category_name.dart';
import '../collections/record.dart';
import '../extensions/extensions.dart';
import '../repository/action_names_repository.dart';
import '../repository/category_names_repository.dart';
import '../repository/records_repository.dart';
import 'components/action_name_input_alert.dart';
import 'components/category_name_input_alert.dart';
import 'components/csv_data/data_export_alert.dart';
import 'components/csv_data/data_import_alert.dart';
import 'components/record_input_alert.dart';
import 'parts/rakuten_points_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<CategoryName>? categoryNameList;

  List<ActionName>? actionNameList;

  List<Record>? recordList;

  ///
  @override
  void initState() {
    super.initState();

    _makeCategoryNameList();

    _makeActionNameList();
  }

  bool makeRecordListFlag = false;

  ///
  @override
  Widget build(BuildContext context) {
    if (!makeRecordListFlag) {
      _makeRecordList();

      makeRecordListFlag = true;
    }

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

                  categoryNameList: categoryNameList,
                  actionNameList: actionNameList,
                ),
              );
            },
            icon: const Icon(Icons.input),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),

          // ignore: always_specify_types
          child: FutureBuilder(
            future: getFutureRecordList(),

            builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                    : CircleAvatar(backgroundColor: Colors.blueGrey.withValues(alpha: 0.2), radius: 15),
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

                                      categoryNameList: categoryNameList,
                                      actionNameList: actionNameList,
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
}
