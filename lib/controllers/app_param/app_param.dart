import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extensions/extensions.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default('') String selectedDate,
    @Default('') String selectedCategory,
    @Default('') String selectedAction,
    @Default('') String selectedListYearmonth,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  ///
  @override
  AppParamState build() {
    return AppParamState(selectedListYearmonth: DateTime.now().yyyymm);
  }

  ///
  void setSelectedCategory({required String category}) => state = state.copyWith(selectedCategory: category);

  ///
  void setSelectedAction({required String action}) => state = state.copyWith(selectedAction: action);

  ///
  void setSelectedDate({required String date}) => state = state.copyWith(selectedDate: date);

  ///
  void setSelectedListYearmonth({required String yearmonth}) =>
      state = state.copyWith(selectedListYearmonth: yearmonth);
}
