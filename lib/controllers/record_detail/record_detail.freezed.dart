// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecordDetailState {
  int get itemPos => throw _privateConstructorUsedError; //
  int get diff => throw _privateConstructorUsedError;
  String get baseDiff => throw _privateConstructorUsedError; //
  List<String> get categoryNameList => throw _privateConstructorUsedError;
  List<String> get actionNameList => throw _privateConstructorUsedError;
  List<int> get priceList => throw _privateConstructorUsedError;
  List<bool> get minusCheck => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordDetailStateCopyWith<RecordDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordDetailStateCopyWith<$Res> {
  factory $RecordDetailStateCopyWith(
          RecordDetailState value, $Res Function(RecordDetailState) then) =
      _$RecordDetailStateCopyWithImpl<$Res, RecordDetailState>;
  @useResult
  $Res call(
      {int itemPos,
      int diff,
      String baseDiff,
      List<String> categoryNameList,
      List<String> actionNameList,
      List<int> priceList,
      List<bool> minusCheck});
}

/// @nodoc
class _$RecordDetailStateCopyWithImpl<$Res, $Val extends RecordDetailState>
    implements $RecordDetailStateCopyWith<$Res> {
  _$RecordDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemPos = null,
    Object? diff = null,
    Object? baseDiff = null,
    Object? categoryNameList = null,
    Object? actionNameList = null,
    Object? priceList = null,
    Object? minusCheck = null,
  }) {
    return _then(_value.copyWith(
      itemPos: null == itemPos
          ? _value.itemPos
          : itemPos // ignore: cast_nullable_to_non_nullable
              as int,
      diff: null == diff
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as int,
      baseDiff: null == baseDiff
          ? _value.baseDiff
          : baseDiff // ignore: cast_nullable_to_non_nullable
              as String,
      categoryNameList: null == categoryNameList
          ? _value.categoryNameList
          : categoryNameList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionNameList: null == actionNameList
          ? _value.actionNameList
          : actionNameList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priceList: null == priceList
          ? _value.priceList
          : priceList // ignore: cast_nullable_to_non_nullable
              as List<int>,
      minusCheck: null == minusCheck
          ? _value.minusCheck
          : minusCheck // ignore: cast_nullable_to_non_nullable
              as List<bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordDetailStateImplCopyWith<$Res>
    implements $RecordDetailStateCopyWith<$Res> {
  factory _$$RecordDetailStateImplCopyWith(_$RecordDetailStateImpl value,
          $Res Function(_$RecordDetailStateImpl) then) =
      __$$RecordDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int itemPos,
      int diff,
      String baseDiff,
      List<String> categoryNameList,
      List<String> actionNameList,
      List<int> priceList,
      List<bool> minusCheck});
}

/// @nodoc
class __$$RecordDetailStateImplCopyWithImpl<$Res>
    extends _$RecordDetailStateCopyWithImpl<$Res, _$RecordDetailStateImpl>
    implements _$$RecordDetailStateImplCopyWith<$Res> {
  __$$RecordDetailStateImplCopyWithImpl(_$RecordDetailStateImpl _value,
      $Res Function(_$RecordDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemPos = null,
    Object? diff = null,
    Object? baseDiff = null,
    Object? categoryNameList = null,
    Object? actionNameList = null,
    Object? priceList = null,
    Object? minusCheck = null,
  }) {
    return _then(_$RecordDetailStateImpl(
      itemPos: null == itemPos
          ? _value.itemPos
          : itemPos // ignore: cast_nullable_to_non_nullable
              as int,
      diff: null == diff
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as int,
      baseDiff: null == baseDiff
          ? _value.baseDiff
          : baseDiff // ignore: cast_nullable_to_non_nullable
              as String,
      categoryNameList: null == categoryNameList
          ? _value._categoryNameList
          : categoryNameList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionNameList: null == actionNameList
          ? _value._actionNameList
          : actionNameList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priceList: null == priceList
          ? _value._priceList
          : priceList // ignore: cast_nullable_to_non_nullable
              as List<int>,
      minusCheck: null == minusCheck
          ? _value._minusCheck
          : minusCheck // ignore: cast_nullable_to_non_nullable
              as List<bool>,
    ));
  }
}

/// @nodoc

class _$RecordDetailStateImpl implements _RecordDetailState {
  const _$RecordDetailStateImpl(
      {this.itemPos = -1,
      this.diff = 0,
      this.baseDiff = '',
      final List<String> categoryNameList = const <String>[],
      final List<String> actionNameList = const <String>[],
      final List<int> priceList = const <int>[],
      final List<bool> minusCheck = const <bool>[]})
      : _categoryNameList = categoryNameList,
        _actionNameList = actionNameList,
        _priceList = priceList,
        _minusCheck = minusCheck;

  @override
  @JsonKey()
  final int itemPos;
//
  @override
  @JsonKey()
  final int diff;
  @override
  @JsonKey()
  final String baseDiff;
//
  final List<String> _categoryNameList;
//
  @override
  @JsonKey()
  List<String> get categoryNameList {
    if (_categoryNameList is EqualUnmodifiableListView)
      return _categoryNameList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryNameList);
  }

  final List<String> _actionNameList;
  @override
  @JsonKey()
  List<String> get actionNameList {
    if (_actionNameList is EqualUnmodifiableListView) return _actionNameList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionNameList);
  }

  final List<int> _priceList;
  @override
  @JsonKey()
  List<int> get priceList {
    if (_priceList is EqualUnmodifiableListView) return _priceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_priceList);
  }

  final List<bool> _minusCheck;
  @override
  @JsonKey()
  List<bool> get minusCheck {
    if (_minusCheck is EqualUnmodifiableListView) return _minusCheck;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_minusCheck);
  }

  @override
  String toString() {
    return 'RecordDetailState(itemPos: $itemPos, diff: $diff, baseDiff: $baseDiff, categoryNameList: $categoryNameList, actionNameList: $actionNameList, priceList: $priceList, minusCheck: $minusCheck)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordDetailStateImpl &&
            (identical(other.itemPos, itemPos) || other.itemPos == itemPos) &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.baseDiff, baseDiff) ||
                other.baseDiff == baseDiff) &&
            const DeepCollectionEquality()
                .equals(other._categoryNameList, _categoryNameList) &&
            const DeepCollectionEquality()
                .equals(other._actionNameList, _actionNameList) &&
            const DeepCollectionEquality()
                .equals(other._priceList, _priceList) &&
            const DeepCollectionEquality()
                .equals(other._minusCheck, _minusCheck));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemPos,
      diff,
      baseDiff,
      const DeepCollectionEquality().hash(_categoryNameList),
      const DeepCollectionEquality().hash(_actionNameList),
      const DeepCollectionEquality().hash(_priceList),
      const DeepCollectionEquality().hash(_minusCheck));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordDetailStateImplCopyWith<_$RecordDetailStateImpl> get copyWith =>
      __$$RecordDetailStateImplCopyWithImpl<_$RecordDetailStateImpl>(
          this, _$identity);
}

abstract class _RecordDetailState implements RecordDetailState {
  const factory _RecordDetailState(
      {final int itemPos,
      final int diff,
      final String baseDiff,
      final List<String> categoryNameList,
      final List<String> actionNameList,
      final List<int> priceList,
      final List<bool> minusCheck}) = _$RecordDetailStateImpl;

  @override
  int get itemPos;
  @override //
  int get diff;
  @override
  String get baseDiff;
  @override //
  List<String> get categoryNameList;
  @override
  List<String> get actionNameList;
  @override
  List<int> get priceList;
  @override
  List<bool> get minusCheck;
  @override
  @JsonKey(ignore: true)
  _$$RecordDetailStateImplCopyWith<_$RecordDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
