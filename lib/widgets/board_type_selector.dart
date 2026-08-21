import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BoardTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const BoardTypeSelector({super.key, required this.selected, required this.onChanged});

  static const _types = {
    'flex': {'name': 'Flex + Frame', 'icon': Icons.view_module},
    'acp': {'name': 'ACP Board', 'icon': Icons.layers},
    'led': {'name': 'LED Sign', 'icon': Icons.lightbulb},
    'hoarding': {'name': 'Hoarding', 'icon': Icons.billboard},
  };

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 2.5,
    children: _types.entries.map((e) => GestureDetector(
      onTap: () => onChanged(e.key),
      child: Container(
        decoration: BoxDecoration(
          color: selected == e.key ? AppTheme.gold.withOpacity(0.1) : Colors.white,
          border: Border.all(color: selected == e.key ? AppTheme.gold : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(e.value['icon'] as IconData, color: selected == e.key ? AppTheme.gold : Colors.grey),
          const SizedBox(width: 8),
          Text(e.value['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: selected == e.key ? AppTheme.gold : Colors.black87)),
        ]),
      ),
    )).toList(),
  );
}
