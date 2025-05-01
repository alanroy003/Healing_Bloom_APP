// healingbloom\lib\screens\navigation\app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:healingbloom/screens/documents/documents_screen.dart';
import 'package:healingbloom/screens/profile/profile_screen.dart';
import 'package:healingbloom/theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = authProvider.userData;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
      ),
      elevation: 24,
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: AppTheme.pearlWhite,
      child: Column(
        children: [
          _buildHeader(context, userData),
          _buildDrawerItem(
            Icons.person_rounded,
            'Profile',
            () => _navigateTo(context, const ProfileScreen()),
          ),
          _buildDrawerItem(
            Icons.description_rounded,
            'Documents',
            () => _navigateTo(context, const DocumentsScreen()),
          ),
          _buildDrawerItem(Icons.settings_rounded, 'Settings', () {}),
          const Spacer(),
          _buildDrawerItem(Icons.logout_rounded, 'Log Out', () {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.logout(context);
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? userData) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: AppTheme.gradientPrimary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.pearlWhite,
              child: Icon(
                Icons.person_rounded,
                color: AppTheme.royalPlum,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              authProvider.username ?? 'Guest',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              authProvider.userEmail ?? 'No email provided',
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.royalPlum, size: 28),
      title: Text(title,
          style: const TextStyle(
            color: AppTheme.velvetAmethyst,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
