import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home/home_dashboard_page.dart';
import '../../feature/import_sheet/import_page.dart';

/// Route names used in the app
abstract final class AppRoutes {
  static const String shell = '/';
  static const String home = '/';
  static const String importSheet = '/import';
}

/// Global GoRouter instance configured with a ShellRoute for shared layout.
///
/// The ShellRoute is responsible only for navigation and shared layout
/// (Scaffold + BottomNavigationBar). It does not contain any business logic.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.path;
        const items = [
          _NavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            route: AppRoutes.home,
          ),
          // Browse and Settings are placeholders for future features.
          _NavItem(
            label: 'Browse',
            icon: Icons.search,
            route: '/browse',
            enabled: false,
          ),
          _NavItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            route: '/settings',
            enabled: false,
          ),
        ];

        int currentIndex = 0;
        for (var i = 0; i < items.length; i++) {
          if (location == items[i].route) {
            currentIndex = i;
            break;
          }
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                elevation: 0,
                onTap: (index) {
                  final item = items[index];
                  if (!item.enabled) return;
                  if (item.route != location) {
                    context.go(item.route);
                  }
                },
                items: items
                    .map(
                      (item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeDashboardPage()),
        ),
        GoRoute(
          path: AppRoutes.importSheet,
          name: 'importSheet',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ImportSheetPage()),
        ),
      ],
    ),
  ],
);

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  final bool enabled;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.enabled = true,
  });
}
