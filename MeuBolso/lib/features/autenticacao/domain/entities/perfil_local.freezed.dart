// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil_local.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PerfilLocal {

 String get nome; String get email;
/// Create a copy of PerfilLocal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerfilLocalCopyWith<PerfilLocal> get copyWith => _$PerfilLocalCopyWithImpl<PerfilLocal>(this as PerfilLocal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PerfilLocal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerfilLocal&&(identical(other.nome, _this.nome) || other.nome == _this.nome)&&(identical(other.email, _this.email) || other.email == _this.email));
}


@override
int get hashCode {
  final _this = this as PerfilLocal;
  return Object.hash(runtimeType,_this.nome,_this.email);
}

@override
String toString() {
  final _this = this as PerfilLocal;
  return 'PerfilLocal(nome: ${_this.nome}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $PerfilLocalCopyWith<$Res>  {
  factory $PerfilLocalCopyWith(PerfilLocal value, $Res Function(PerfilLocal) _then) = _$PerfilLocalCopyWithImpl;
@useResult
$Res call({
 String nome, String email
});




}
/// @nodoc
class _$PerfilLocalCopyWithImpl<$Res>
    implements $PerfilLocalCopyWith<$Res> {
  _$PerfilLocalCopyWithImpl(this._self, this._then);

  final PerfilLocal _self;
  final $Res Function(PerfilLocal) _then;

/// Create a copy of PerfilLocal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nome = null,Object? email = null,}) {
  return _then(PerfilLocal(
nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PerfilLocal].
extension PerfilLocalPatterns on PerfilLocal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerfilLocal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerfilLocal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerfilLocal value)  $default,){
final _that = this;
switch (_that) {
case _PerfilLocal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerfilLocal value)?  $default,){
final _that = this;
switch (_that) {
case _PerfilLocal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nome,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerfilLocal() when $default != null:
return $default(_that.nome,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nome,  String email)  $default,) {final _that = this;
switch (_that) {
case _PerfilLocal():
return $default(_that.nome,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nome,  String email)?  $default,) {final _that = this;
switch (_that) {
case _PerfilLocal() when $default != null:
return $default(_that.nome,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _PerfilLocal implements PerfilLocal {
  const _PerfilLocal({required this.nome, required this.email});
  

@override final  String nome;
@override final  String email;

/// Create a copy of PerfilLocal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerfilLocalCopyWith<_PerfilLocal> get copyWith => __$PerfilLocalCopyWithImpl<_PerfilLocal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerfilLocal&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nome,email);
}

@override
String toString() {
    return 'PerfilLocal(nome: $nome, email: $email)';
}


}

/// @nodoc
abstract mixin class _$PerfilLocalCopyWith<$Res> implements $PerfilLocalCopyWith<$Res> {
  factory _$PerfilLocalCopyWith(_PerfilLocal value, $Res Function(_PerfilLocal) _then) = __$PerfilLocalCopyWithImpl;
@override @useResult
$Res call({
 String nome, String email
});




}
/// @nodoc
class __$PerfilLocalCopyWithImpl<$Res>
    implements _$PerfilLocalCopyWith<$Res> {
  __$PerfilLocalCopyWithImpl(this._self, this._then);

  final _PerfilLocal _self;
  final $Res Function(_PerfilLocal) _then;

/// Create a copy of PerfilLocal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nome = null,Object? email = null,}) {
  return _then(_PerfilLocal(
nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
