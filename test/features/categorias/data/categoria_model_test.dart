import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/core/database/esquema_banco.dart';
import 'package:meu_bolso/features/categorias/data/models/categoria_model.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';

void main() {
  group('CategoriaModel', () {
    test('converte de entidade para modelo e mapa do SQLite com sucesso', () {
      const entidade = Categoria(
        id: 'cat_despesa_123',
        nome: 'Educação',
        tipo: TipoTransacao.despesa,
        isPadrao: false,
      );

      final model = CategoriaModel.deEntidade(entidade);
      final mapa = model.paraMapa();

      expect(mapa[EsquemaBanco.colCategoriaId], 'cat_despesa_123');
      expect(mapa[EsquemaBanco.colCategoriaNome], 'Educação');
      expect(mapa[EsquemaBanco.colCategoriaTipo], 'despesa');
      expect(mapa[EsquemaBanco.colCategoriaIsPadrao], 0);

      final reconstruido = CategoriaModel.doMapa(mapa);
      final entidadeReconstruida = reconstruido.paraEntidade();

      expect(entidadeReconstruida.id, 'cat_despesa_123');
      expect(entidadeReconstruida.nome, 'Educação');
      expect(entidadeReconstruida.tipo, TipoTransacao.despesa);
      expect(entidadeReconstruida.isPadrao, isFalse);
    });

    test('mapeia isPadrao como true quando valor do SQLite for 1', () {
      final mapa = {
        EsquemaBanco.colCategoriaId: 'padrao_rec_salario',
        EsquemaBanco.colCategoriaNome: 'Salário',
        EsquemaBanco.colCategoriaTipo: 'receita',
        EsquemaBanco.colCategoriaIsPadrao: 1,
      };

      final model = CategoriaModel.doMapa(mapa);
      final entidade = model.paraEntidade();

      expect(entidade.id, 'padrao_rec_salario');
      expect(entidade.nome, 'Salário');
      expect(entidade.tipo, TipoTransacao.receita);
      expect(entidade.isPadrao, isTrue);
    });
  });
}
