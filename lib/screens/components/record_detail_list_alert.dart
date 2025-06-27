import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/record.dart';
import '../../collections/record_detail.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/record_details_repository.dart';
import '../parts/rakuten_points_dialog.dart';
import 'record_detail_input_alert.dart';

class RecordDetailListAlert extends ConsumerStatefulWidget {
  const RecordDetailListAlert({
    super.key,
    required this.isar,
    required this.date,
    this.record,
    required this.sagaku,
    this.recordDetail,
  });

  final Isar isar;
  final String date;
  final Record? record;
  final int sagaku;
  final List<RecordDetail>? recordDetail;

  @override
  ConsumerState<RecordDetailListAlert> createState() => _RecordDetailListAlertState();
}

class _RecordDetailListAlertState extends ConsumerState<RecordDetailListAlert>
    with ControllersMixin<RecordDetailListAlert> {
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
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 80),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Record Detail List'),
                          const SizedBox(height: 10),
                          Text(widget.date),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: () {
                          recordDetailNotifier.clearInputValue();

                          RakutenPointsDialog(
                            context: context,
                            widget: RecordDetailInputAlert(
                              isar: widget.isar,
                              date: widget.date,
                              record: widget.record,

                              sagaku: widget.sagaku,

                              recordDetail: widget.recordDetail,
                            ),

                            clearBarrierColor: true,
                          );
                        },

                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                        child: const Text('input'),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),

                Expanded(child: displayRecordDetailList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayRecordDetailList() {
    final List<Widget> list = <Widget>[];

    widget.recordDetail?.forEach((RecordDetail element) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text(element.category), Text(element.action)],
                ),
              ),
              Expanded(
                child: Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency())),
              ),

              const SizedBox(width: 20),

              GestureDetector(
                onTap: () {
                  _showDeleteDialog(id: element.id);
                },
                child: Icon(Icons.delete, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
      onPressed: () {
        _deleteRecordDetail(id: id);

        Navigator.pop(context);
      },
      child: const Text('はい'),
    );

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteRecordDetail({required int id}) async {
    // ignore: always_specify_types
    RecordDetailsRepository().deleteRecordDetail(isar: widget.isar, id: id).then((value) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
