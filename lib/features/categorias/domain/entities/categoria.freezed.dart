// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categoria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Categoria {

 String get id; String get nome; TipoTransacao get tipo; bool get isPadrao;
/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriaCopyWith<Categoria> get copyWith => _$CategoriaCopyWithImpl<Categoria>(this as Categoria, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Categoria;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Categoria&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nome, _this.nome) || other.nome == _this.nome)&&(identical(other.tipo, _this.tipo) || other.tipo == _this.tipo)&&(identical(other.isPadrao, _this.isPadrao) || other.isPadrao == _this.isPadrao));
}


@override
int get hashCode {
  final _this = this as Categoria;
  return Object.hash(runtimeType,_this.id,_this.nome,_this.tipo,_this.isPadrao);
}

@override
String toString() {
  final _this = this as Categoria;
  return 'Categoria(id: ${_this.id}, nome: ${_this.nome}, tipo: ${_this.tipo}, isPadrao: ${_this.isPadrao})';
}


}

/// @nodoc
abstract mixin class $CategoriaCopyWith<$Res>  {
  factory $CategoriaCopyWith(Categoria value, $Res Function(Categoria) _then) = _$CategoriaCopyWithImpl;
@useResult
$Res call({
 String id, String nome, TipoTransacao tipo, bool isPadrao
});




}
/// @nodoc
class _$CategoriaCopyWithImpl<$Res>
    implements $CategoriaCopyWith<$Res> {
  _$CategoriaCopyWithImpl(this._self, this._then);

  final Categoria _self;
  final $Res Function(Categoria) _then;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nome = null,Object? tipo = null,Object? isPadrao = null,}) {
  return _then(Categoria(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao,isPadrao: null == isPadrao ? _self.isPadrao : isPadrao // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Categoria].
extension CategoriaPatterns on Categoria {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Categoria value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Categoria() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Categoria value)  $default,){
final _that = this;
switch (_that) {
case _Categoria():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Categoria value)?  $default,){
final _that = this;
switch (_that) {
case _Categoria() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nome,  TipoTransacao tipo,  bool isPadrao)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Categoria() when $default != null:
return $default(_that.id,_that.nome,_that.tipo,_that.isPadrao);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nome,  TipoTransacao tipo,  bool isPadrao)  $default,) {final _that = this;
switch (_that) {
case _Categoria():
return $default(_that.id,_that.nome,_that.tipo,_that.isPadrao);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nome,  TipoTransacao tipo,  bool isPadrao)?  $default,) {final _that = this;
switch (_that) {
case _Categoria() when $default != null:
return $default(_that.id,_that.nome,_that.tipo,_that.isPadrao);case _:
  return null;

}
}

}

/// @nodoc


class _Categoria extends Categoria {
  const _Categoria({required this.id, required this.nome, required this.tipo, this.isPadrao = false}): super._();
  

@override final  String id;
@override final  String nome;
@override final  TipoTransacao tipo;
@override@JsonKey() final  bool isPadrao;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriaCopyWith<_Categoria> get copyWith => __$CategoriaCopyWithImpl<_Categoria>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Categoria&&(identical(other.id, id) || other.id == id)&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.isPadrao, isPadrao) || other.isPadrao == isPadrao));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,nome,tipo,isPadrao);
}

@override
String toString() {
    return 'Categoria(id: $id, nome: $nome, tipo: $tipo, isPadrao: $isPadrao)';
}


}

/// @nodoc
abstract mixin class _$CategoriaCopyWith<$Res> implements $CategoriaCopyWith<$Res> {
  factory _$CategoriaCopyWith(_Categoria value, $Res Function(_Categoria) _then) = __$CategoriaCopyWithImpl;
@override @useResult
$Res call({
 String id, String nome, TipoTransacao tipo, bool isPadrao
});




}
/// @nodoc
class __$CategoriaCopyWithImpl<$Res>
    implements _$CategoriaCopyWith<$Res> {
  __$CategoriaCopyWithImpl(this._self, this._then);

  final _Categoria _self;
  final $Res Function(_Categoria) _then;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nome = null,Object? tipo = null,Object? isPadrao = null,}) {
  return _then(_Categoria(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao,isPadrao: null == isPadrao ? _self.isPadrao : isPadrao // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
