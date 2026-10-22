import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/categorias/data/datasources/categorias_local_datasource.dart';
import 'package:meu_bolso/features/categorias/data/models/categoria_model.dart';
import 'package:meu_bolso/features/categorias/data/repositories/categoria_repository_impl.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/exceptions/falhas_categoria.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';

class _FakeCategoriasLocalDataSource implements CategoriasLocalDataSource {
  final List<CategoriaModel> itens = [];

  @override
  Future<void> inserir(CategoriaModel model) async {
    final duplicado = itens.any(
      (item) =>
          item.nome.toLowerCase() == model.nome.toLowerCase() &&
          item.tipo == model.tipo,
    );
    if (duplicado) {
      throw const CategoriaDuplicadaException();
    }
    itens.add(model);
  }

  @override
  Future<List<CategoriaModel>> listarPorTipo(TipoTransacao tipo) async {
    return itens.where((item) => item.tipo == tipo).toList();
  }

  @override
  Future<CategoriaModel?> obterPorId(String id) async {
    final encontrados = itens.where((item) => item.id == id);
    if (encontrados.isEmpty) return null;
    return encontrados.first;
  }

  @override
  Future<CategoriaModel?> buscarPorNomeETipo(
    String nome,
    TipoTransacao tipo,
  ) async {
    final encontrados = itens.where(
      (item) =>
          item.nome.toLowerCase() == nome.toLowerCase() && item.tipo == tipo,
    );
    if (encontrados.isEmpty) return null;
    return encontrados.first;
  }
}

void main() {
  group('CategoriaRepositoryImpl', () {
    late _FakeCategoriasLocalDataSource fakeDataSource;
    late CategoriaRepositoryImpl repositorio;

    setUp(() {
      fakeDataSource = _FakeCategoriasLocalDataSource();
      repositorio = CategoriaRepositoryImpl(fakeDataSource);
    });

    test('salva e lista categorias por tipo convertendo para entidade de domínio', () async {
      const nova = Categoria(
        id: 'cat_rec_1',
        nome: 'Consultoria',
        tipo: TipoTransacao.receita,
        isPadrao: false,
      );

      final salva = await repositorio.salvar(nova);
      expect(salva.nome, 'Consultoria');

      final receitas = await repositorio.listarPorTipo(TipoTransacao.receita);
      expect(receitas, hasLength(1));
      expect(receitas.first.id, 'cat_rec_1');
      expect(receitas.first.nome, 'Consultoria');

      final despesas = await repositorio.listarPorTipo(TipoTransacao.despesa);
      expect(despesas, isEmpty);
    });

    test('lanca CategoriaDuplicadaException ao salvar categoria ja existente', () async {
      const cat1 = Categoria(
        id: 'cat_desp_1',
        nome: 'Aluguel',
        tipo: TipoTransacao.despesa,
        isPadrao: false,
      );

      const cat2 = Categoria(
        id: 'cat_desp_2',
        nome: 'aluguel',
        tipo: TipoTransacao.despesa,
        isPadrao: false,
      );

      await repositorio.salvar(cat1);

      expect(
        () => repositorio.salvar(cat2),
        throwsA(isA<CategoriaDuplicadaException>()),
      );
    });

    test('obterPorId e buscarPorNomeETipo retornam categoria ou nulo', () async {
      const cat = Categoria(
        id: 'cat_100',
        nome: 'Freelance',
        tipo: TipoTransacao.receita,
        isPadrao: true,
      );

      await repositorio.salvar(cat);

      final encontradaId = await repositorio.obterPorId('cat_100');
      expect(encontradaId, isNotNull);
      expect(encontradaId!.nome, 'Freelance');

      final encontradaNome = await repositorio.buscarPorNomeETipo(
        'freelance',
        TipoTransacao.receita,
      );
      expect(encontradaNome, isNotNull);
      expect(encontradaNome!.id, 'cat_100');

      final naoEncontrada = await repositorio.obterPorId('inexistente');
      expect(naoEncontrada, isNull);
    });
  });
}
