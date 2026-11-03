import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/formatador_moeda.dart';

/// Serviço dedicado à geração e compartilhamento do relatório financeiro em PDF.
///
/// Recebe os dados consolidados do período (receitas, despesas, totais e top 8
/// despesas) e produz um documento seguindo o layout predefinido da especificação.
class PdfRelatorioGenerator {
  /// Gera o PDF do relatório financeiro e dispara a *Share Sheet* para salvar.
  Future<void> gerarECompartilhar({
    required List<Map<String, dynamic>> receitas,
    required List<Map<String, dynamic>> despesas,
    required int totalReceitasCentavos,
    required int totalDespesasCentavos,
    required int saldoCentavos,
    required String mesAno,
  }) async {
    final pdf = pw.Document();

    // Top 8 despesas ordenadas por valor decrescente.
    final topDespesas = List<Map<String, dynamic>>.from(despesas);
    topDespesas.sort((a, b) {
      final va = a['valorCentavos'] as int;
      final vb = b['valorCentavos'] as int;
      return vb.compareTo(va);
    });
    final top8Despesas = topDespesas.take(8).toList();

    final mesTexto = 'Mês: $mesAno';
    final compartilharTexto = 'Relatório Financeiro - $mesAno';

    // Paleta de cores do relatório
    final corRoxoEscuro = PdfColor.fromHex('#4B0082');
    final corReceita = PdfColor.fromHex('#388E3C');
    final corDespesa = PdfColor.fromHex('#D32F2F');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox.shrink();
          }
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              'Página ${context.pageNumber}',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          );
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          );
        },
        build: (context) {
          return [
            // Cabeçalho
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'RELATÓRIO FINANCEIRO',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: corRoxoEscuro,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    mesTexto,
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),

            // Seção 1: Top Despesas
            pw.Text(
              'Maiores Despesas do Mês',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: corRoxoEscuro,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < top8Despesas.length; i++)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text(
                      '${i + 1}. ${top8Despesas[i]['descricao']} - R\$ ${FormatadorMoeda.formatar(top8Despesas[i]['valorCentavos'] as int)}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),

            pw.SizedBox(height: 24),

            // Seção 2: Tabela de Receitas
            pw.Text(
              'Receitas',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: corReceita,
              ),
            ),
            pw.SizedBox(height: 8),
            _tabela(
              cabecalhos: ['DATA', 'DESCRIÇÃO DA RECEITA', 'VALOR (R\$)'],
              corCabecalho: corReceita,
              linhas: [
                for (final r in receitas)
                  [
                    FormatadorMoeda.formatarDataCurta(r['data'] as DateTime),
                    r['descricao'] as String,
                    'R\$ ${FormatadorMoeda.formatar(r['valorCentavos'] as int)}',
                  ],
              ],
            ),

            pw.SizedBox(height: 24),

            // Seção 3: Tabela de Despesas
            pw.Text(
              'Despesas',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: corDespesa,
              ),
            ),
            pw.SizedBox(height: 8),
            _tabela(
              cabecalhos: ['DATA', 'DESCRIÇÃO DA DESPESA', 'VALOR (R\$)'],
              corCabecalho: corDespesa,
              linhas: [
                for (final d in despesas)
                  [
                    FormatadorMoeda.formatarDataCurta(d['data'] as DateTime),
                    d['descricao'] as String,
                    'R\$ ${FormatadorMoeda.formatar(d['valorCentavos'] as int)}',
                  ],
              ],
            ),

            pw.SizedBox(height: 24),

            // Seção 4: Resumo Final
            pw.Text(
              'Relatório Financeiro de Despesas e Receitas',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: corRoxoEscuro,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        'TOTAL DE RECEITAS:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        'R\$ ${FormatadorMoeda.formatarCampo(totalReceitasCentavos)}',
                        style: pw.TextStyle(
                          color: corReceita,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        'TOTAL DE DESPESAS:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        '- R\$ ${FormatadorMoeda.formatarCampo(totalDespesasCentavos)}',
                        style: pw.TextStyle(
                          color: corDespesa,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        'SALDO FINAL:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        'R\$ ${FormatadorMoeda.formatarCampo(saldoCentavos)}',
                        style: pw.TextStyle(
                          color: saldoCentavos >= 0 ? corReceita : corDespesa,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // Salva no diretório temporário e compartilha via Share Sheet.
    final diretorio = await getTemporaryDirectory();
    final arquivo = File('${diretorio.path}/relatorio_financeiro.pdf');
    await arquivo.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(arquivo.path)],
      text: compartilharTexto,
      subject: 'Relatório Financeiro',
    );
  }

  /// Monta uma tabela formatada utilizando pw.Table.fromTextArray
  pw.Widget _tabela({
    required List<String> cabecalhos,
    required List<List<String>> linhas,
    required PdfColor corCabecalho,
  }) {
    return pw.Table.fromTextArray(
      headers: cabecalhos,
      data: linhas,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 10,
      ),
      headerDecoration: pw.BoxDecoration(color: corCabecalho),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
      },
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
    );
  }
}
