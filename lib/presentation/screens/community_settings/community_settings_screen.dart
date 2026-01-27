import 'package:flutter/material.dart';
import '../../../core/models/community_data.dart';
import '../../../core/theme/app_colors.dart';

class CommunitySettingsScreen extends StatefulWidget {
  const CommunitySettingsScreen({Key? key}) : super(key: key);

  @override
  State<CommunitySettingsScreen> createState() =>
      _CommunitySettingsScreenState();
}

class _CommunitySettingsScreenState extends State<CommunitySettingsScreen> {
  late List<CommunityMember> _members;
  bool _notificationsEnabled = true;
  bool _dataSharing = true;
  bool _communityUpdates = true;

  @override
  void initState() {
    super.initState();
    _members = CommunityMember.mockMembers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGrey,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: AppColors.deepAquiferBlue,
                unselectedLabelColor: AppColors.mediumGrey,
                indicatorColor: AppColors.deepAquiferBlue,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Community'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildCommunityTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Community Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Community',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with local water conservation leaders and organizations.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Community Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people_rounded,
                    title: 'Members',
                    value: '2,543',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.water_drop_rounded,
                    title: 'Liters Saved',
                    value: '1.2M',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Members List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Active Organizations',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGrey,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Members List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                _members.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _members.length - 1 ? 12 : 32,
                  ),
                  child: _buildMemberCard(_members[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Settings Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Settings',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingTile(
                  title: 'Notifications',
                  subtitle: 'Receive updates about water levels and tasks',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  title: 'Data Sharing',
                  subtitle:
                      'Share your data to help improve predictions and community insights',
                  value: _dataSharing,
                  onChanged: (value) {
                    setState(() => _dataSharing = value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  title: 'Community Updates',
                  subtitle: 'Receive newsletters about community activities',
                  value: _communityUpdates,
                  onChanged: (value) {
                    setState(() => _communityUpdates = value);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 32, indent: 16, endIndent: 16),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingButton(
                  icon: Icons.info_outlined,
                  title: 'About Jal Dharan',
                  subtitle: 'Learn about our mission and vision',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildSettingButton(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Review our privacy practices',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildSettingButton(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Read our terms of service',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const Divider(height: 32, indent: 16, endIndent: 16),

          // Account Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingButton(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  isDestructive: true,
                  onTap: () {
                    _showLogoutDialog();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepAquiferBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.deepAquiferBlue,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(CommunityMember member) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.deepAquiferBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.initials,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepAquiferBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                    if (member.isAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.fieldGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fieldGreen,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member.location,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${member.points}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.deepAquiferBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.deepAquiferBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.criticalRed.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDestructive
              ? Border.all(
                  color: AppColors.criticalRed.withOpacity(0.2),
                )
              : null,
          boxShadow: isDestructive
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.criticalRed.withOpacity(0.1)
                    : AppColors.deepAquiferBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? AppColors.criticalRed
                    : AppColors.deepAquiferBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDestructive
                          ? AppColors.criticalRed
                          : AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDestructive
                  ? AppColors.criticalRed
                  : AppColors.mediumGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.criticalRed),
            ),
          ),
        ],
      ),
    );
  }
}
