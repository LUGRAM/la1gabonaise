import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../routes/app_routes.dart';

/// Bottom navigation bar global.
/// Injecté dans les pages principales (Home, Search, Downloads, Profile).
class L1BottomNav extends StatelessWidget {
  final int currentIndex;

  const L1BottomNav({super.key, required this.currentIndex});

  static const _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', route: AppRoutes.home),
    _NavItem(icon: Icons.search, activeIcon: Icons.search, label: 'Chercher', route: AppRoutes.search),
    _NavItem(icon: Icons.download_outlined, activeIcon: Icons.download, label: 'Offline', route: AppRoutes.downloads),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil', route: AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xF50A0A0A),
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isActive) Get.offNamed(item.route);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive ? AppColors.primary : AppColors.textDisabled,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    if (isActive)
                      Container(
                        width: 4, height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 9, color: AppColors.textDisabled,
                          fontFamily: 'monospace', letterSpacing: 0.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.route});
}
