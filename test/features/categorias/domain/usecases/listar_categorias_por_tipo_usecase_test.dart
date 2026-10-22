import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/listar_categorias_por_tipo_usecase.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';

class _FakeCategoriaRepository implements CategoriaRepository {
  final List<Categoria> categorias = [];

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    return categorias.where((c) => c.tipo == tipo).toList();
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    categorias.add(categoria);
    return categoria;
  }

  @override
  Future<Categoria?> obterPorId(String id) async {
    return categorias.where((c) => c.id == id).firstOrNull;
  }

  @override
  Future<Categoria?> buscarPorNomeETipo(String nome, TipoTransacao tipo) async {
    return categorias
        .where((c) => c.nome.toLowerCase() == nome.toLowerCase() && c.tipo == tipo)
        .firstOrNull;
  }
}

void main() {
  group('ListarCategoriasPorTipoUseCase', () {
    late _FakeCategoriaRepository repositorio;
    late ListarCategoriasPorTipoUseCase useCase;

    setUp(() {
      repositorio = _FakeCategoriaRepository();
      useCase = ListarCategoriasPorTipoUseCase(repositorio);

      repositorio.categorias.addAll([
        const Categoria(
          id: 'padrao_rec_1',
          nome: 'Salário',
          tipo: TipoTransacao.receita,
          isPadrao: true,
        ),
        const Categoria(
          id: 'padrao_rec_2',
          nome: 'Freelance',
          tipo: TipoTransacao.receita,
          isPadrao: true,
        ),
        const Categoria(
          id: 'padrao_desp_1',
          nome: 'Alimentação',
          tipo: TipoTransacao.despesa,
          isPadrao: true,
        ),
      ]);
    });

    test('retorna apenas categorias do tipo receita', () async {
      final receitas = await useCase(TipoTransacao.receita);

      expect(receitas, hasLength(2));
      expect(receitas.map((c) => c.nome), containsAll(['Salário', 'Freelance']));
    });

    test('retorna apenas categorias do tipo despesa', () async {
      final despesas = await useCase(TipoTransacao.despesa);

      expect(despesas, hasLength(1));
      expect(despesas.first.nome, 'Alimentação');
    });
  });
}
