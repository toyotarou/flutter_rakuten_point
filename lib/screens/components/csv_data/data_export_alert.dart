import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

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

part 'data_export_alert.freezed.dart';
part 'data_export_alert.g.dart';

class DataExportAlert extends ConsumerStatefulWidget {
  const DataExportAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<DataExportAlert> createState() => _DummyDownloadAlertState();
}

class _DummyDownloadAlertState extends ConsumerState<DataExportAlert> {
  List<String> outputValuesList = <String>[];

  List<XFile> sendFileList = <XFile>[];
  List<String> sendFileNameList = <String>[];

  List<String> displayFileNameList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    outputValuesList.clear();

    sendFileNameList.clear();
    sendFileList.clear();

    displayFileNameList.clear();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final String csvName = ref.watch(dataExportProvider.select((DataExportState value) => value.csvName));

    final List<String> colorChangeFileNameList = <String>[];
    for (final String element in displayFileNameList) {
      colorChangeFileNameList.add(element.split('_')[0]);
    }

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: context.screenSize.width),
                const SizedBox(height: 20),
                const Text('データエクスポート'),
                Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <String>['actionNames', 'categoryNames', 'records', 'recordDetails'].map((String e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              ref.read(dataExportProvider.notifier).setCsvName(csvName: e);
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: (colorChangeFileNameList.contains(e))
                                  ? Colors.greenAccent.withValues(alpha: 0.3)
                                  : (csvName == e)
                                  ? Colors.yellowAccent.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(e),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => csvOutput(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2)),
                        child: const Text('csv選択'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => csvSend(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2)),
                        child: const Text('送信'),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayFileNameList.map((String e) {
                    return Text(e);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> csvOutput() async {
    outputValuesList.clear();

    final String csvName = ref.watch(dataExportProvider.select((DataExportState value) => value.csvName));

    if (csvName == '') {
      getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

      return;
    }

    outputValuesList.add('export_csv_from_rakuten_point');

    switch (csvName) {
      case 'actionNames':
        await ActionNamesRepository().getActionNameList(isar: widget.isar).then((List<ActionName>? value) {
          value?.forEach((ActionName element) {
            outputValuesList.add(<String>[element.id.toString(), element.name].join(','));
          });
        });

      case 'categoryNames':
        await CategoryNamesRepository().getCategoryNameList(isar: widget.isar).then((List<CategoryName>? value) {
          value?.forEach((CategoryName element) {
            outputValuesList.add(<String>[element.id.toString(), element.name].join(','));
          });
        });

      case 'records':
        await RecordsRepository().getRecordList(isar: widget.isar).then((List<Record>? value) {
          value?.forEach((Record element) {
            outputValuesList.add(<String>[element.id.toString(), element.date, element.price.toString()].join(','));
          });
        });

      case 'recordDetails':
        await RecordDetailsRepository().getRecordDetailList(isar: widget.isar).then((List<RecordDetail>? value) {
          value?.forEach((RecordDetail element) {
            outputValuesList.add(
              <String>[
                element.id.toString(),
                element.date,
                element.category,
                element.action,
                element.price.toString(),
              ].join(','),
            );
          });
        });
    }

    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HHmmss');
    final String currentTime = timeFormat.format(now);

    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');

    final String dateStr = '${csvName}_$year$month$day$currentTime';
    final String sendFileName = '$dateStr.csv';

    final String contents = outputValuesList.join('\n');

    // final Uint8List encoded =
    //     await CharsetConverter.encode('Shift_JIS', contents);

    final List<int> byteList = utf8.encode(contents);

    final Uint8List encoded = Uint8List.fromList(byteList);

    sendFileNameList.add(sendFileName);
    sendFileList.add(XFile.fromData(encoded, mimeType: 'text/plain'));

    setState(() {
      displayFileNameList = sendFileNameList;
    });
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
  Future<void> csvSend() async {
    if (sendFileList.isEmpty || sendFileNameList.isEmpty) {
      getErrorDialog(title: '送信できません。', content: '送信するデータを正しく選択してください。');

      return;
    }

    final RenderBox? box = context.findRenderObject() as RenderBox?;

    // ignore: deprecated_member_use
    await Share.shareXFiles(
      sendFileList,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      fileNameOverrides: sendFileNameList,
    );

    if (mounted) {
      outputValuesList.clear();

      sendFileNameList.clear();
      sendFileList.clear();

      Navigator.pop(context);
    }
  }
}

@freezed
class DataExportState with _$DataExportState {
  const factory DataExportState({@Default('') String csvName}) = _DummyDownloadState;
}

@riverpod
class DataExport extends _$DataExport {
  ///
  @override
  DataExportState build() => const DataExportState();

  ///
  void setCsvName({required String csvName}) => state = state.copyWith(csvName: csvName);
}
