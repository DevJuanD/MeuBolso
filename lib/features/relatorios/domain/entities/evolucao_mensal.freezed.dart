// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evolucao_mensal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EvolucaoMensal {

 String get competencia; int get totalReceitas; int get totalDespesas;
/// Create a copy of EvolucaoMensal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvolucaoMensalCopyWith<EvolucaoMensal> get copyWith => _$EvolucaoMensalCopyWithImpl<EvolucaoMensal>(this as EvolucaoMensal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EvolucaoMensal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvolucaoMensal&&(identical(other.competencia, _this.competencia) || other.competencia == _this.competencia)&&(identical(other.totalReceitas, _this.totalReceitas) || other.totalReceitas == _this.totalReceitas)&&(identical(other.totalDespesas, _this.totalDespesas) || other.totalDespesas == _this.totalDespesas));
}


@override
int get hashCode {
  final _this = this as EvolucaoMensal;
  return Object.hash(runtimeType,_this.competencia,_this.totalReceitas,_this.totalDespesas);
}

@override
String toString() {
  final _this = this as EvolucaoMensal;
  return 'EvolucaoMensal(competencia: ${_this.competencia}, totalReceitas: ${_this.totalReceitas}, totalDespesas: ${_this.totalDespesas})';
}


}

/// @nodoc
abstract mixin class $EvolucaoMensalCopyWith<$Res>  {
  factory $EvolucaoMensalCopyWith(EvolucaoMensal value, $Res Function(EvolucaoMensal) _then) = _$EvolucaoMensalCopyWithImpl;
@useResult
$Res call({
 String competencia, int totalReceitas, int totalDespesas
});




}
/// @nodoc
class _$EvolucaoMensalCopyWithImpl<$Res>
    implements $EvolucaoMensalCopyWith<$Res> {
  _$EvolucaoMensalCopyWithImpl(this._self, this._then);

  final EvolucaoMensal _self;
  final $Res Function(EvolucaoMensal) _then;

/// Create a copy of EvolucaoMensal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? competencia = null,Object? totalReceitas = null,Object? totalDespesas = null,}) {
  return _then(EvolucaoMensal(
competencia: null == competencia ? _self.competencia : competencia // ignore: cast_nullable_to_non_nullable
as String,totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EvolucaoMensal].
extension EvolucaoMensalPatterns on EvolucaoMensal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvolucaoMensal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvolucaoMensal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvolucaoMensal value)  $default,){
final _that = this;
switch (_that) {
case _EvolucaoMensal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvolucaoMensal value)?  $default,){
final _that = this;
switch (_that) {
case _EvolucaoMensal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String competencia,  int totalReceitas,  int totalDespesas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvolucaoMensal() when $default != null:
return $default(_that.competencia,_that.totalReceitas,_that.totalDespesas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String competencia,  int totalReceitas,  int totalDespesas)  $default,) {final _that = this;
switch (_that) {
case _EvolucaoMensal():
return $default(_that.competencia,_that.totalReceitas,_that.totalDespesas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String competencia,  int totalReceitas,  int totalDespesas)?  $default,) {final _that = this;
switch (_that) {
case _EvolucaoMensal() when $default != null:
return $default(_that.competencia,_that.totalReceitas,_that.totalDespesas);case _:
  return null;

}
}

}

/// @nodoc


class _EvolucaoMensal implements EvolucaoMensal {
  const _EvolucaoMensal({required this.competencia, required this.totalReceitas, required this.totalDespesas});
  

@override final  String competencia;
@override final  int totalReceitas;
@override final  int totalDespesas;

/// Create a copy of EvolucaoMensal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvolucaoMensalCopyWith<_EvolucaoMensal> get copyWith => __$EvolucaoMensalCopyWithImpl<_EvolucaoMensal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvolucaoMensal&&(identical(other.competencia, competencia) || other.competencia == competencia)&&(identical(other.totalReceitas, totalReceitas) || other.totalReceitas == totalReceitas)&&(identical(other.totalDespesas, totalDespesas) || other.totalDespesas == totalDespesas));
}


@override
int get hashCode {
    return Object.hash(runtimeType,competencia,totalReceitas,totalDespesas);
}

@override
String toString() {
    return 'EvolucaoMensal(competencia: $competencia, totalReceitas: $totalReceitas, totalDespesas: $totalDespesas)';
}


}

/// @nodoc
abstract mixin class _$EvolucaoMensalCopyWith<$Res> implements $EvolucaoMensalCopyWith<$Res> {
  factory _$EvolucaoMensalCopyWith(_EvolucaoMensal value, $Res Function(_EvolucaoMensal) _then) = __$EvolucaoMensalCopyWithImpl;
@override @useResult
$Res call({
 String competencia, int totalReceitas, int totalDespesas
});




}
/// @nodoc
class __$EvolucaoMensalCopyWithImpl<$Res>
    implements _$EvolucaoMensalCopyWith<$Res> {
  __$EvolucaoMensalCopyWithImpl(this._self, this._then);

  final _EvolucaoMensal _self;
  final $Res Function(_EvolucaoMensal) _then;

/// Create a copy of EvolucaoMensal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? competencia = null,Object? totalReceitas = null,Object? totalDespesas = null,}) {
  return _then(_EvolucaoMensal(
competencia: null == competencia ? _self.competencia : competencia // ignore: cast_nullable_to_non_nullable
as String,totalReceitas: null == totalReceitas ? _self.totalReceitas : totalReceitas // ignore: cast_nullable_to_non_nullable
as int,totalDespesas: null == totalDespesas ? _self.totalDespesas : totalDespesas // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
