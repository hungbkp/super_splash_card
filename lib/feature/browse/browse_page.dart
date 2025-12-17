import 'package:flutter/material.dart';

import '../../core/di/app_di.dart';
import '../../data/model/flashcard.dart';
import 'browse_state.dart';
import 'browse_vm.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  late final BrowseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BrowseViewModel(flashCardRepository);
    // Load on first display
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            final state = _viewModel.state;

            if (state is BrowseLoading || state is BrowseIdle) {
              return _buildLoading(context);
            }

            if (state is BrowseError) {
              return _buildError(context, state.message);
            }

            if (state is BrowseEmpty) {
              return _buildEmpty(context);
            }

            final loadedState = state as BrowseLoaded;
            return _buildList(context, loadedState.flashcards);
          },
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Failed to load flashcards',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.style_outlined, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'No flashcards imported yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Import a Google Sheet deck first, then come back here to browse your cards.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<FlashCard> flashcards) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8);
    final surfaceColor =
        isDark ? const Color(0xFF1C252E) : const Color(0xFFFFFFFF);
    final borderColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                'Browse Cards',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemBuilder: (context, index) {
                  final card = flashcards[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (card.id != null && card.id!.isNotEmpty)
                          Text(
                            '#${card.id}',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                          ),
                        if (card.id != null && card.id!.isNotEmpty)
                          const SizedBox(height: 4),
                        Text(
                          card.word,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.meaning,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (card.definition != null &&
                            card.definition!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            card.definition!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: secondaryTextColor),
                          ),
                        ],
                        if (card.example != null &&
                            card.example!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '"${card.example!}"',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: secondaryTextColor,
                                ),
                          ),
                        ],
                        if (card.ipa != null && card.ipa!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            card.ipa!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: secondaryTextColor),
                          ),
                        ],
                        if (card.note != null && card.note!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            card.note!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: secondaryTextColor),
                          ),
                        ],
                        if (card.updatedAt != null &&
                            card.updatedAt!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Updated: ${card.updatedAt}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: secondaryTextColor),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: flashcards.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


