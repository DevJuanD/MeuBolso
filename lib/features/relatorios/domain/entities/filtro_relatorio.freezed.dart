// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filtro_relatorio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FiltroRelatorio {

 DateTime? get dataInicial; DateTime? get dataFinal; TipoTransacao? get tipo; String? get categoriaId;
/// Create a copy of FiltroRelatorio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiltroRelatorioCopyWith<FiltroRelatorio> get copyWith => _$FiltroRelatorioCopyWithImpl<FiltroRelatorio>(this as FiltroRelatorio, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FiltroRelatorio;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FiltroRelatorio&&(identical(other.dataInicial, _this.dataInicial) || other.dataInicial == _this.dataInicial)&&(identical(other.dataFinal, _this.dataFinal) || other.dataFinal == _this.dataFinal)&&(identical(other.tipo, _this.tipo) || other.tipo == _this.tipo)&&(identical(other.categoriaId, _this.categoriaId) || other.categoriaId == _this.categoriaId));
}


@override
int get hashCode {
  final _this = this as FiltroRelatorio;
  return Object.hash(runtimeType,_this.dataInicial,_this.dataFinal,_this.tipo,_this.categoriaId);
}

@override
String toString() {
  final _this = this as FiltroRelatorio;
  return 'FiltroRelatorio(dataInicial: ${_this.dataInicial}, dataFinal: ${_this.dataFinal}, tipo: ${_this.tipo}, categoriaId: ${_this.categoriaId})';
}


}

/// @nodoc
abstract mixin class $FiltroRelatorioCopyWith<$Res>  {
  factory $FiltroRelatorioCopyWith(FiltroRelatorio value, $Res Function(FiltroRelatorio) _then) = _$FiltroRelatorioCopyWithImpl;
@useResult
$Res call({
 DateTime? dataInicial, DateTime? dataFinal, TipoTransacao? tipo, String? categoriaId
});




}
/// @nodoc
class _$FiltroRelatorioCopyWithImpl<$Res>
    implements $FiltroRelatorioCopyWith<$Res> {
  _$FiltroRelatorioCopyWithImpl(this._self, this._then);

  final FiltroRelatorio _self;
  final $Res Function(FiltroRelatorio) _then;

/// Create a copy of FiltroRelatorio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataInicial = freezed,Object? dataFinal = freezed,Object? tipo = freezed,Object? categoriaId = freezed,}) {
  return _then(FiltroRelatorio(
dataInicial: freezed == dataInicial ? _self.dataInicial : dataInicial // ignore: cast_nullable_to_non_nullable
as DateTime?,dataFinal: freezed == dataFinal ? _self.dataFinal : dataFinal // ignore: cast_nullable_to_non_nullable
as DateTime?,tipo: freezed == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao?,categoriaId: freezed == categoriaId ? _self.categoriaId : categoriaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FiltroRelatorio].
extension FiltroRelatorioPatterns on FiltroRelatorio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FiltroRelatorio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FiltroRelatorio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FiltroRelatorio value)  $default,){
final _that = this;
switch (_that) {
case _FiltroRelatorio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FiltroRelatorio value)?  $default,){
final _that = this;
switch (_that) {
case _FiltroRelatorio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? dataInicial,  DateTime? dataFinal,  TipoTransacao? tipo,  String? categoriaId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FiltroRelatorio() when $default != null:
return $default(_that.dataInicial,_that.dataFinal,_that.tipo,_that.categoriaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? dataInicial,  DateTime? dataFinal,  TipoTransacao? tipo,  String? categoriaId)  $default,) {final _that = this;
switch (_that) {
case _FiltroRelatorio():
return $default(_that.dataInicial,_that.dataFinal,_that.tipo,_that.categoriaId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? dataInicial,  DateTime? dataFinal,  TipoTransacao? tipo,  String? categoriaId)?  $default,) {final _that = this;
switch (_that) {
case _FiltroRelatorio() when $default != null:
return $default(_that.dataInicial,_that.dataFinal,_that.tipo,_that.categoriaId);case _:
  return null;

}
}

}

/// @nodoc


class _FiltroRelatorio extends FiltroRelatorio {
  const _FiltroRelatorio({this.dataInicial, this.dataFinal, this.tipo, this.categoriaId}): super._();
  

@override final  DateTime? dataInicial;
@override final  DateTime? dataFinal;
@override final  TipoTransacao? tipo;
@override final  String? categoriaId;

/// Create a copy of FiltroRelatorio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiltroRelatorioCopyWith<_FiltroRelatorio> get copyWith => __$FiltroRelatorioCopyWithImpl<_FiltroRelatorio>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiltroRelatorio&&(identical(other.dataInicial, dataInicial) || other.dataInicial == dataInicial)&&(identical(other.dataFinal, dataFinal) || other.dataFinal == dataFinal)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.categoriaId, categoriaId) || other.categoriaId == categoriaId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,dataInicial,dataFinal,tipo,categoriaId);
}

@override
String toString() {
    return 'FiltroRelatorio(dataInicial: $dataInicial, dataFinal: $dataFinal, tipo: $tipo, categoriaId: $categoriaId)';
}


}

/// @nodoc
abstract mixin class _$FiltroRelatorioCopyWith<$Res> implements $FiltroRelatorioCopyWith<$Res> {
  factory _$FiltroRelatorioCopyWith(_FiltroRelatorio value, $Res Function(_FiltroRelatorio) _then) = __$FiltroRelatorioCopyWithImpl;
@override @useResult
$Res call({
 DateTime? dataInicial, DateTime? dataFinal, TipoTransacao? tipo, String? categoriaId
});




}
/// @nodoc
class __$FiltroRelatorioCopyWithImpl<$Res>
    implements _$FiltroRelatorioCopyWith<$Res> {
  __$FiltroRelatorioCopyWithImpl(this._self, this._then);

  final _FiltroRelatorio _self;
  final $Res Function(_FiltroRelatorio) _then;

/// Create a copy of FiltroRelatorio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataInicial = freezed,Object? dataFinal = freezed,Object? tipo = freezed,Object? categoriaId = freezed,}) {
  return _then(_FiltroRelatorio(
dataInicial: freezed == dataInicial ? _self.dataInicial : dataInicial // ignore: cast_nullable_to_non_nullable
as DateTime?,dataFinal: freezed == dataFinal ? _self.dataFinal : dataFinal // ignore: cast_nullable_to_non_nullable
as DateTime?,tipo: freezed == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao?,categoriaId: freezed == categoriaId ? _self.categoriaId : categoriaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
