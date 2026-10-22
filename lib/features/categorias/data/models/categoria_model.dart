import '../../../../core/database/esquema_banco.dart';
import '../../../core/domain/enums/tipo_transacao.dart';
import '../../domain/entities/categoria.dart';

/// Modelo de persistência para categorias no SQLite.
class CategoriaModel {
  final String id;
  final String nome;
  final TipoTransacao tipo;
  final bool isPadrao;

  const CategoriaModel({
    required this.id,
    required this.nome,
    required this.tipo,
    this.isPadrao = false,
  });

  factory CategoriaModel.deEntidade(Categoria categoria) {
    return CategoriaModel(
      id: categoria.id,
      nome: categoria.nome,
      tipo: categoria.tipo,
      isPadrao: categoria.isPadrao,
    );
  }

  Categoria paraEntidade() {
    return Categoria(
      id: id,
      nome: nome,
      tipo: tipo,
      isPadrao: isPadrao,
    );
  }

  factory CategoriaModel.doMapa(Map<String, dynamic> mapa) {
    return CategoriaModel(
      id: mapa[EsquemaBanco.colCategoriaId] as String,
      nome: mapa[EsquemaBanco.colCategoriaNome] as String,
      tipo: TipoTransacao.deTexto(mapa[EsquemaBanco.colCategoriaTipo] as String),
      isPadrao: (mapa[EsquemaBanco.colCategoriaIsPadrao] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> paraMapa() {
    return {
      EsquemaBanco.colCategoriaId: id,
      EsquemaBanco.colCategoriaNome: nome,
      EsquemaBanco.colCategoriaTipo: tipo.valorBanco,
      EsquemaBanco.colCategoriaIsPadrao: isPadrao ? 1 : 0,
    };
  }
}
