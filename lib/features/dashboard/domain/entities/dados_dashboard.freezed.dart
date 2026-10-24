// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dados_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DadosDashboard {

 ResumoMensal get resumo; List<Transacao> get ultimasTransacoes;
/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DadosDashboardCopyWith<DadosDashboard> get copyWith => _$DadosDashboardCopyWithImpl<DadosDashboard>(this as DadosDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DadosDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DadosDashboard&&(identical(other.resumo, _this.resumo) || other.resumo == _this.resumo)&&const DeepCollectionEquality().equals(other.ultimasTransacoes, _this.ultimasTransacoes));
}


@override
int get hashCode {
  final _this = this as DadosDashboard;
  return Object.hash(runtimeType,_this.resumo,const DeepCollectionEquality().hash(_this.ultimasTransacoes));
}

@override
String toString() {
  final _this = this as DadosDashboard;
  return 'DadosDashboard(resumo: ${_this.resumo}, ultimasTransacoes: ${_this.ultimasTransacoes})';
}


}

/// @nodoc
abstract mixin class $DadosDashboardCopyWith<$Res>  {
  factory $DadosDashboardCopyWith(DadosDashboard value, $Res Function(DadosDashboard) _then) = _$DadosDashboardCopyWithImpl;
@useResult
$Res call({
 ResumoMensal resumo, List<Transacao> ultimasTransacoes
});


$ResumoMensalCopyWith<$Res> get resumo;

}
/// @nodoc
class _$DadosDashboardCopyWithImpl<$Res>
    implements $DadosDashboardCopyWith<$Res> {
  _$DadosDashboardCopyWithImpl(this._self, this._then);

  final DadosDashboard _self;
  final $Res Function(DadosDashboard) _then;

/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resumo = null,Object? ultimasTransacoes = null,}) {
  return _then(DadosDashboard(
resumo: null == resumo ? _self.resumo : resumo // ignore: cast_nullable_to_non_nullable
as ResumoMensal,ultimasTransacoes: null == ultimasTransacoes ? _self.ultimasTransacoes : ultimasTransacoes // ignore: cast_nullable_to_non_nullable
as List<Transacao>,
  ));
}
/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResumoMensalCopyWith<$Res> get resumo {
  
  return $ResumoMensalCopyWith<$Res>(_self.resumo, (value) {
    return _then(_self.copyWith(resumo: value));
  });
}
}


/// Adds pattern-matching-related methods to [DadosDashboard].
extension DadosDashboardPatterns on DadosDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DadosDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DadosDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DadosDashboard value)  $default,){
final _that = this;
switch (_that) {
case _DadosDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DadosDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _DadosDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResumoMensal resumo,  List<Transacao> ultimasTransacoes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DadosDashboard() when $default != null:
return $default(_that.resumo,_that.ultimasTransacoes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResumoMensal resumo,  List<Transacao> ultimasTransacoes)  $default,) {final _that = this;
switch (_that) {
case _DadosDashboard():
return $default(_that.resumo,_that.ultimasTransacoes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResumoMensal resumo,  List<Transacao> ultimasTransacoes)?  $default,) {final _that = this;
switch (_that) {
case _DadosDashboard() when $default != null:
return $default(_that.resumo,_that.ultimasTransacoes);case _:
  return null;

}
}

}

/// @nodoc


class _DadosDashboard implements DadosDashboard {
  const _DadosDashboard({required this.resumo, required  List<Transacao> ultimasTransacoes}): _ultimasTransacoes = ultimasTransacoes;
  

@override final  ResumoMensal resumo;
 final  List<Transacao> _ultimasTransacoes;
@override List<Transacao> get ultimasTransacoes {
  if (_ultimasTransacoes is EqualUnmodifiableListView) return _ultimasTransacoes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ultimasTransacoes);
}


/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DadosDashboardCopyWith<_DadosDashboard> get copyWith => __$DadosDashboardCopyWithImpl<_DadosDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DadosDashboard&&(identical(other.resumo, resumo) || other.resumo == resumo)&&const DeepCollectionEquality().equals(other.ultimasTransacoes, _ultimasTransacoes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,resumo,const DeepCollectionEquality().hash(_ultimasTransacoes));
}

@override
String toString() {
    return 'DadosDashboard(resumo: $resumo, ultimasTransacoes: $ultimasTransacoes)';
}


}

/// @nodoc
abstract mixin class _$DadosDashboardCopyWith<$Res> implements $DadosDashboardCopyWith<$Res> {
  factory _$DadosDashboardCopyWith(_DadosDashboard value, $Res Function(_DadosDashboard) _then) = __$DadosDashboardCopyWithImpl;
@override @useResult
$Res call({
 ResumoMensal resumo, List<Transacao> ultimasTransacoes
});


@override $ResumoMensalCopyWith<$Res> get resumo;

}
/// @nodoc
class __$DadosDashboardCopyWithImpl<$Res>
    implements _$DadosDashboardCopyWith<$Res> {
  __$DadosDashboardCopyWithImpl(this._self, this._then);

  final _DadosDashboard _self;
  final $Res Function(_DadosDashboard) _then;

/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resumo = null,Object? ultimasTransacoes = null,}) {
  return _then(_DadosDashboard(
resumo: null == resumo ? _self.resumo : resumo // ignore: cast_nullable_to_non_nullable
as ResumoMensal,ultimasTransacoes: null == ultimasTransacoes ? _self._ultimasTransacoes : ultimasTransacoes // ignore: cast_nullable_to_non_nullable
as List<Transacao>,
  ));
}

/// Create a copy of DadosDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResumoMensalCopyWith<$Res> get resumo {
  
  return $ResumoMensalCopyWith<$Res>(_self.resumo, (value) {
    return _then(_self.copyWith(resumo: value));
  });
}
}

// dart format on
