// healingbloom\lib\screens\navigation\bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:healingbloom/theme/app_theme.dart';

class CurvedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onMenuPressed;

  const CurvedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: PhysicalShape(
        elevation: 24,
        clipper: const BottomNavBarClipper(),
        color: AppTheme.pearlWhite.withAlpha(237),
        shadowColor: AppTheme.velvetAmethyst.withAlpha(75),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.velvetAmethyst.withAlpha(35),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(Icons.home_filled, 0),
              _buildNavItem(Icons.health_and_safety, 1),
              _buildNavItem(Icons.camera_alt_rounded, 2),
              _buildNavItem(Icons.shopping_bag_rounded, 3),
              _buildMenuButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: currentIndex == index
                  ? AppTheme.royalPlum
                  : AppTheme.velvetAmethyst,
              size: 32,
            ),
            if (currentIndex == index)
              Container(
                margin: const EdgeInsets.only(top: 6),
                height: 4,
                width: 24,
                decoration: BoxDecoration(
                  color: AppTheme.royalPlum,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.royalPlum.withAlpha(50),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return SizedBox(
      width: 80,
      child: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          color: AppTheme.royalPlum,
          size: 36,
        ),
        onPressed: onMenuPressed,
      ),
    );
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  const BottomNavBarClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(25, 0)
      ..quadraticBezierTo(0, 25, 0, 50)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 50)
      ..quadraticBezierTo(size.width, 25, size.width - 25, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
