import 'package:flutter/material.dart';

/// Mapeamento definitivo entre a chave de ícone armazenada no banco de dados
/// e o respectivo `IconData` do Material Design.
///
/// Caso a chave não esteja cadastrada, o fallback é `Icons.more_horiz_rounded`.
final Map<String, IconData> iconesPorCategoria = {
  // Ícones neutros / default
  'default': Icons.more_horiz_rounded,

  // Receitas
  'trabalho': Icons.work_outline_rounded,
  'freelance': Icons.laptop_mac_rounded,
  'vendas': Icons.shopping_bag_outlined,
  'rendimentos': Icons.trending_up_rounded,
  'presente': Icons.card_giftcard_rounded,

  // Despesas
  'alimentacao': Icons.restaurant_rounded,
  'transporte': Icons.directions_bus_filled_outlined,
  'moradia': Icons.home_outlined,
  'contas': Icons.wifi_rounded,
  'saude': Icons.favorite_border_rounded,
  'lazer': Icons.local_activity_outlined,
  'compras': Icons.shopping_cart_outlined,
};

/// Retorna o `IconData` associado à chave de ícone da categoria.
IconData iconeParaCategoria(String iconeId) {
  return iconesPorCategoria[iconeId] ?? Icons.more_horiz_rounded;
}

/// Pool de ícones disponíveis para seleção na tela de gerenciamento de categorias.
///
/// Cada entrada contém a chave (salva no banco), o ícone Material Design e
/// um rótulo descritivo para exibição ao usuário.
final List<Map<String, dynamic>> poolDeIcones = const [
  {'chave': 'default', 'icone': Icons.more_horiz_rounded, 'rotulo': 'Padrão'},
  {'chave': 'trabalho', 'icone': Icons.work_outline_rounded, 'rotulo': 'Trabalho'},
  {'chave': 'freelance', 'icone': Icons.laptop_mac_rounded, 'rotulo': 'Freelance'},
  {'chave': 'vendas', 'icone': Icons.shopping_bag_outlined, 'rotulo': 'Vendas'},
  {'chave': 'rendimentos', 'icone': Icons.trending_up_rounded, 'rotulo': 'Rendimentos'},
  {'chave': 'presente', 'icone': Icons.card_giftcard_rounded, 'rotulo': 'Presente'},
  {'chave': 'alimentacao', 'icone': Icons.restaurant_rounded, 'rotulo': 'Alimentação'},
  {'chave': 'transporte', 'icone': Icons.directions_bus_filled_outlined, 'rotulo': 'Transporte'},
  {'chave': 'moradia', 'icone': Icons.home_outlined, 'rotulo': 'Moradia'},
  {'chave': 'contas', 'icone': Icons.wifi_rounded, 'rotulo': 'Contas e serviços'},
  {'chave': 'saude', 'icone': Icons.favorite_border_rounded, 'rotulo': 'Saúde'},
  {'chave': 'lazer', 'icone': Icons.local_activity_outlined, 'rotulo': 'Lazer'},
  {'chave': 'compras', 'icone': Icons.shopping_cart_outlined, 'rotulo': 'Compras'},
  {'chave': 'energia', 'icone': Icons.lightbulb_outline_rounded, 'rotulo': 'Energia'},
  {'chave': 'educacao', 'icone': Icons.school_outlined, 'rotulo': 'Educação'},
  {'chave': 'pix', 'icone': Icons.send_rounded, 'rotulo': 'Pix / Transferência'},
  {'chave': 'dinheiro', 'icone': Icons.attach_money_rounded, 'rotulo': 'Dinheiro'},
  {'chave': 'carro', 'icone': Icons.directions_car_rounded, 'rotulo': 'Carro'},
  {'chave': 'saude_coracao', 'icone': Icons.favorite_border_rounded, 'rotulo': 'Saúde / Coração'},
  {'chave': 'ingresso', 'icone': Icons.local_activity_outlined, 'rotulo': 'Ingresso / Lazer'},
  {'chave': 'roupas', 'icone': Icons.checkroom_rounded, 'rotulo': 'Roupas'},
  {'chave': 'livro', 'icone': Icons.book_outlined, 'rotulo': 'Livro / Educação'},
  {'chave': 'agua', 'icone': Icons.local_drink_rounded, 'rotulo': 'Água'},
  {'chave': 'raio', 'icone': Icons.flash_on_rounded, 'rotulo': 'Raio / Energia'},
  {'chave': 'casa', 'icone': Icons.home_outlined, 'rotulo': 'Casa'},
  {'chave': 'cartao', 'icone': Icons.credit_card_rounded, 'rotulo': 'Cartão'},
  {'chave': 'receita', 'icone': Icons.arrow_downward_rounded, 'rotulo': 'Receita'},
  {'chave': 'despesa', 'icone': Icons.arrow_upward_rounded, 'rotulo': 'Despesa'},
];
