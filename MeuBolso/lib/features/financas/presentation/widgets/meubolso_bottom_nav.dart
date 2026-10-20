import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class MeuBolsoBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const MeuBolsoBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _itens = [
    (Icons.home_outlined, 'Início'),
    (Icons.receipt_outlined, 'Transações'),
    (Icons.flag_outlined, 'relatório'),
    (Icons.more_horiz_rounded, 'Mais'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              for (var i = 0; i < _itens.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: _NavItem(
                      icon: _itens[i].$1,
                      label: _itens[i].$2,
                      selected: selectedIndex == i,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.navUnselected;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 23, color: color),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 10.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: color,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
