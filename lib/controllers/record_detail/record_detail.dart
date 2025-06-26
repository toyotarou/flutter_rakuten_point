import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_detail.freezed.dart';

part 'record_detail.g.dart';

@freezed
class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    @Default(<dynamic>[]) List<String> categoryNameList,
    @Default(<dynamic>[]) List<String> actionNameList,
    @Default(<dynamic>[]) List<String> priceList,
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
    final List<String> prices = List.generate(10, (int index) => '');

    return RecordDetailState(categoryNameList: categoryNames, actionNameList: actionNames, priceList: prices);
  }

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
  void setPriceList({required int pos, required String value}) {
    final List<String> list = <String>[...state.priceList];
    list[pos] = value;
    state = state.copyWith(priceList: list);
  }
}
