// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transacao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transacao {

 int? get id; String get descricao; int get valorCentavos; TipoTransacao get tipo; String get categoria; ModalidadePagamento get modalidade; DateTime get data; String get competencia; int? get recorrenciaId; DateTime? get excluidaEm; DateTime get criadoEm;
/// Create a copy of Transacao
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransacaoCopyWith<Transacao> get copyWith => _$TransacaoCopyWithImpl<Transacao>(this as Transacao, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Transacao;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transacao&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.descricao, _this.descricao) || other.descricao == _this.descricao)&&(identical(other.valorCentavos, _this.valorCentavos) || other.valorCentavos == _this.valorCentavos)&&(identical(other.tipo, _this.tipo) || other.tipo == _this.tipo)&&(identical(other.categoria, _this.categoria) || other.categoria == _this.categoria)&&(identical(other.modalidade, _this.modalidade) || other.modalidade == _this.modalidade)&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.competencia, _this.competencia) || other.competencia == _this.competencia)&&(identical(other.recorrenciaId, _this.recorrenciaId) || other.recorrenciaId == _this.recorrenciaId)&&(identical(other.excluidaEm, _this.excluidaEm) || other.excluidaEm == _this.excluidaEm)&&(identical(other.criadoEm, _this.criadoEm) || other.criadoEm == _this.criadoEm));
}


@override
int get hashCode {
  final _this = this as Transacao;
  return Object.hash(runtimeType,_this.id,_this.descricao,_this.valorCentavos,_this.tipo,_this.categoria,_this.modalidade,_this.data,_this.competencia,_this.recorrenciaId,_this.excluidaEm,_this.criadoEm);
}

@override
String toString() {
  final _this = this as Transacao;
  return 'Transacao(id: ${_this.id}, descricao: ${_this.descricao}, valorCentavos: ${_this.valorCentavos}, tipo: ${_this.tipo}, categoria: ${_this.categoria}, modalidade: ${_this.modalidade}, data: ${_this.data}, competencia: ${_this.competencia}, recorrenciaId: ${_this.recorrenciaId}, excluidaEm: ${_this.excluidaEm}, criadoEm: ${_this.criadoEm})';
}


}

/// @nodoc
abstract mixin class $TransacaoCopyWith<$Res>  {
  factory $TransacaoCopyWith(Transacao value, $Res Function(Transacao) _then) = _$TransacaoCopyWithImpl;
@useResult
$Res call({
 int? id, String descricao, int valorCentavos, TipoTransacao tipo, String categoria, ModalidadePagamento modalidade, DateTime data, String competencia, int? recorrenciaId, DateTime? excluidaEm, DateTime criadoEm
});




}
/// @nodoc
class _$TransacaoCopyWithImpl<$Res>
    implements $TransacaoCopyWith<$Res> {
  _$TransacaoCopyWithImpl(this._self, this._then);

  final Transacao _self;
  final $Res Function(Transacao) _then;

/// Create a copy of Transacao
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? descricao = null,Object? valorCentavos = null,Object? tipo = null,Object? categoria = null,Object? modalidade = null,Object? data = null,Object? competencia = null,Object? recorrenciaId = freezed,Object? excluidaEm = freezed,Object? criadoEm = null,}) {
  return _then(Transacao(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,valorCentavos: null == valorCentavos ? _self.valorCentavos : valorCentavos // ignore: cast_nullable_to_non_nullable
as int,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao,categoria: null == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String,modalidade: null == modalidade ? _self.modalidade : modalidade // ignore: cast_nullable_to_non_nullable
as ModalidadePagamento,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,competencia: null == competencia ? _self.competencia : competencia // ignore: cast_nullable_to_non_nullable
as String,recorrenciaId: freezed == recorrenciaId ? _self.recorrenciaId : recorrenciaId // ignore: cast_nullable_to_non_nullable
as int?,excluidaEm: freezed == excluidaEm ? _self.excluidaEm : excluidaEm // ignore: cast_nullable_to_non_nullable
as DateTime?,criadoEm: null == criadoEm ? _self.criadoEm : criadoEm // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Transacao].
extension TransacaoPatterns on Transacao {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transacao value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transacao() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transacao value)  $default,){
final _that = this;
switch (_that) {
case _Transacao():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transacao value)?  $default,){
final _that = this;
switch (_that) {
case _Transacao() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String descricao,  int valorCentavos,  TipoTransacao tipo,  String categoria,  ModalidadePagamento modalidade,  DateTime data,  String competencia,  int? recorrenciaId,  DateTime? excluidaEm,  DateTime criadoEm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transacao() when $default != null:
return $default(_that.id,_that.descricao,_that.valorCentavos,_that.tipo,_that.categoria,_that.modalidade,_that.data,_that.competencia,_that.recorrenciaId,_that.excluidaEm,_that.criadoEm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String descricao,  int valorCentavos,  TipoTransacao tipo,  String categoria,  ModalidadePagamento modalidade,  DateTime data,  String competencia,  int? recorrenciaId,  DateTime? excluidaEm,  DateTime criadoEm)  $default,) {final _that = this;
switch (_that) {
case _Transacao():
return $default(_that.id,_that.descricao,_that.valorCentavos,_that.tipo,_that.categoria,_that.modalidade,_that.data,_that.competencia,_that.recorrenciaId,_that.excluidaEm,_that.criadoEm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String descricao,  int valorCentavos,  TipoTransacao tipo,  String categoria,  ModalidadePagamento modalidade,  DateTime data,  String competencia,  int? recorrenciaId,  DateTime? excluidaEm,  DateTime criadoEm)?  $default,) {final _that = this;
switch (_that) {
case _Transacao() when $default != null:
return $default(_that.id,_that.descricao,_that.valorCentavos,_that.tipo,_that.categoria,_that.modalidade,_that.data,_that.competencia,_that.recorrenciaId,_that.excluidaEm,_that.criadoEm);case _:
  return null;

}
}

}

/// @nodoc


class _Transacao extends Transacao {
  const _Transacao({this.id, required this.descricao, required this.valorCentavos, required this.tipo, required this.categoria, this.modalidade = ModalidadePagamento.pix, required this.data, required this.competencia, this.recorrenciaId, this.excluidaEm, required this.criadoEm}): super._();
  

@override final  int? id;
@override final  String descricao;
@override final  int valorCentavos;
@override final  TipoTransacao tipo;
@override final  String categoria;
@override@JsonKey() final  ModalidadePagamento modalidade;
@override final  DateTime data;
@override final  String competencia;
@override final  int? recorrenciaId;
@override final  DateTime? excluidaEm;
@override final  DateTime criadoEm;

/// Create a copy of Transacao
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransacaoCopyWith<_Transacao> get copyWith => __$TransacaoCopyWithImpl<_Transacao>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transacao&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.valorCentavos, valorCentavos) || other.valorCentavos == valorCentavos)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.modalidade, modalidade) || other.modalidade == modalidade)&&(identical(other.data, data) || other.data == data)&&(identical(other.competencia, competencia) || other.competencia == competencia)&&(identical(other.recorrenciaId, recorrenciaId) || other.recorrenciaId == recorrenciaId)&&(identical(other.excluidaEm, excluidaEm) || other.excluidaEm == excluidaEm)&&(identical(other.criadoEm, criadoEm) || other.criadoEm == criadoEm));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,descricao,valorCentavos,tipo,categoria,modalidade,data,competencia,recorrenciaId,excluidaEm,criadoEm);
}

@override
String toString() {
    return 'Transacao(id: $id, descricao: $descricao, valorCentavos: $valorCentavos, tipo: $tipo, categoria: $categoria, modalidade: $modalidade, data: $data, competencia: $competencia, recorrenciaId: $recorrenciaId, excluidaEm: $excluidaEm, criadoEm: $criadoEm)';
}


}

/// @nodoc
abstract mixin class _$TransacaoCopyWith<$Res> implements $TransacaoCopyWith<$Res> {
  factory _$TransacaoCopyWith(_Transacao value, $Res Function(_Transacao) _then) = __$TransacaoCopyWithImpl;
@override @useResult
$Res call({
 int? id, String descricao, int valorCentavos, TipoTransacao tipo, String categoria, ModalidadePagamento modalidade, DateTime data, String competencia, int? recorrenciaId, DateTime? excluidaEm, DateTime criadoEm
});




}
/// @nodoc
class __$TransacaoCopyWithImpl<$Res>
    implements _$TransacaoCopyWith<$Res> {
  __$TransacaoCopyWithImpl(this._self, this._then);

  final _Transacao _self;
  final $Res Function(_Transacao) _then;

/// Create a copy of Transacao
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? descricao = null,Object? valorCentavos = null,Object? tipo = null,Object? categoria = null,Object? modalidade = null,Object? data = null,Object? competencia = null,Object? recorrenciaId = freezed,Object? excluidaEm = freezed,Object? criadoEm = null,}) {
  return _then(_Transacao(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,valorCentavos: null == valorCentavos ? _self.valorCentavos : valorCentavos // ignore: cast_nullable_to_non_nullable
as int,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as TipoTransacao,categoria: null == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String,modalidade: null == modalidade ? _self.modalidade : modalidade // ignore: cast_nullable_to_non_nullable
as ModalidadePagamento,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,competencia: null == competencia ? _self.competencia : competencia // ignore: cast_nullable_to_non_nullable
as String,recorrenciaId: freezed == recorrenciaId ? _self.recorrenciaId : recorrenciaId // ignore: cast_nullable_to_non_nullable
as int?,excluidaEm: freezed == excluidaEm ? _self.excluidaEm : excluidaEm // ignore: cast_nullable_to_non_nullable
as DateTime?,criadoEm: null == criadoEm ? _self.criadoEm : criadoEm // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
