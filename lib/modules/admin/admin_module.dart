import 'package:flutter/material.dart';
import '../../core/sign_bro_module.dart';
import '../../theme/app_theme.dart';

class AdminModule extends SignBroModule {
  @override
  String get id => 'admin';
  @override
  String get title => 'Admin Hub';
  @override
  String get description => 'Operations, leads, inventory & analytics';
  @override
  IconData get icon => Icons.admin_panel_settings;

  @override
  Widget buildPage() => const AdminPage();
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  int _selectedHub = 0;
  int _selectedSection = 0;
  final hubs = ['ALL', 'ADIMALI', 'ERNAKULAM', 'TVM', 'KOZHIKODE'];

  final stats = {
    'ALL': {'revenue': '₹4,82,500', 'jobs': 146, 'leads': 38, 'team': 24},
    'ADIMALI': {'revenue': '₹1,12,000', 'jobs': 32, 'leads': 8, 'team': 6},
    'ERNAKULAM': {'revenue': '₹1,85,000', 'jobs': 54, 'leads': 14, 'team': 9},
    'TVM': {'revenue': '₹98,500', 'jobs': 38, 'leads': 10, 'team': 5},
    'KOZHIKODE': {'revenue': '₹87,000', 'jobs': 22, 'leads': 6, 'team': 4},
  };

  final sections = ['Dashboard', 'Leads', 'Jobs', 'Inventory', 'Vendors', 'Analytics', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Admin Hub'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkText,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHubSelector(),
          _buildSectionTabs(),
          Expanded(child: _buildSectionContent()),
        ],
      ),
    );
  }

  Widget _buildHubSelector() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hubs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedHub == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedHub = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.gold : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? AppTheme.gold : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                hubs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.darkText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTabs() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final isSelected = _selectedSection == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedSection = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.gold : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                sections[index],
                style: TextStyle(
                  color: isSelected ? AppTheme.gold : AppTheme.greyText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildLeadPipeline();
      case 2:
        return _buildJobScheduling();
      case 3:
        return _buildInventory();
      case 4:
        return _buildVendors();
      case 5:
        return _buildAnalytics();
      case 6:
        return _buildSettings();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    final hubKey = hubs[_selectedHub];
    final hubStats = stats[hubKey]!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _DashCard(
                title: 'Total Revenue',
                value: hubStats['revenue'].toString(),
                icon: Icons.currency_rupee,
                color: const Color(0xFF10B981),
              ),
              _DashCard(
                title: 'Active Jobs',
                value: hubStats['jobs'].toString(),
                icon: Icons.work_outline,
                color: const Color(0xFF3B82F6),
              ),
              _DashCard(
                title: 'Pending Leads',
                value: hubStats['leads'].toString(),
                icon: Icons.leaderboard,
                color: const Color(0xFFF59E0B),
              ),
              _DashCard(
                title: 'Team Members',
                value: hubStats['team'].toString(),
                icon: Icons.group,
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'New Lead',
                  icon: Icons.person_add,
                  color: const Color(0xFF3B82F6),
                  onTap: () => setState(() => _selectedSection = 1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'Schedule Job',
                  icon: Icons.calendar_today,
                  color: const Color(0xFF10B981),
                  onTap: () => setState(() => _selectedSection = 2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'Order Stock',
                  icon: Icons.inventory_2,
                  color: const Color(0xFFF59E0B),
                  onTap: () => setState(() => _selectedSection = 3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadPipeline() {
    final stages = [
      _PipelineStage(
        name: 'NEW',
        color: const Color(0xFF3B82F6),
        leads: [
          _LeadCard(business: 'Metro Textiles', location: 'MG Road, EKM', boardType: 'ACP Board', value: '₹45,000'),
          _LeadCard(business: 'Fresh Mart', location: 'Palarivattom', boardType: 'LED Sign', value: '₹72,000'),
          _LeadCard(business: 'City Pharma', location: 'Aluva', boardType: 'Flex Banner', value: '₹18,000'),
        ],
      ),
      _PipelineStage(
        name: 'CONTACTED',
        color: const Color(0xFFF59E0B),
        leads: [
          _LeadCard(business: 'Green Valley Resort', location: 'Munnar Road', boardType: 'ACP + LED', value: '₹1,20,000'),
          _LeadCard(business: 'Quick Fix Auto', location: 'Bypass Rd', boardType: 'Backlit Board', value: '₹55,000'),
        ],
      ),
      _PipelineStage(
        name: 'QUOTED',
        color: const Color(0xFF8B5CF6),
        leads: [
          _LeadCard(business: 'KL Supermarket', location: 'Thodupuzha', boardType: 'ACP Board', value: '₹88,000'),
          _LeadCard(business: 'Royal Jewellers', location: 'Broadway', boardType: 'LED Signboard', value: '₹1,50,000'),
        ],
      ),
      _PipelineStage(
        name: 'WON',
        color: const Color(0xFF10B981),
        leads: [
          _LeadCard(business: 'Hotel Malabar', location: 'Adimali', boardType: 'ACP + LED', value: '₹95,000'),
          _LeadCard(business: 'Tech Hub Store', location: 'Infopark', boardType: 'Channel Letters', value: '₹1,35,000'),
        ],
      ),
      _PipelineStage(
        name: 'LOST',
        color: const Color(0xFFEF4444),
        leads: [
          _LeadCard(business: 'Old Bazaar Shop', location: 'Fort Kochi', boardType: 'Flex Banner', value: '₹12,000'),
        ],
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stages.map((stage) {
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: stage.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        stage.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${stage.leads.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                ...stage.leads.map((lead) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.business, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(lead.location, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: stage.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(lead.boardType, style: TextStyle(fontSize: 10, color: stage.color)),
                          ),
                          const Spacer(),
                          Text(lead.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.darkText)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (stage.name != 'WON' && stage.name != 'LOST')
                        SizedBox(
                          height: 28,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              side: BorderSide(color: stage.color.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text('→ Move', style: TextStyle(fontSize: 11, color: stage.color)),
                          ),
                        ),
                    ],
                  ),
                )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobScheduling() {
    final todayJobs = [
      {'time': '09:00 AM', 'client': 'Hotel Malabar', 'task': 'ACP Board Installation', 'technician': 'Rajesh K.', 'status': 'In Progress'},
      {'time': '10:30 AM', 'client': 'KL Supermarket', 'task': 'LED Module Fitting', 'technician': 'Anoop M.', 'status': 'Pending'},
      {'time': '02:00 PM', 'client': 'Green Valley Resort', 'task': 'Site Survey', 'technician': 'Vishnu P.', 'status': 'Scheduled'},
      {'time': '03:30 PM', 'client': 'Royal Jewellers', 'task': 'Frame Welding', 'technician': 'Suresh T.', 'status': 'Scheduled'},
      {'time': '05:00 PM', 'client': 'Quick Fix Auto', 'task': 'Backlit Board Wiring', 'technician': 'Arun S.', 'status': 'Scheduled'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: AppTheme.gold),
              const SizedBox(width: 8),
              const Text(
                "Today's Schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${todayJobs.length} jobs',
                  style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...todayJobs.map((job) {
            final statusColor = job['status'] == 'In Progress'
                ? const Color(0xFF3B82F6)
                : job['status'] == 'Pending'
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF6B7280);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: statusColor, width: 3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(job['time']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['client']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(job['task']!, style: const TextStyle(fontSize: 12, color: AppTheme.greyText)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: AppTheme.greyText),
                            const SizedBox(width: 4),
                            Text(job['technician']!, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job['status']!,
                      style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInventory() {
    final inventory = [
      _InventoryItem(name: 'ACP Sheets', current: 45, total: 100, unit: 'units'),
      _InventoryItem(name: 'Flex Roll', current: 8, total: 50, unit: 'rolls'),
      _InventoryItem(name: 'LED Modules', current: 220, total: 500, unit: 'pcs'),
      _InventoryItem(name: 'MS Pipe', current: 12, total: 30, unit: 'lengths'),
      _InventoryItem(name: 'Vinyl Roll', current: 15, total: 40, unit: 'rolls'),
      _InventoryItem(name: 'Acrylic Sheet', current: 28, total: 60, unit: 'sheets'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2, size: 18, color: AppTheme.gold),
              const SizedBox(width: 8),
              const Text(
                'Inventory Tracker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber, size: 14, color: Color(0xFFEF4444)),
                    SizedBox(width: 4),
                    Text('2 LOW STOCK', style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...inventory.map((item) {
            final ratio = item.current / item.total;
            final isLow = ratio < 0.25;
            final isWarning = ratio >= 0.25 && ratio < 0.5;
            final barColor = isLow
                ? const Color(0xFFEF4444)
                : isWarning
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isLow ? Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)) : null,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                      Text(
                        '${item.current}/${item.total} ${item.unit}',
                        style: TextStyle(fontSize: 12, color: barColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: barColor.withOpacity(0.1),
                      color: barColor,
                      minHeight: 8,
                    ),
                  ),
                  if (isLow) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.warning_amber, size: 14, color: Color(0xFFEF4444)),
                        const SizedBox(width: 4),
                        const Text('LOW STOCK ALERT', style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text('Order Stock', style: TextStyle(fontSize: 11, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVendors() {
    final vendors = [
      {'name': 'Kerala ACP Traders', 'type': 'ACP Sheets & Panels', 'location': 'Ernakulam', 'rating': '4.8'},
      {'name': 'Bright LED Solutions', 'type': 'LED Modules & Strips', 'location': 'Kochi', 'rating': '4.5'},
      {'name': 'Steel Craft Works', 'type': 'MS Pipes & Fabrication', 'location': 'Adimali', 'rating': '4.7'},
      {'name': 'Flex Print House', 'type': 'Flex & Vinyl Rolls', 'location': 'TVM', 'rating': '4.3'},
      {'name': 'Sign Hardware Co.', 'type': 'Fasteners & Brackets', 'location': 'Kozhikode', 'rating': '4.6'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Vendor Management',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...vendors.map((vendor) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.store, color: AppTheme.gold, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(vendor['type']!, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                      const SizedBox(height: 2),
                      Text(vendor['location']!, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 2),
                    Text(vendor['rating']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    final barData = [
      {'label': 'Jan', 'value': 65},
      {'label': 'Feb', 'value': 78},
      {'label': 'Mar', 'value': 92},
      {'label': 'Apr', 'value': 85},
      {'label': 'May', 'value': 110},
      {'label': 'Jun', 'value': 95},
    ];
    final maxVal = 110.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Analytics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monthly revenue (₹ thousands)',
            style: TextStyle(fontSize: 12, color: AppTheme.greyText),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: barData.map((data) {
                      final barHeight = ((data['value'] as int) / maxVal) * 150;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '₹${data['value']}k',
                              style: const TextStyle(fontSize: 9, color: AppTheme.greyText),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: barHeight,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFE8C84A)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(data['label'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Job Completion Rate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                _AnalyticsRow(label: 'Completed on Time', value: 78, color: const Color(0xFF10B981)),
                const SizedBox(height: 12),
                _AnalyticsRow(label: 'Delayed', value: 15, color: const Color(0xFFF59E0B)),
                const SizedBox(height: 12),
                _AnalyticsRow(label: 'Cancelled', value: 7, color: const Color(0xFFEF4444)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText),
          ),
          const SizedBox(height: 16),
          _SettingsSection(title: 'Hub Management', items: [
            _SettingsItem(icon: Icons.location_city, label: 'Manage Hubs', subtitle: 'Add/remove hub locations'),
            _SettingsItem(icon: Icons.map, label: 'Coverage Areas', subtitle: 'Set service radius per hub'),
          ]),
          const SizedBox(height: 16),
          _SettingsSection(title: 'User Roles', items: [
            _SettingsItem(icon: Icons.admin_panel_settings, label: 'Admin Access', subtitle: 'Full access to all features'),
            _SettingsItem(icon: Icons.engineering, label: 'Technician Access', subtitle: 'Job view & updates only'),
            _SettingsItem(icon: Icons.support_agent, label: 'Sales Access', subtitle: 'CRM & lead management'),
          ]),
          const SizedBox(height: 16),
          _SettingsSection(title: 'Notifications', items: [
            _SettingsItem(icon: Icons.notifications, label: 'Push Notifications', subtitle: 'Job updates & alerts'),
            _SettingsItem(icon: Icons.chat, label: 'WhatsApp Alerts', subtitle: 'Low stock & new leads'),
          ]),
        ],
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _DashCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _PipelineStage {
  final String name;
  final Color color;
  final List<_LeadCard> leads;
  const _PipelineStage({required this.name, required this.color, required this.leads});
}

class _LeadCard {
  final String business, location, boardType, value;
  const _LeadCard({required this.business, required this.location, required this.boardType, required this.value});
}

class _InventoryItem {
  final String name, unit;
  final int current, total;
  const _InventoryItem({required this.name, required this.current, required this.total, required this.unit});
}

class _AnalyticsRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _AnalyticsRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.darkText)),
        ),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.1),
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$value%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.greyText)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final item = entry.value;
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppTheme.gold, size: 22),
                    title: Text(item.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.greyText)),
                    trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.greyText),
                    onTap: () {},
                  ),
                  if (!isLast) const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label, subtitle;
  const _SettingsItem({required this.icon, required this.label, required this.subtitle});
}
