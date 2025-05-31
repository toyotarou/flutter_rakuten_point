import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default('') String selectedDate,
    @Default('') String selectedCategory,
    @Default('') String selectedAction,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setSelectedCategory({required String category}) => state = state.copyWith(selectedCategory: category);

  ///
  void setSelectedAction({required String action}) => state = state.copyWith(selectedAction: action);

  ///
  void setSelectedDate({required String date}) => state = state.copyWith(selectedDate: date);
}
