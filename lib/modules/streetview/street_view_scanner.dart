import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class StreetViewModule extends SignBroModule {
  @override
  String get id => 'streetview';
  @override
  String get title => 'Street View Scanner';
  @override
  String get description => 'AI detects damaged signs from street imagery';
  @override
  IconData get icon => Icons.streetview;

  @override
  Widget buildPage() => const StreetViewScannerPage();
}

class StreetViewScannerPage extends StatefulWidget {
  const StreetViewScannerPage({super.key});

  @override
  State<StreetViewScannerPage> createState() => _StreetViewScannerState();
}

class _StreetViewScannerState extends State<StreetViewScannerPage> {
  String _selectedCity = 'Ernakulam';
  String _selectedRadius = '2km';
  bool _scanning = false;
  List<DimmedBoardOpportunity> _opportunities = [];
  int? _selectedOpportunityIndex;

  final cities = ['Adimali', 'Ernakulam', 'TVM', 'Kozhikode', 'Thrissur', 'Kochi'];
  final radii = ['1km', '2km', '5km', '10km'];

  Future<void> _runScan() async {
    setState(() {
      _scanning = true;
      _opportunities = [];
      _selectedOpportunityIndex = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _scanning = false;
      _opportunities = [
        const DimmedBoardOpportunity(
          businessName: 'Kerala Bakery',
          address: 'MG Road, Ernakulam',
          coords: '9.9312\u00b0 N, 76.2673\u00b0 E',
          boardCondition: 'Severely Faded',
          conditionScore: 22,
          estimatedSize: '4.2 \u00d7 1.2 m',
          boardType: 'Flex Banner',
          opportunityScore: 92,
          lastUpdated: 'Street View: Jan 2025',
        ),
        const DimmedBoardOpportunity(
          businessName: 'Royal Furniture',
          address: 'Broadway, Kochi',
          coords: '9.9673\u00b0 N, 76.2882\u00b0 E',
          boardCondition: 'Damaged Frame',
          conditionScore: 35,
          estimatedSize: '6.0 \u00d7 2.0 m',
          boardType: 'ACP Board',
          opportunityScore: 88,
          lastUpdated: 'Street View: Mar 2025',
        ),
        const DimmedBoardOpportunity(
          businessName: 'City Electronics',
          address: 'NH-66, Thrissur',
          coords: '10.5276\u00b0 N, 76.2144\u00b0 E',
          boardCondition: 'Missing Letters',
          conditionScore: 45,
          estimatedSize: '8.0 \u00d7 3.0 m',
          boardType: 'LED Signboard',
          opportunityScore: 85,
          lastUpdated: 'Street View: Feb 2025',
        ),
        const DimmedBoardOpportunity(
          businessName: 'Malabar Hotel',
          address: 'SM Street, Kozhikode',
          coords: '11.2588\u00b0 N, 75.7804\u00b0 E',
          boardCondition: 'Rusted Frame',
          conditionScore: 28,
          estimatedSize: '5.0 \u00d7 1.5 m',
          boardType: 'Backlit Board',
          opportunityScore: 90,
          lastUpdated: 'Street View: Apr 2025',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedOpportunityIndex != null) {
      return _buildWorkCanvas(_opportunities[_selectedOpportunityIndex!]);
    }
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Street View Scanner'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildControls(),
            const SizedBox(height: 20),
            _buildScanButton(),
            const SizedBox(height: 20),
            if (_scanning) _buildLoadingAnimation(),
            if (!_scanning && _opportunities.isNotEmpty) ...[
              _buildResultsCount(),
              const SizedBox(height: 12),
              ..._opportunities.asMap().entries.map(
                (entry) => _buildOpportunityCard(entry.value, entry.key),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('\ud83c\udf10', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              'Street View AI Scanner',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'AI-powered detection of damaged & dimmed signboards',
          style: TextStyle(fontSize: 13, color: AppTheme.greyText),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI-generated estimate \u2014 requires manual verification',
                  style: TextStyle(fontSize: 11, color: Color(0xFFF59E0B), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
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
        children: [
          const Text('Select City', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCity,
                isExpanded: true,
                items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: (v) => setState(() => _selectedCity = v!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Scan Radius', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
          const SizedBox(height: 8),
          Row(
            children: radii.map((r) {
              final isSelected = _selectedRadius == r;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedRadius = r),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? AppTheme.gold : const Color(0xFFE5E7EB)),
                    ),
                    child: Center(
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.darkText,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _scanning ? null : _runScan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.gold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\ud83d\udd0d', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Text('Start AI Scan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
            ),
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: 3),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              final dots = '.' * (value % 4);
              return Text(
                'Analyzing Street View imagery$dots',
                style: const TextStyle(fontSize: 14, color: AppTheme.greyText, fontWeight: FontWeight.w500),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Scanning $_selectedCity within $_selectedRadius radius',
            style: const TextStyle(fontSize: 12, color: AppTheme.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 6),
          Text(
            'Found ${_opportunities.length} opportunities',
            style: const TextStyle(fontSize: 13, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(DimmedBoardOpportunity opp, int index) {
    final condColor = opp.conditionScore < 30
        ? const Color(0xFFEF4444)
        : opp.conditionScore < 50
            ? const Color(0xFFF59E0B)
            : const Color(0xFF3B82F6);

    return GestureDetector(
      onTap: () => setState(() => _selectedOpportunityIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: condColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opp.businessName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(opp.address, style: const TextStyle(fontSize: 12, color: AppTheme.greyText)),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${opp.opportunityScore}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.gold),
                            ),
                            const Text('/100', style: TextStyle(fontSize: 9, color: AppTheme.greyText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: condColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opp.boardCondition,
                          style: TextStyle(fontSize: 11, color: condColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opp.boardType,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.straighten, size: 14, color: AppTheme.greyText),
                      const SizedBox(width: 4),
                      Text(opp.estimatedSize, style: const TextStyle(fontSize: 12, color: AppTheme.greyText)),
                      const Spacer(),
                      Text(
                        opp.lastUpdated,
                        style: const TextStyle(fontSize: 11, color: AppTheme.greyText, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\u26a0\ufe0f', style: TextStyle(fontSize: 10)),
                        SizedBox(width: 4),
                        Text(
                          'AI Estimate \u2014 Verify on site',
                          style: TextStyle(fontSize: 10, color: Color(0xFFF59E0B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallActionBtn(
                          label: '\ud83d\udccd View on Map',
                          color: const Color(0xFF3B82F6),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SmallActionBtn(
                          label: '\ud83d\udccb Create Lead',
                          color: const Color(0xFF10B981),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _SmallActionBtn(
                          label: '\ud83d\udcde Contact',
                          color: const Color(0xFF8B5CF6),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkCanvas(DimmedBoardOpportunity opp) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Work Canvas'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedOpportunityIndex = null),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: NetworkImage('https://picsum.photos/seed/streetview/600/300'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 40,
                    top: 30,
                    child: Container(
                      width: 180,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFEF4444), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'AI Detected',
                            style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    bottom: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: Colors.black.withOpacity(0.7),
                      child: Text(
                        opp.estimatedSize,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(opp.businessName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            const SizedBox(height: 4),
            Text(opp.address, style: const TextStyle(fontSize: 13, color: AppTheme.greyText)),
            Text(opp.coords, style: const TextStyle(fontSize: 12, color: AppTheme.greyText, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ComparisonCard(
                    title: 'BEFORE (Current)',
                    subtitle: opp.boardCondition,
                    color: const Color(0xFFEF4444),
                    imageUrl: 'https://picsum.photos/seed/before${opp.businessName.hashCode}/300/200',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ComparisonCard(
                    title: 'AFTER (Proposed)',
                    subtitle: 'New ${opp.boardType}',
                    color: const Color(0xFF10B981),
                    imageUrl: 'https://picsum.photos/seed/after${opp.businessName.hashCode}/300/200',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
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
                children: [
                  const Text('Board Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Type', value: opp.boardType),
                  _DetailRow(label: 'Size', value: opp.estimatedSize),
                  _DetailRow(label: 'Condition', value: opp.boardCondition),
                  _DetailRow(label: 'Score', value: '${opp.conditionScore}/100'),
                  _DetailRow(label: 'Opportunity', value: '${opp.opportunityScore}/100'),
                  _DetailRow(label: 'Last Captured', value: opp.lastUpdated),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Quote Estimate', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Material', value: _getMaterialCost(opp.boardType)),
                  _DetailRow(label: 'Labour', value: '\u20b93,500'),
                  _DetailRow(label: 'Installation', value: '\u20b92,000'),
                  const Divider(),
                  _DetailRow(label: 'Total Estimate', value: _getTotalEstimate(opp.boardType), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text('\u26a0\ufe0f', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Estimate \u2014 Verify on site before sending final quote',
                      style: TextStyle(fontSize: 12, color: Color(0xFFF59E0B), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat, size: 18),
                label: const Text('Send to Client via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: const Text('Create Lead', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.gold,
                      side: const BorderSide(color: AppTheme.gold),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: const Text('View on Map', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3B82F6),
                      side: const BorderSide(color: Color(0xFF3B82F6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getMaterialCost(String boardType) {
    switch (boardType) {
      case 'Flex Banner':
        return '\u20b94,200';
      case 'ACP Board':
        return '\u20b912,000';
      case 'LED Signboard':
        return '\u20b918,500';
      case 'Backlit Board':
        return '\u20b99,800';
      default:
        return '\u20b98,000';
    }
  }

  String _getTotalEstimate(String boardType) {
    switch (boardType) {
      case 'Flex Banner':
        return '\u20b99,700';
      case 'ACP Board':
        return '\u20b917,500';
      case 'LED Signboard':
        return '\u20b924,000';
      case 'Backlit Board':
        return '\u20b915,300';
      default:
        return '\u20b913,500';
    }
  }
}

class DimmedBoardOpportunity {
  final String businessName;
  final String address;
  final String coords;
  final String boardCondition;
  final int conditionScore;
  final int opportunityScore;
  final String estimatedSize;
  final String boardType;
  final String lastUpdated;

  const DimmedBoardOpportunity({
    required this.businessName,
    required this.address,
    required this.coords,
    required this.boardCondition,
    required this.conditionScore,
    required this.opportunityScore,
    required this.estimatedSize,
    required this.boardType,
    required this.lastUpdated,
  });
}

class _SmallActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SmallActionBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String title, subtitle, imageUrl;
  final Color color;
  const _ComparisonCard({required this.title, required this.subtitle, required this.color, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.greyText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  final bool isBold;
  const _DetailRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.greyText, fontWeight: isBold ? FontWeight.w600 : FontWeight.normal)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 12, color: AppTheme.darkText, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}
