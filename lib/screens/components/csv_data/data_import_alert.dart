import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../../collections/action_name.dart';
import '../../../collections/category_name.dart';
import '../../../collections/record.dart';
import '../../../collections/record_detail.dart';
import '../../../extensions/extensions.dart';
import '../../../repository/action_names_repository.dart';
import '../../../repository/category_names_repository.dart';
import '../../../repository/record_details_repository.dart';
import '../../../repository/records_repository.dart';
import '../../parts/error_dialog.dart';

class DataImportAlert extends StatefulWidget {
  const DataImportAlert({super.key, required this.isar});

  final Isar isar;

  @override
  State<DataImportAlert> createState() => _DataImportAlertState();
}

class _DataImportAlertState extends State<DataImportAlert> {
  String fileName = '';

  String csvName = '';

  List<String> csvContentsList = <String>[];

  List<dynamic> importDataList = <dynamic>[];
  int importDataListLength = 0;

  ///
  @override
  void initState() {
    super.initState();

    fileName = '';

    csvName = '';

    csvContentsList = <String>[];

    importDataList = <dynamic>[];
  }

  ///
  Future<void> _pickAndLoadCsvFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['csv'],
    );

    if (result != null) {
      ///
      fileName = result.files.single.name;

      csvName = fileName.split('_')[0];

      ///
      final File file = File(result.files.single.path!);
      final String csvString = await file.readAsString();
      final List<String> exCsvString = csvString.split('\n');

      if (exCsvString[0].trim() != 'export_csv_from_rakuten_point') {
        setState(() {
          fileName = '';

          csvName = '';

          csvContentsList = <String>[];

          importDataList = <dynamic>[];
        });

        getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

        return;
      }

      setState(() {
        csvContentsList = exCsvString;
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),
              const SizedBox(height: 20),
              const Text('データインポート'),
              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickAndLoadCsvFile,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2)),
                      child: const Text('CSV選択'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: registData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2)),
                      child: const Text('登録'),
                    ),
                  ),
                ],
              ),

              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
              Text(fileName),
              if (csvContentsList.isNotEmpty) ...<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Text('${csvContentsList.length} records.', style: const TextStyle(color: Colors.yellowAccent)),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Expanded(child: displayCsvContents()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayCsvContents() {
    switch (csvName) {
      case 'actionNames':
        importDataList = <ActionName>[];

      case 'categoryNames':
        importDataList = <CategoryName>[];

      case 'records':
        importDataList = <Record>[];

      case 'recordDetails':
        importDataList = <RecordDetail>[];
    }

    final List<Widget> widgetList = <Widget>[];

    for (int i = 1; i < csvContentsList.length; i++) {
      final List<String> exLine = csvContentsList[i].split(',');

      final List<Widget> widgetList2 = <Widget>[];

      for (int j = 1; j < exLine.length; j++) {
        widgetList2.add(
          Container(
            width: context.screenSize.width / 3,
            decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
            child: Text(exLine[j], maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      }

      widgetList.add(Row(children: widgetList2));

      switch (csvName) {
        case 'actionNames':
          importDataList.add(ActionName()..name = exLine[1].trim());

        case 'categoryNames':
          importDataList.add(CategoryName()..name = exLine[1].trim());

        case 'records':
          importDataList.add(
            Record()
              ..date = exLine[1].trim()
              ..price = exLine[2].trim().toInt(),
          );

        case 'recordDetails':
          importDataList.add(
            RecordDetail()
              ..date = exLine[1].trim()
              ..category = exLine[2].trim()
              ..action = exLine[3].trim()
              ..price = exLine[4].trim().toInt(),
          );
      }
    }

    setState(() {
      importDataListLength = importDataList.length;
    });

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgetList),
      ),
    );
  }

  ///
  void getErrorDialog({required String title, required String content}) {
    // ignore: always_specify_types
    Future.delayed(Duration.zero, () {
      if (mounted) {
        return error_dialog(context: context, title: title, content: content);
      }
    });
  }

  ///
  Future<void> registData() async {
    if ((csvContentsList.length - 1) != importDataList.length) {
      getErrorDialog(title: '登録できません。', content: '登録するデータが正しく選択されていません。');

      return;
    }

    await widget.isar.writeTxn(() async {
      switch (csvName) {
        case 'actionNames':
          await widget.isar.actionNames.clear();

        case 'categoryNames':
          await widget.isar.categoryNames.clear();

        case 'records':
          await widget.isar.records.clear();

        case 'recordDetails':
          await widget.isar.recordDetails.clear();
      }
    });

    switch (csvName) {
      case 'actionNames':
        ActionNamesRepository()
            .inputActionNameList(isar: widget.isar, actionNameList: importDataList as List<ActionName>)
            // ignore: always_specify_types
            .then((value) {
              if (mounted) {
                Navigator.pop(context);
              }
            });

      case 'categoryNames':
        CategoryNamesRepository()
            .inputCategoryNameList(isar: widget.isar, categoryNameList: importDataList as List<CategoryName>)
            // ignore: always_specify_types
            .then((value) {
              if (mounted) {
                Navigator.pop(context);
              }
            });

      case 'records':
        RecordsRepository().inputRecordList(isar: widget.isar, recordList: importDataList as List<Record>).then((
          // ignore: always_specify_types
          value,
        ) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'recordDetails':
        RecordDetailsRepository()
            .inputRecordDetailList(isar: widget.isar, recordDetailList: importDataList as List<RecordDetail>)
            // ignore: always_specify_types
            .then((value) {
              if (mounted) {
                Navigator.pop(context);
              }
            });
    }
  }
}
