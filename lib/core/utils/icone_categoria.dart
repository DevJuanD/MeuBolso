import 'package:flutter/material.dart';

/// Mapeia o nome de uma categoria para um ícone representativo na UI.
///
/// É apenas uma preocupação de apresentação: os dados financeiros continuam
/// vindo do banco de dados.
IconData iconeParaCategoria(String categoria) {
  switch (categoria) {
    case 'Salário':
      return Icons.work_outline_rounded;
    case 'Freelance':
    case 'Renda extra':
      return Icons.laptop_mac_rounded;
    case 'Vendas':
    case 'Compras':
      return Icons.shopping_bag_outlined;
    case 'Rendimentos':
      return Icons.trending_up_rounded;
    case 'Presente':
      return Icons.card_giftcard_rounded;
    case 'Alimentação':
      return Icons.restaurant_rounded;
    case 'Transporte':
      return Icons.directions_bus_filled_outlined;
    case 'Moradia':
      return Icons.home_outlined;
    case 'Contas e serviços':
    case 'Internet':
      return Icons.wifi_rounded;
    case 'Saúde':
      return Icons.favorite_border_rounded;
    case 'Lazer':
      return Icons.local_activity_outlined;
    case 'Educação':
      return Icons.school_outlined;
    case 'Supermercado':
      return Icons.shopping_cart_outlined;
    case 'Combustível':
      return Icons.local_gas_station_outlined;
    case 'Conta de energia':
      return Icons.lightbulb_outline_rounded;
    default:
      return Icons.more_horiz_rounded;
  }
}
