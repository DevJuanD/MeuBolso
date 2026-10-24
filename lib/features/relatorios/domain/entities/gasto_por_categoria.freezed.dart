// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gasto_por_categoria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GastoPorCategoria {

 String get categoriaNome; int get totalCentavos; double get percentual;
/// Create a copy of GastoPorCategoria
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GastoPorCategoriaCopyWith<GastoPorCategoria> get copyWith => _$GastoPorCategoriaCopyWithImpl<GastoPorCategoria>(this as GastoPorCategoria, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GastoPorCategoria;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GastoPorCategoria&&(identical(other.categoriaNome, _this.categoriaNome) || other.categoriaNome == _this.categoriaNome)&&(identical(other.totalCentavos, _this.totalCentavos) || other.totalCentavos == _this.totalCentavos)&&(identical(other.percentual, _this.percentual) || other.percentual == _this.percentual));
}


@override
int get hashCode {
  final _this = this as GastoPorCategoria;
  return Object.hash(runtimeType,_this.categoriaNome,_this.totalCentavos,_this.percentual);
}

@override
String toString() {
  final _this = this as GastoPorCategoria;
  return 'GastoPorCategoria(categoriaNome: ${_this.categoriaNome}, totalCentavos: ${_this.totalCentavos}, percentual: ${_this.percentual})';
}


}

/// @nodoc
abstract mixin class $GastoPorCategoriaCopyWith<$Res>  {
  factory $GastoPorCategoriaCopyWith(GastoPorCategoria value, $Res Function(GastoPorCategoria) _then) = _$GastoPorCategoriaCopyWithImpl;
@useResult
$Res call({
 String categoriaNome, int totalCentavos, double percentual
});




}
/// @nodoc
class _$GastoPorCategoriaCopyWithImpl<$Res>
    implements $GastoPorCategoriaCopyWith<$Res> {
  _$GastoPorCategoriaCopyWithImpl(this._self, this._then);

  final GastoPorCategoria _self;
  final $Res Function(GastoPorCategoria) _then;

/// Create a copy of GastoPorCategoria
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoriaNome = null,Object? totalCentavos = null,Object? percentual = null,}) {
  return _then(GastoPorCategoria(
categoriaNome: null == categoriaNome ? _self.categoriaNome : categoriaNome // ignore: cast_nullable_to_non_nullable
as String,totalCentavos: null == totalCentavos ? _self.totalCentavos : totalCentavos // ignore: cast_nullable_to_non_nullable
as int,percentual: null == percentual ? _self.percentual : percentual // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GastoPorCategoria].
extension GastoPorCategoriaPatterns on GastoPorCategoria {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GastoPorCategoria value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GastoPorCategoria() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GastoPorCategoria value)  $default,){
final _that = this;
switch (_that) {
case _GastoPorCategoria():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GastoPorCategoria value)?  $default,){
final _that = this;
switch (_that) {
case _GastoPorCategoria() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoriaNome,  int totalCentavos,  double percentual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GastoPorCategoria() when $default != null:
return $default(_that.categoriaNome,_that.totalCentavos,_that.percentual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoriaNome,  int totalCentavos,  double percentual)  $default,) {final _that = this;
switch (_that) {
case _GastoPorCategoria():
return $default(_that.categoriaNome,_that.totalCentavos,_that.percentual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoriaNome,  int totalCentavos,  double percentual)?  $default,) {final _that = this;
switch (_that) {
case _GastoPorCategoria() when $default != null:
return $default(_that.categoriaNome,_that.totalCentavos,_that.percentual);case _:
  return null;

}
}

}

/// @nodoc


class _GastoPorCategoria implements GastoPorCategoria {
  const _GastoPorCategoria({required this.categoriaNome, required this.totalCentavos, required this.percentual});
  

@override final  String categoriaNome;
@override final  int totalCentavos;
@override final  double percentual;

/// Create a copy of GastoPorCategoria
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GastoPorCategoriaCopyWith<_GastoPorCategoria> get copyWith => __$GastoPorCategoriaCopyWithImpl<_GastoPorCategoria>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GastoPorCategoria&&(identical(other.categoriaNome, categoriaNome) || other.categoriaNome == categoriaNome)&&(identical(other.totalCentavos, totalCentavos) || other.totalCentavos == totalCentavos)&&(identical(other.percentual, percentual) || other.percentual == percentual));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoriaNome,totalCentavos,percentual);
}

@override
String toString() {
    return 'GastoPorCategoria(categoriaNome: $categoriaNome, totalCentavos: $totalCentavos, percentual: $percentual)';
}


}

/// @nodoc
abstract mixin class _$GastoPorCategoriaCopyWith<$Res> implements $GastoPorCategoriaCopyWith<$Res> {
  factory _$GastoPorCategoriaCopyWith(_GastoPorCategoria value, $Res Function(_GastoPorCategoria) _then) = __$GastoPorCategoriaCopyWithImpl;
@override @useResult
$Res call({
 String categoriaNome, int totalCentavos, double percentual
});




}
/// @nodoc
class __$GastoPorCategoriaCopyWithImpl<$Res>
    implements _$GastoPorCategoriaCopyWith<$Res> {
  __$GastoPorCategoriaCopyWithImpl(this._self, this._then);

  final _GastoPorCategoria _self;
  final $Res Function(_GastoPorCategoria) _then;

/// Create a copy of GastoPorCategoria
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoriaNome = null,Object? totalCentavos = null,Object? percentual = null,}) {
  return _then(_GastoPorCategoria(
categoriaNome: null == categoriaNome ? _self.categoriaNome : categoriaNome // ignore: cast_nullable_to_non_nullable
as String,totalCentavos: null == totalCentavos ? _self.totalCentavos : totalCentavos // ignore: cast_nullable_to_non_nullable
as int,percentual: null == percentual ? _self.percentual : percentual // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
