import 'package:flutter/material.dart';
import 'package:lapar_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showDemoToast(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu "$feature" disimulasikan.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Keluar dari SnapFlorist...'),
        duration: Duration(milliseconds: 600),
      ),
    );
    
    productProvider.clearProducts();
    await authProvider.signOut();
    
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userData = authProvider.userData;
    
    final String userName = userData?['nama'] ?? user?.displayName ?? 'Pengguna SnapFlorist';
    final String userEmail = userData?['email'] ?? user?.email ?? 'email@example.com';
    final String? photoUrl = user?.photoURL;
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    final String userId = userData?['id']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.menu, color: AppTheme.textPrimary),
            const Spacer(),
            Text(
              'SnapFlorist',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            const Icon(Icons.notifications_none, color: AppTheme.textPrimary),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: photoUrl != null && photoUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              
              Center(
                child: Text(
                  userEmail,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              if (userId.isNotEmpty)
                Center(
                  child: Text(
                    'User ID: $userId',
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 11,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              Row(
                children: [
                  _buildStatBox(context, '0', 'TOTAL ORDERS'),
                  const SizedBox(width: 16),
                  _buildStatBox(context, 'Silver', 'MEMBER CLASS'),
                ],
              ),

              const SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 10),
                    child: Text(
                      'Account Settings',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 1,
                    shadowColor: Colors.black12,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            context,
                            Icons.history,
                            'Order History',
                            () => _showDemoToast(context, 'Order History'),
                          ),
                          const Divider(color: AppTheme.border, height: 1),
                          _buildSettingItem(
                            context,
                            Icons.notifications_none,
                            'Notifications',
                            () => _showDemoToast(context, 'Notifications'),
                          ),
                          const Divider(color: AppTheme.border, height: 1),
                          _buildSettingItem(
                            context,
                            Icons.lock_outline,
                            'Privacy',
                            () => _showDemoToast(context, 'Privacy'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              OutlinedButton(
                onPressed: () => _handleLogout(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFECEC),
                  foregroundColor: AppTheme.error,
                  side: BorderSide.none,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, size: 20, color: AppTheme.error),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Card(
                elevation: 3,
                shadowColor: AppTheme.primary.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          bottom: -30,
                          child: Opacity(
                            opacity: 0.1,
                            child: Icon(Icons.local_florist, size: 130, color: Colors.white),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Need assistance?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Our floral experts are available 24/7 to help with your orders.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _showDemoToast(context, 'Chat Support');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primary,
                                minimumSize: const Size(120, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Chat Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String value, String label) {
    return Expanded(
      child: Card(
        color: const Color(0xFFFBF4F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF3E7EA), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6ECE8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4A6855), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textLight),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}