import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../collections/record_detail.dart';
import '../../extensions/extensions.dart';

part 'record_detail.freezed.dart';

part 'record_detail.g.dart';

@freezed
class RecordDetailControllerState with _$RecordDetailControllerState {
  const factory RecordDetailControllerState({
    @Default(-1) int itemPos,
    //
    @Default(0) int diff,
    @Default('') String baseDiff,

    //
    @Default(<String>[]) List<String> categoryNameList,
    @Default(<String>[]) List<String> actionNameList,
    @Default(<int>[]) List<int> priceList,
    @Default(<bool>[]) List<bool> minusCheck,
  }) = _RecordDetailControllerState;
}

@Riverpod(keepAlive: true)
class RecordDetailController extends _$RecordDetailController {
  ///
  @override
  RecordDetailControllerState build() {
    // ignore: always_specify_types
    final List<String> categoryNames = List.generate(10, (int index) => '');
    // ignore: always_specify_types
    final List<String> actionNames = List.generate(10, (int index) => '');

    // ignore: always_specify_types
    final List<bool> minusChecks = List.generate(20, (int index) => false);

    // ignore: always_specify_types
    final List<int> prices = List.generate(10, (int index) => 0);

    return RecordDetailControllerState(
      categoryNameList: categoryNames,
      actionNameList: actionNames,
      priceList: prices,

      minusCheck: minusChecks,
    );
  }

  ///
  void setUpdateRecordDetail({required List<RecordDetail> updateRecordDetailList, required int baseDiff}) {
    try {
      final List<String> categoryNameList = <String>[...state.categoryNameList];
      final List<String> actionNameList = <String>[...state.actionNameList];
      final List<int> priceList = <int>[...state.priceList];
      final List<bool> minusChecks = <bool>[...state.minusCheck];

      int diff = 0;

      for (int i = 0; i < updateRecordDetailList.length; i++) {
        categoryNameList[i] = updateRecordDetailList[i].category;
        actionNameList[i] = updateRecordDetailList[i].action;

        diff += updateRecordDetailList[i].price;

        if (updateRecordDetailList[i].price < 0) {
          priceList[i] = updateRecordDetailList[i].price * -1;
          minusChecks[i] = true;
        } else {
          priceList[i] = updateRecordDetailList[i].price;
          minusChecks[i] = false;
        }
      }

      state = state.copyWith(
        categoryNameList: categoryNameList,
        actionNameList: actionNameList,
        priceList: priceList,
        minusCheck: minusChecks,
        diff: diff,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  ///
  Future<void> clearInputValue() async {
    // ignore: always_specify_types
    final List<String> categoryNames = List.generate(10, (int index) => '');
    // ignore: always_specify_types
    final List<String> actionNames = List.generate(10, (int index) => '');

    // ignore: always_specify_types
    final List<bool> minusChecks = List.generate(20, (int index) => false);

    // ignore: always_specify_types
    final List<int> prices = List.generate(10, (int index) => 0);

    state = state.copyWith(
      categoryNameList: categoryNames,
      actionNameList: actionNames,
      minusCheck: minusChecks,
      priceList: prices,

      itemPos: -1,
      baseDiff: '',
      diff: 0,
    );
  }

  ///
  void setBaseDiff({required String baseDiff}) => state = state.copyWith(baseDiff: baseDiff);

  ///
  void setItemPos({required int pos}) => state = state.copyWith(itemPos: pos);

  ///
  void setCategoryNameList({required int pos, required String value}) {
    final List<String> list = <String>[...state.categoryNameList];
    list[pos] = value;
    state = state.copyWith(categoryNameList: list);
  }

  ///
  void setActionNameList({required int pos, required String value}) {
    final List<String> list = <String>[...state.actionNameList];
    list[pos] = value;
    state = state.copyWith(actionNameList: list);
  }

  ///
  void setMinusCheck({required int pos}) {
    final List<bool> minusChecks = <bool>[...state.minusCheck];
    final bool check = minusChecks[pos];
    minusChecks[pos] = !check;
    state = state.copyWith(minusCheck: minusChecks);
  }

  ///
  void setPriceList({required int pos, required int value}) {
    final List<int> list = <int>[...state.priceList];
    list[pos] = value;

    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      if (state.minusCheck[i]) {
        sum -= list[i];
      } else {
        sum += list[i];
      }
    }

    final int baseDiff = state.baseDiff.toInt();
    final int diff = baseDiff - sum;

    state = state.copyWith(priceList: list, diff: diff);
  }
}
