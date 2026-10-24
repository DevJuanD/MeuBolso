// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'totais_periodo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TotaisPeriodo {

 int get totalReceitas; int get totalDespesas; int get saldo;
/// Create a copy of TotaisPeriodo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotaisPeriodoCopyWith<TotaisPeriodo> get copyWith => _$TotaisPeriodoCopyWithImpl<TotaisPeriodo>(this as TotaisPeriodo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TotaisPeriodo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotaisPeriodo&&(identical(other.totalReceitas, _this.totalReceitas) || other.totalReceitas == _this.totalReceitas)&&(identical(other.totalDespesas, _this.totalDespesas) || other.totalDespesas == _this.totalDespesas)&&(identical(other.saldo, _this.saldo) || other.saldo == _this.saldo));
}


@override
int get hashCode {
  final _this = this as TotaisPeriodo;
  return Object.hash(runtimeType,_this.totalReceitas,_this.totalDespesas,_this.saldo);
}

@override
String toString() {
  final _this = this as TotaisPeriodo;
  return 'TotaisPeriodo(totalReceitas: ${_this.totalReceitas}, totalDespesas: ${_this.totalDespesas}, saldo: ${_this.saldo})';
}


}

/// @nodoc
abstract mixin class $TotaisPeriodoCopyWith<$Res>  {
  factory $TotaisPeriodoCopyWith(TotaisPeriodo value, $Res Function(TotaisPeriodo) _then) = _$TotaisPeriodoCopyWithImpl;
@useResult
$Res call({
 int totalReceitas, int totalDespesas, int saldo
});




}
/// @nodoc
class _$TotaisPeriodoCopyWithImpl<$Res>
    implements $TotaisPeriodoCopyWith<$Res> {
  _$TotaisPeriodoCopyWithImpl(this._self, this._then);

  final TotaisPeriodo _self;
  final $Res Function(TotaisPeriodo) _then;

/// Create a copy of TotaisPeriodo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalReceitas = null,Object? totalDespesas = null,Object? saldo = null,}) {
  return _then(TotaisPeriodo(
totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,saldo: null == saldo ? _self.saldo : saldo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TotaisPeriodo].
extension TotaisPeriodoPatterns on TotaisPeriodo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotaisPeriodo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotaisPeriodo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotaisPeriodo value)  $default,){
final _that = this;
switch (_that) {
case _TotaisPeriodo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotaisPeriodo value)?  $default,){
final _that = this;
switch (_that) {
case _TotaisPeriodo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalReceitas,  int totalDespesas,  int saldo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotaisPeriodo() when $default != null:
return $default(_that.totalReceitas,_that.totalDespesas,_that.saldo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalReceitas,  int totalDespesas,  int saldo)  $default,) {final _that = this;
switch (_that) {
case _TotaisPeriodo():
return $default(_that.totalReceitas,_that.totalDespesas,_that.saldo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalReceitas,  int totalDespesas,  int saldo)?  $default,) {final _that = this;
switch (_that) {
case _TotaisPeriodo() when $default != null:
return $default(_that.totalReceitas,_that.totalDespesas,_that.saldo);case _:
  return null;

}
}

}

/// @nodoc


class _TotaisPeriodo implements TotaisPeriodo {
  const _TotaisPeriodo({required this.totalReceitas, required this.totalDespesas, required this.saldo});
  

@override final  int totalReceitas;
@override final  int totalDespesas;
@override final  int saldo;

/// Create a copy of TotaisPeriodo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotaisPeriodoCopyWith<_TotaisPeriodo> get copyWith => __$TotaisPeriodoCopyWithImpl<_TotaisPeriodo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotaisPeriodo&&(identical(other.totalReceitas, totalReceitas) || other.totalReceitas == totalReceitas)&&(identical(other.totalDespesas, totalDespesas) || other.totalDespesas == totalDespesas)&&(identical(other.saldo, saldo) || other.saldo == saldo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalReceitas,totalDespesas,saldo);
}

@override
String toString() {
    return 'TotaisPeriodo(totalReceitas: $totalReceitas, totalDespesas: $totalDespesas, saldo: $saldo)';
}


}

/// @nodoc
abstract mixin class _$TotaisPeriodoCopyWith<$Res> implements $TotaisPeriodoCopyWith<$Res> {
  factory _$TotaisPeriodoCopyWith(_TotaisPeriodo value, $Res Function(_TotaisPeriodo) _then) = __$TotaisPeriodoCopyWithImpl;
@override @useResult
$Res call({
 int totalReceitas, int totalDespesas, int saldo
});




}
/// @nodoc
class __$TotaisPeriodoCopyWithImpl<$Res>
    implements _$TotaisPeriodoCopyWith<$Res> {
  __$TotaisPeriodoCopyWithImpl(this._self, this._then);

  final _TotaisPeriodo _self;
  final $Res Function(_TotaisPeriodo) _then;

/// Create a copy of TotaisPeriodo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalReceitas = null,Object? totalDespesas = null,Object? saldo = null,}) {
  return _then(_TotaisPeriodo(
totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,saldo: null == saldo ? _self.saldo : saldo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
