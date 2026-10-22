import 'package:flutter_test/flutter_test.dart';
import 'package:meu_bolso/features/categorias/domain/entities/categoria.dart';
import 'package:meu_bolso/features/categorias/domain/exceptions/falhas_categoria.dart';
import 'package:meu_bolso/features/categorias/domain/repositories/categoria_repository.dart';
import 'package:meu_bolso/features/categorias/domain/usecases/criar_categoria_usecase.dart';
import 'package:meu_bolso/features/core/domain/enums/tipo_transacao.dart';

class _FakeCategoriaRepository implements CategoriaRepository {
  final List<Categoria> categorias = [];

  @override
  Future<List<Categoria>> listarPorTipo(TipoTransacao tipo) async {
    return categorias.where((c) => c.tipo == tipo).toList();
  }

  @override
  Future<Categoria> salvar(Categoria categoria) async {
    final index = categorias.indexWhere((c) => c.id == categoria.id);
    if (index != -1) {
      categorias[index] = categoria;
    } else {
      categorias.add(categoria);
    }
    return categoria;
  }

  @override
  Future<Categoria?> obterPorId(String id) async {
    final encontrados = categorias.where((c) => c.id == id);
    if (encontrados.isEmpty) return null;
    return encontrados.first;
  }

  @override
  Future<Categoria?> buscarPorNomeETipo(String nome, TipoTransacao tipo) async {
    final encontrados = categorias.where(
      (c) => c.nome.toLowerCase() == nome.toLowerCase() && c.tipo == tipo,
    );
    if (encontrados.isEmpty) return null;
    return encontrados.first;
  }
}

void main() {
  group('CriarCategoriaUseCase', () {
    late _FakeCategoriaRepository repositorio;
    late CriarCategoriaUseCase useCase;

    setUp(() {
      repositorio = _FakeCategoriaRepository();
      useCase = CriarCategoriaUseCase(repositorio);
    });

    test('cria categoria com sucesso capitalizando a primeira letra', () async {
      final resultado = await useCase(
        nome: 'consultoria financeira',
        tipo: TipoTransacao.receita,
      );

      expect(resultado.id, startsWith('cat_receita_'));
      expect(resultado.nome, 'Consultoria financeira');
      expect(resultado.tipo, TipoTransacao.receita);
      expect(resultado.isPadrao, isFalse);

      final listadas = await repositorio.listarPorTipo(TipoTransacao.receita);
      expect(listadas, hasLength(1));
      expect(listadas.first.nome, 'Consultoria financeira');
    });

    test('lanca NomeCategoriaInvalidoException quando nome for vazio ou em branco', () async {
      expect(
        () => useCase(nome: '', tipo: TipoTransacao.despesa),
        throwsA(isA<NomeCategoriaInvalidoException>()),
      );

      expect(
        () => useCase(nome: '    ', tipo: TipoTransacao.despesa),
        throwsA(isA<NomeCategoriaInvalidoException>()),
      );
    });

    test('lanca CategoriaDuplicadaException quando categoria do mesmo tipo ja existir', () async {
      await useCase(
        nome: 'Educação',
        tipo: TipoTransacao.despesa,
      );

      expect(
        () => useCase(
          nome: 'educação',
          tipo: TipoTransacao.despesa,
        ),
        throwsA(isA<CategoriaDuplicadaException>()),
      );

      expect(
        () => useCase(
          nome: '   EDUCAÇÃO   ',
          tipo: TipoTransacao.despesa,
        ),
        throwsA(isA<CategoriaDuplicadaException>()),
      );
    });

    test('permite criar categoria com o mesmo nome em tipos diferentes', () async {
      final receita = await useCase(
        nome: 'Investimento',
        tipo: TipoTransacao.receita,
      );

      final despesa = await useCase(
        nome: 'Investimento',
        tipo: TipoTransacao.despesa,
      );

      expect(receita.nome, 'Investimento');
      expect(receita.tipo, TipoTransacao.receita);
      expect(despesa.nome, 'Investimento');
      expect(despesa.tipo, TipoTransacao.despesa);
    });
  });
}
