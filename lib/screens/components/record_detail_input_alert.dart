import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/action_name.dart';
import '../../collections/category_name.dart';
import '../../collections/record.dart';
import '../../collections/record_detail.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/action_names_repository.dart';
import '../../repository/category_names_repository.dart';
import '../../repository/record_details_repository.dart';
import '../../utilities/functions.dart';
import '../parts/error_dialog.dart';

class RecordDetailInputAlert extends ConsumerStatefulWidget {
  const RecordDetailInputAlert({
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
  ConsumerState<RecordDetailInputAlert> createState() => _RecordDetailInputAlertState();
}

class _RecordDetailInputAlertState extends ConsumerState<RecordDetailInputAlert>
    with ControllersMixin<RecordDetailInputAlert> {
  final List<TextEditingController> _priceTecs = <TextEditingController>[];

  List<FocusNode> focusNodeList = <FocusNode>[];

  List<CategoryName>? categoryNameList = <CategoryName>[];

  List<ActionName>? actionNameList = <ActionName>[];

  ///
  @override
  void initState() {
    super.initState();

    try {
      _makeTecs();
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());

    makeCategoryNameList();

    makeActionNameList();

    if (widget.record != null) {
      // ignore: always_specify_types
      Future(() => recordDetailNotifier.setBaseDiff(baseDiff: widget.sagaku.toString()));
    }
  }

  ///
  Future<void> _makeTecs() async {
    for (int i = 0; i < 10; i++) {
      _priceTecs.add(TextEditingController(text: ''));
    }

    if (widget.recordDetail!.isNotEmpty) {
      // ignore: always_specify_types
      await Future(
        () => recordDetailNotifier.setUpdateRecordDetail(
          updateRecordDetailList: widget.recordDetail!,
          baseDiff: widget.sagaku,
        ),
      );

      for (int i = 0; i < widget.recordDetail!.length; i++) {
        _priceTecs[i].text = (widget.recordDetail![i].price.toString().trim().toInt() > 0)
            ? widget.recordDetail![i].price.toString().trim()
            : (widget.recordDetail![i].price * -1).toString().trim();
      }
    }
  }

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
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 80),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Record Detail Input'),
                        const SizedBox(height: 10),
                        Text(widget.date),

                        const SizedBox(height: 10),

                        Text(
                          (recordDetailState.diff != 0)
                              ? recordDetailState.diff.toString().toCurrency()
                              : (recordDetailState.baseDiff == '')
                              ? ''
                              : recordDetailState.baseDiff.toCurrency(),
                          style: TextStyle(color: (recordDetailState.diff == 0) ? Colors.yellowAccent : Colors.white),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _inputRecordDetail();
                      },

                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                      child: const Text('input'),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.white.withValues(alpha: 0.4), thickness: 5),

              Expanded(child: _displayInputParts()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    final List<String> categoryNames = <String>[''];

    categoryNameList?.forEach((CategoryName element) => categoryNames.add(element.name));

    final List<String> actionNames = <String>[''];

    actionNameList?.forEach((ActionName element) => actionNames.add(element.name));

    for (int i = 0; i < 10; i++) {
      final String category = recordDetailState.categoryNameList[i];
      final String action = recordDetailState.actionNameList[i];

      list.add(
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5,
                right: 15,
                child: Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                ),
              ),
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (categoryNames.contains(category)) ...<Widget>[
                          Expanded(
                            flex: 2,
                            // ignore: always_specify_types
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                              iconEnabledColor: Colors.white,
                              value: category,
                              items: categoryNames
                                  .map(
                                    // ignore: always_specify_types
                                    (String e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, style: const TextStyle(fontSize: 12)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  recordDetailNotifier.setCategoryNameList(pos: i, value: value);
                                }
                              },
                            ),
                          ),
                        ],

                        const SizedBox(width: 10),

                        if (actionNames.contains(action)) ...<Widget>[
                          Expanded(
                            // ignore: always_specify_types
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                              iconEnabledColor: Colors.white,
                              value: action,
                              items: actionNames
                                  .map(
                                    // ignore: always_specify_types
                                    (String e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, style: const TextStyle(fontSize: 12)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  recordDetailNotifier.setActionNameList(pos: i, value: value);
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => recordDetailNotifier.setMinusCheck(pos: i),
                          child: Icon(
                            Icons.remove,
                            color: (recordDetailState.minusCheck[i]) ? Colors.redAccent : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _priceTecs[i],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              hintText: '金額(10桁以内)',
                              filled: true,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                            ),
                            style: const TextStyle(fontSize: 12),
                            onChanged: (String value) =>
                                recordDetailNotifier.setPriceList(pos: i, value: (value == '') ? 0 : value.toInt()),
                            onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                            focusNode: focusNodeList[i],
                            onTap: () => context.showKeyboard(focusNodeList[i]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Future<void> makeCategoryNameList() async {
    CategoryNamesRepository().getCategoryNameList(isar: widget.isar).then((List<CategoryName>? value) {
      setState(() {
        categoryNameList = value;
      });
    });
  }

  ///
  Future<void> makeActionNameList() async {
    ActionNamesRepository().getActionNameList(isar: widget.isar).then((List<ActionName>? value) {
      setState(() {
        actionNameList = value;
      });
    });
  }

  ///
  Future<void> _inputRecordDetail() async {
    final List<RecordDetail> list = <RecordDetail>[];

    bool errFlg = false;

    ////////////////////////// 同数チェック
    int recordDetailCategoryCount = 0;
    int recordDetailActionCount = 0;
    int recordDetailPriceCount = 0;
    ////////////////////////// 同数チェック

    for (int i = 0; i < 10; i++) {
      //===============================================
      if (recordDetailState.categoryNameList[i] != '' &&
          recordDetailState.actionNameList[i] != '' &&
          recordDetailState.priceList[i] != 0) {
        final int price = (recordDetailState.minusCheck[i])
            ? recordDetailState.priceList[i] * -1
            : recordDetailState.priceList[i];

        list.add(
          RecordDetail()
            ..date = widget.date
            ..category = recordDetailState.categoryNameList[i]
            ..action = recordDetailState.actionNameList[i]
            ..price = price,
        );
      }
      //===============================================

      ////////////////////////// 同数チェック
      if (recordDetailState.categoryNameList[i] != '') {
        recordDetailCategoryCount++;
      }

      if (recordDetailState.actionNameList[i] != '') {
        recordDetailActionCount++;
      }

      if (recordDetailState.priceList[i] != 0) {
        recordDetailPriceCount++;
      }
      ////////////////////////// 同数チェック
    }

    if (list.isEmpty) {
      errFlg = true;
    }

    ////////////////////////// 同数チェック
    final Map<int, String> countCheck = <int, String>{};
    countCheck[recordDetailCategoryCount] = '';
    countCheck[recordDetailActionCount] = '';
    countCheck[recordDetailPriceCount] = '';

    // 同数の場合、要素数は1になる

    if (countCheck.length > 1) {
      errFlg = true;
    }

    ////////////////////////// 同数チェック

    if (!errFlg) {
      for (final RecordDetail element in list) {
        for (final List<Object> element2 in <List<Object>>[
          <Object>[element.price.toString().trim(), 10],
        ]) {
          if (!checkInputValueLengthCheck(value: element2[0].toString().trim(), length: element2[1] as int)) {
            errFlg = true;
          }
        }
      }
    }

    final int diff = recordDetailState.diff;

    if (diff != 0 || errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
          // ignore: use_build_context_synchronously
          context: context,
          title: '登録できません。',
          content: '値を正しく入力してください。',
        ),
      );

      return;
    }

    await RecordDetailsRepository().deleteRecordDetailList(isar: widget.isar, recordDetailList: widget.recordDetail)
    // ignore: always_specify_types
    .then((value) async {
      await RecordDetailsRepository().inputRecordDetailList(isar: widget.isar, recordDetailList: list).then((
        // ignore: always_specify_types
        value2,
      ) async {
        // ignore: always_specify_types
        await recordDetailNotifier.clearInputValue().then((value3) {
          if (mounted) {
            Navigator.pop(context);

            Navigator.pop(context);
          }
        });
      });
    });
  }
}
