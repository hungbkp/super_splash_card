import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF101922)
        : const Color(0xFFF6F7F8);
    final surfaceColor = isDark
        ? const Color(0xFF1C252E)
        : const Color(0xFFFFFFFF);
    const primaryColor = Color(0xFF137FEC);
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            color: backgroundColor,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Flashcards',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_circle_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        // Stats cards
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Decks',
                                icon: Icons.style,
                                value: '12',
                                primaryColor: primaryColor,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                                secondaryTextColor: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Cards',
                                icon: Icons.filter_none,
                                value: '340',
                                primaryColor: primaryColor,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                                secondaryTextColor: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Main actions
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Navigation to study feature can be wired later
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text(
                                  'Study Now',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  print('Navigate to Import Flashcards');
                                  context.push(AppRoutes.importSheet);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: primaryColor,
                                ),
                                label: const Text(
                                  'Import Flashcards',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: BorderSide(color: borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: surfaceColor,
                                  foregroundColor: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Recent decks
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Recent Decks',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: secondaryTextColor,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _RecentDeckTile(
                          title: 'Essential Phrasal Verbs',
                          subtitle: '50 cards • Last studied 2h ago',
                          icon: Icons.school,
                          iconColor: Colors.green,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            // Navigation to deck details can be wired later
                          },
                        ),
                        const SizedBox(height: 8),
                        _RecentDeckTile(
                          title: 'Business English',
                          subtitle: '120 cards • New',
                          icon: Icons.translate,
                          iconColor: Colors.orange,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          onTap: () {
                            // Navigation to deck details can be wired later
                          },
                        ),
                        const SizedBox(height: 24),
                        // Divider label for demo purposes
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: isDark
                                    ? const Color(0xFF1F2933)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                'DEMO: EMPTY STATE BELOW',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: secondaryTextColor),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: isDark
                                    ? const Color(0xFF1F2933)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Empty state
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFD1D5DB),
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.library_add,
                                size: 40,
                                color: isDark
                                    ? const Color(0xFF4B5563)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No flashcards found',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 260,
                              child: Text(
                                'Your library is currently empty. Import a deck to start your learning journey.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: secondaryTextColor,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 260,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Navigation to import feature can be wired later
                                },
                                icon: const Icon(Icons.download),
                                label: const Text(
                                  'Import Flashcards',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 260,
                              child: OutlinedButton(
                                onPressed: null,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  disabledForegroundColor: secondaryTextColor
                                      .withOpacity(0.6),
                                ),
                                child: const Text('Study (Unavailable)'),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color primaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color secondaryTextColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.primaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: primaryColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentDeckTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color secondaryTextColor;
  final VoidCallback? onTap;

  const _RecentDeckTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.secondaryTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: secondaryTextColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }
}
