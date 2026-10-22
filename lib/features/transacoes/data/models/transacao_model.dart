import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/modalidade_pagamento.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/transacao.dart';

/// Modelo de dados de transação para persistência no banco SQLite.
class TransacaoModel {
  final int? id;
  final String descricao;
  final int valorCentavos;
  final TipoTransacao tipo;
  final String categoria;
  final String? categoriaId;
  final ModalidadePagamento modalidade;
  final DateTime data;
  final String competencia;
  final int? recorrenciaId;
  final DateTime? excluidaEm;
  final DateTime criadoEm;

  const TransacaoModel({
    this.id,
    required this.descricao,
    required this.valorCentavos,
    required this.tipo,
    required this.categoria,
    this.categoriaId,
    required this.modalidade,
    required this.data,
    required this.competencia,
    this.recorrenciaId,
    this.excluidaEm,
    required this.criadoEm,
  });

  /// Converte a entidade de domínio em modelo para persistência.
  factory TransacaoModel.deEntidade(Transacao transacao) {
    return TransacaoModel(
      id: transacao.id,
      descricao: transacao.descricao,
      valorCentavos: transacao.valorCentavos,
      tipo: transacao.tipo,
      categoria: transacao.categoria,
      categoriaId: transacao.categoriaId,
      modalidade: transacao.modalidade,
      data: transacao.data,
      competencia: transacao.competencia,
      recorrenciaId: transacao.recorrenciaId,
      excluidaEm: transacao.excluidaEm,
      criadoEm: transacao.criadoEm,
    );
  }

  /// Converte o modelo persistido para entidade de domínio.
  Transacao paraEntidade() {
    return Transacao(
      id: id,
      descricao: descricao,
      valorCentavos: valorCentavos,
      tipo: tipo,
      categoria: categoria,
      categoriaId: categoriaId,
      modalidade: modalidade,
      data: data,
      competencia: competencia,
      recorrenciaId: recorrenciaId,
      excluidaEm: excluidaEm,
      criadoEm: criadoEm,
    );
  }

  /// Instancia o modelo a partir do mapa de colunas do SQLite.
  factory TransacaoModel.doMapa(Map<String, dynamic> mapa) {
    final dataTransacaoStr = mapa[EsquemaBanco.colTransacaoDataTransacao] as String;
    final criadoEmStr = mapa[EsquemaBanco.colTransacaoCriadoEm] as String;
    final excluidaEmStr = mapa[EsquemaBanco.colTransacaoExcluidaEm] as String?;

    return TransacaoModel(
      id: mapa[EsquemaBanco.colTransacaoId] as int?,
      descricao: mapa[EsquemaBanco.colTransacaoDescricao] as String,
      valorCentavos: mapa[EsquemaBanco.colTransacaoValorCentavos] as int,
      tipo: TipoTransacao.deTexto(mapa[EsquemaBanco.colTransacaoTipo] as String),
      categoria: mapa[EsquemaBanco.colTransacaoCategoria] as String,
      categoriaId: mapa[EsquemaBanco.colTransacaoCategoriaId] as String?,
      modalidade: ModalidadePagamento.deTexto(
        mapa[EsquemaBanco.colTransacaoModalidade] as String,
      ),
      data: DateTime.parse(dataTransacaoStr),
      competencia: mapa[EsquemaBanco.colTransacaoCompetencia] as String,
      recorrenciaId: mapa[EsquemaBanco.colTransacaoRecorrenciaId] as int?,
      excluidaEm: excluidaEmStr != null ? DateTime.parse(excluidaEmStr) : null,
      criadoEm: DateTime.parse(criadoEmStr),
    );
  }

  /// Converte o modelo para mapa de valores a serem inseridos ou atualizados no SQLite.
  Map<String, dynamic> paraMapa() {
    final mapa = <String, dynamic>{
      EsquemaBanco.colTransacaoDescricao: descricao,
      EsquemaBanco.colTransacaoValorCentavos: valorCentavos,
      EsquemaBanco.colTransacaoTipo: tipo.valorBanco,
      EsquemaBanco.colTransacaoCategoria: categoria,
      EsquemaBanco.colTransacaoCategoriaId: categoriaId,
      EsquemaBanco.colTransacaoModalidade: modalidade.valorBanco,
      EsquemaBanco.colTransacaoDataTransacao: data.toIso8601String(),
      EsquemaBanco.colTransacaoCompetencia: competencia,
      EsquemaBanco.colTransacaoRecorrenciaId: recorrenciaId,
      EsquemaBanco.colTransacaoExcluidaEm: excluidaEm?.toIso8601String(),
      EsquemaBanco.colTransacaoCriadoEm: criadoEm.toIso8601String(),
    };

    if (id != null) {
      mapa[EsquemaBanco.colTransacaoId] = id;
    }

    return mapa;
  }
}
