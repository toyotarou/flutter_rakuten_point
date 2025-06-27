import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/record.dart';
import '../../collections/record_detail.dart';
import '../../controllers/controllers_mixin.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
