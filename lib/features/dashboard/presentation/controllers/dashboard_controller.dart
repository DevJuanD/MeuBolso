import 'package:flutter/foundation.dart';

import '../../../autenticacao/domain/entities/perfil_local.dart';
import '../../../autenticacao/domain/usecases/obter_perfil_usecase.dart';
import '../../../transacoes/domain/entities/transacao.dart';
import '../../domain/entities/dados_dashboard.dart';
import '../../domain/entities/resumo_mensal.dart';
import '../../domain/usecases/obter_resumo_dashboard_usecase.dart';

/// Controlador de apresentação da tela T02 (Início).
///
/// Carrega em conjunto o perfil (para a saudação), o resumo mensal e as
/// últimas transações do mês selecionado.
class DashboardController extends ChangeNotifier {
  final ObterResumoDashboardUseCase _obterResumoDashboardUseCase;
  final ObterPerfilUseCase _obterPerfilUseCase;

  DashboardController({
    required ObterResumoDashboardUseCase obterResumoDashboardUseCase,
    required ObterPerfilUseCase obterPerfilUseCase,
  })  : _obterResumoDashboardUseCase = obterResumoDashboardUseCase,
        _obterPerfilUseCase = obterPerfilUseCase;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  PerfilLocal? _perfil;
  PerfilLocal? get perfil => _perfil;

  ResumoMensal? _resumo;
  ResumoMensal? get resumo => _resumo;

  List<Transacao> _ultimasTransacoes = const [];
  List<Transacao> get ultimasTransacoes =>
      List.unmodifiable(_ultimasTransacoes);

  DateTime _mesSelecionado = _iniciarMes(DateTime.now());
  DateTime get mesSelecionado => _mesSelecionado;

  /// Carrega perfil, resumo e últimas transações do mês selecionado.
  Future<void> carregar() async {
    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final perfilFuturo = _obterPerfilUseCase();
      final dadosFuturo = _obterResumoDashboardUseCase(_mesSelecionado);

      _perfil = await perfilFuturo;
      final DadosDashboard dados = await dadosFuturo;
      _resumo = dados.resumo;
      _ultimasTransacoes = dados.ultimasTransacoes;
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar o resumo financeiro.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Troca o mês de referência e recarrega os dados.
  Future<void> selecionarMes(DateTime mes) async {
    final novoMes = _iniciarMes(mes);
    if (novoMes == _mesSelecionado) return;
    _mesSelecionado = novoMes;
    await carregar();
  }

  static DateTime _iniciarMes(DateTime data) => DateTime(data.year, data.month);
}
