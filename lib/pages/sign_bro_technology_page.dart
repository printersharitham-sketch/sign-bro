import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../modules/module_registry.dart';

class SignBroTechnologyPage extends StatelessWidget {
  const SignBroTechnologyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = ModuleRegistry.modules;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Technologies'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final module = modules[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(module.icon, color: AppTheme.gold, size: 22),
              ),
              title: Text(
                module.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.darkText),
              ),
              subtitle: Text(
                module.description,
                style: const TextStyle(fontSize: 12, color: AppTheme.greyText),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.greyText),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => module.buildPage()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}