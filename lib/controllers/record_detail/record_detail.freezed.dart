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
  List<String> get categoryNameList => throw _privateConstructorUsedError;
  List<String> get actionNameList => throw _privateConstructorUsedError;
  List<String> get priceList => throw _privateConstructorUsedError;

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
      {List<String> categoryNameList,
      List<String> actionNameList,
      List<String> priceList});
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
    Object? categoryNameList = null,
    Object? actionNameList = null,
    Object? priceList = null,
  }) {
    return _then(_value.copyWith(
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
              as List<String>,
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
      {List<String> categoryNameList,
      List<String> actionNameList,
      List<String> priceList});
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
    Object? categoryNameList = null,
    Object? actionNameList = null,
    Object? priceList = null,
  }) {
    return _then(_$RecordDetailStateImpl(
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
              as List<String>,
    ));
  }
}

/// @nodoc

class _$RecordDetailStateImpl implements _RecordDetailState {
  const _$RecordDetailStateImpl(
      {final List<String> categoryNameList = const [],
      final List<String> actionNameList = const [],
      final List<String> priceList = const []})
      : _categoryNameList = categoryNameList,
        _actionNameList = actionNameList,
        _priceList = priceList;

  final List<String> _categoryNameList;
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

  final List<String> _priceList;
  @override
  @JsonKey()
  List<String> get priceList {
    if (_priceList is EqualUnmodifiableListView) return _priceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_priceList);
  }

  @override
  String toString() {
    return 'RecordDetailState(categoryNameList: $categoryNameList, actionNameList: $actionNameList, priceList: $priceList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordDetailStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categoryNameList, _categoryNameList) &&
            const DeepCollectionEquality()
                .equals(other._actionNameList, _actionNameList) &&
            const DeepCollectionEquality()
                .equals(other._priceList, _priceList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categoryNameList),
      const DeepCollectionEquality().hash(_actionNameList),
      const DeepCollectionEquality().hash(_priceList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordDetailStateImplCopyWith<_$RecordDetailStateImpl> get copyWith =>
      __$$RecordDetailStateImplCopyWithImpl<_$RecordDetailStateImpl>(
          this, _$identity);
}

abstract class _RecordDetailState implements RecordDetailState {
  const factory _RecordDetailState(
      {final List<String> categoryNameList,
      final List<String> actionNameList,
      final List<String> priceList}) = _$RecordDetailStateImpl;

  @override
  List<String> get categoryNameList;
  @override
  List<String> get actionNameList;
  @override
  List<String> get priceList;
  @override
  @JsonKey(ignore: true)
  _$$RecordDetailStateImplCopyWith<_$RecordDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
