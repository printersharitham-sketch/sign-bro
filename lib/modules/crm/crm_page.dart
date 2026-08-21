import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class CRMModule extends SignBroModule {
  @override
  String get id => 'crm';
  @override
  String get title => 'CRM';
  @override
  String get description => 'Customer Relationship Management';
  @override
  IconData get icon => Icons.people_outline;

  @override
  Widget buildPage() => const CRMPage();
}

class CRMPage extends StatelessWidget {
  const CRMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('CRM'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                _StatCard(value: '1,284', label: 'Customers', color: Color(0xFF3B82F6)),
                _StatCard(value: '146', label: 'Active Projects', color: Color(0xFF10B981)),
                _StatCard(value: '23', label: 'Service Requests', color: Color(0xFFF59E0B)),
                _StatCard(value: '38', label: 'Follow-ups', color: Color(0xFF8B5CF6)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('ADD CUSTOMER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat, size: 18),
                    label: const Text('WHATSAPP\nFOLLOW-UP', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.greyText),
          ),
        ],
      ),
    );
  }
}
