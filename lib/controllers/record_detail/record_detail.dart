import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extensions/extensions.dart';

part 'record_detail.freezed.dart';

part 'record_detail.g.dart';

@freezed
class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    @Default(-1) int itemPos,
    //
    @Default(0) int diff,
    @Default('') String baseDiff,

    //
    @Default(<String>[]) List<String> categoryNameList,
    @Default(<String>[]) List<String> actionNameList,
    @Default(<int>[]) List<int> priceList,
    @Default(<bool>[]) List<bool> minusCheck,
  }) = _RecordDetailState;
}

@Riverpod(keepAlive: true)
class RecordDetail extends _$RecordDetail {
  ///
  @override
  RecordDetailState build() {
    // ignore: always_specify_types
    final List<String> categoryNames = List.generate(10, (int index) => '');
    // ignore: always_specify_types
    final List<String> actionNames = List.generate(10, (int index) => '');

    // ignore: always_specify_types
    final List<bool> minusChecks = List.generate(20, (int index) => false);

    // ignore: always_specify_types
    final List<int> prices = List.generate(10, (int index) => 0);

    return RecordDetailState(
      categoryNameList: categoryNames,
      actionNameList: actionNames,
      priceList: prices,

      minusCheck: minusChecks,
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
