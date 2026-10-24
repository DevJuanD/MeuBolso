// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resumo_mensal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResumoMensal {

 DateTime get mesAtual; int get totalReceitas; int get totalDespesas; int get saldo; double get variacaoSaldo; double get variacaoReceitas; double get variacaoDespesas;
/// Create a copy of ResumoMensal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumoMensalCopyWith<ResumoMensal> get copyWith => _$ResumoMensalCopyWithImpl<ResumoMensal>(this as ResumoMensal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResumoMensal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumoMensal&&(identical(other.mesAtual, _this.mesAtual) || other.mesAtual == _this.mesAtual)&&(identical(other.totalReceitas, _this.totalReceitas) || other.totalReceitas == _this.totalReceitas)&&(identical(other.totalDespesas, _this.totalDespesas) || other.totalDespesas == _this.totalDespesas)&&(identical(other.saldo, _this.saldo) || other.saldo == _this.saldo)&&(identical(other.variacaoSaldo, _this.variacaoSaldo) || other.variacaoSaldo == _this.variacaoSaldo)&&(identical(other.variacaoReceitas, _this.variacaoReceitas) || other.variacaoReceitas == _this.variacaoReceitas)&&(identical(other.variacaoDespesas, _this.variacaoDespesas) || other.variacaoDespesas == _this.variacaoDespesas));
}


@override
int get hashCode {
  final _this = this as ResumoMensal;
  return Object.hash(runtimeType,_this.mesAtual,_this.totalReceitas,_this.totalDespesas,_this.saldo,_this.variacaoSaldo,_this.variacaoReceitas,_this.variacaoDespesas);
}

@override
String toString() {
  final _this = this as ResumoMensal;
  return 'ResumoMensal(mesAtual: ${_this.mesAtual}, totalReceitas: ${_this.totalReceitas}, totalDespesas: ${_this.totalDespesas}, saldo: ${_this.saldo}, variacaoSaldo: ${_this.variacaoSaldo}, variacaoReceitas: ${_this.variacaoReceitas}, variacaoDespesas: ${_this.variacaoDespesas})';
}


}

/// @nodoc
abstract mixin class $ResumoMensalCopyWith<$Res>  {
  factory $ResumoMensalCopyWith(ResumoMensal value, $Res Function(ResumoMensal) _then) = _$ResumoMensalCopyWithImpl;
@useResult
$Res call({
 DateTime mesAtual, int totalReceitas, int totalDespesas, int saldo, double variacaoSaldo, double variacaoReceitas, double variacaoDespesas
});




}
/// @nodoc
class _$ResumoMensalCopyWithImpl<$Res>
    implements $ResumoMensalCopyWith<$Res> {
  _$ResumoMensalCopyWithImpl(this._self, this._then);

  final ResumoMensal _self;
  final $Res Function(ResumoMensal) _then;

/// Create a copy of ResumoMensal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mesAtual = null,Object? totalReceitas = null,Object? totalDespesas = null,Object? saldo = null,Object? variacaoSaldo = null,Object? variacaoReceitas = null,Object? variacaoDespesas = null,}) {
  return _then(ResumoMensal(
mesAtual: null == mesAtual ? _self.mesAtual : mesAtual // ignore: cast_nullable_to_non_nullable
as DateTime,totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,saldo: null == saldo ? _self.saldo : saldo // ignore: cast_nullable_to_non_nullable
as int,variacaoSaldo: null == variacaoSaldo ? _self.variacaoSaldo : variacaoSaldo // ignore: cast_nullable_to_non_nullable
as double,variacaoReceitas: null == variacaoReceitas ? _self.variacaoReceitas : variacaoReceitas // ignore: cast_nullable_to_non_nullable
as double,variacaoDespesas: null == variacaoDespesas ? _self.variacaoDespesas : variacaoDespesas // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumoMensal].
extension ResumoMensalPatterns on ResumoMensal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumoMensal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumoMensal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumoMensal value)  $default,){
final _that = this;
switch (_that) {
case _ResumoMensal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumoMensal value)?  $default,){
final _that = this;
switch (_that) {
case _ResumoMensal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime mesAtual,  int totalReceitas,  int totalDespesas,  int saldo,  double variacaoSaldo,  double variacaoReceitas,  double variacaoDespesas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumoMensal() when $default != null:
return $default(_that.mesAtual,_that.totalReceitas,_that.totalDespesas,_that.saldo,_that.variacaoSaldo,_that.variacaoReceitas,_that.variacaoDespesas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime mesAtual,  int totalReceitas,  int totalDespesas,  int saldo,  double variacaoSaldo,  double variacaoReceitas,  double variacaoDespesas)  $default,) {final _that = this;
switch (_that) {
case _ResumoMensal():
return $default(_that.mesAtual,_that.totalReceitas,_that.totalDespesas,_that.saldo,_that.variacaoSaldo,_that.variacaoReceitas,_that.variacaoDespesas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime mesAtual,  int totalReceitas,  int totalDespesas,  int saldo,  double variacaoSaldo,  double variacaoReceitas,  double variacaoDespesas)?  $default,) {final _that = this;
switch (_that) {
case _ResumoMensal() when $default != null:
return $default(_that.mesAtual,_that.totalReceitas,_that.totalDespesas,_that.saldo,_that.variacaoSaldo,_that.variacaoReceitas,_that.variacaoDespesas);case _:
  return null;

}
}

}

/// @nodoc


class _ResumoMensal implements ResumoMensal {
  const _ResumoMensal({required this.mesAtual, required this.totalReceitas, required this.totalDespesas, required this.saldo, required this.variacaoSaldo, required this.variacaoReceitas, required this.variacaoDespesas});
  

@override final  DateTime mesAtual;
@override final  int totalReceitas;
@override final  int totalDespesas;
@override final  int saldo;
@override final  double variacaoSaldo;
@override final  double variacaoReceitas;
@override final  double variacaoDespesas;

/// Create a copy of ResumoMensal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumoMensalCopyWith<_ResumoMensal> get copyWith => __$ResumoMensalCopyWithImpl<_ResumoMensal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumoMensal&&(identical(other.mesAtual, mesAtual) || other.mesAtual == mesAtual)&&(identical(other.totalReceitas, totalReceitas) || other.totalReceitas == totalReceitas)&&(identical(other.totalDespesas, totalDespesas) || other.totalDespesas == totalDespesas)&&(identical(other.saldo, saldo) || other.saldo == saldo)&&(identical(other.variacaoSaldo, variacaoSaldo) || other.variacaoSaldo == variacaoSaldo)&&(identical(other.variacaoReceitas, variacaoReceitas) || other.variacaoReceitas == variacaoReceitas)&&(identical(other.variacaoDespesas, variacaoDespesas) || other.variacaoDespesas == variacaoDespesas));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mesAtual,totalReceitas,totalDespesas,saldo,variacaoSaldo,variacaoReceitas,variacaoDespesas);
}

@override
String toString() {
    return 'ResumoMensal(mesAtual: $mesAtual, totalReceitas: $totalReceitas, totalDespesas: $totalDespesas, saldo: $saldo, variacaoSaldo: $variacaoSaldo, variacaoReceitas: $variacaoReceitas, variacaoDespesas: $variacaoDespesas)';
}


}

/// @nodoc
abstract mixin class _$ResumoMensalCopyWith<$Res> implements $ResumoMensalCopyWith<$Res> {
  factory _$ResumoMensalCopyWith(_ResumoMensal value, $Res Function(_ResumoMensal) _then) = __$ResumoMensalCopyWithImpl;
@override @useResult
$Res call({
 DateTime mesAtual, int totalReceitas, int totalDespesas, int saldo, double variacaoSaldo, double variacaoReceitas, double variacaoDespesas
});




}
/// @nodoc
class __$ResumoMensalCopyWithImpl<$Res>
    implements _$ResumoMensalCopyWith<$Res> {
  __$ResumoMensalCopyWithImpl(this._self, this._then);

  final _ResumoMensal _self;
  final $Res Function(_ResumoMensal) _then;

/// Create a copy of ResumoMensal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mesAtual = null,Object? totalReceitas = null,Object? totalDespesas = null,Object? saldo = null,Object? variacaoSaldo = null,Object? variacaoReceitas = null,Object? variacaoDespesas = null,}) {
  return _then(_ResumoMensal(
mesAtual: null == mesAtual ? _self.mesAtual : mesAtual // ignore: cast_nullable_to_non_nullable
as DateTime,totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,saldo: null == saldo ? _self.saldo : saldo // ignore: cast_nullable_to_non_nullable
as int,variacaoSaldo: null == variacaoSaldo ? _self.variacaoSaldo : variacaoSaldo // ignore: cast_nullable_to_non_nullable
as double,variacaoReceitas: null == variacaoReceitas ? _self.variacaoReceitas : variacaoReceitas // ignore: cast_nullable_to_non_nullable
as double,variacaoDespesas: null == variacaoDespesas ? _self.variacaoDespesas : variacaoDespesas // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
