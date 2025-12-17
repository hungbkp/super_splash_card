import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/network/sheet_client.dart';
import '../../data/repository/flashcard_repository.dart';
import 'domain/usecase/import_flashcards_usecase.dart';
import 'import_state.dart';
import 'import_vm.dart';

class ImportSheetPage extends StatefulWidget {
  const ImportSheetPage({super.key});

  @override
  State<ImportSheetPage> createState() => _ImportSheetPageState();
}

class _ImportSheetPageState extends State<ImportSheetPage> {
  late final ImportSheetViewModel _viewModel;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final client = http.Client();
    final sheetClient = SheetCsvClient(client);
    final repository = FlashCardRepository(sheetClient);
    final useCase = ImportFlashCardsUseCase(repository);
    _viewModel = ImportSheetViewModel(useCase);
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101822)
        : const Color(0xFFF6F7F8);
    const primaryColor = Color(0xFF136DEC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            final state = _viewModel.state;

            if (state is ImportSheetLoading) {
              return _buildLoading(context, backgroundColor, primaryColor);
            }

            if (state is ImportSheetSuccess) {
              return _buildSuccess(
                context,
                backgroundColor,
                primaryColor,
                cardsCount: state.flashcards.length,
              );
            }

            if (state is ImportSheetError) {
              return _buildError(
                context,
                backgroundColor,
                primaryColor,
                errorMessage: state.errorMessage,
              );
            }

            return _buildIdle(context, backgroundColor, primaryColor);
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context, {
    required String title,
    VoidCallback? onBack,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIdle(
    BuildContext context,
    Color backgroundColor,
    Color primaryColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: backgroundColor,
        child: Column(
          children: [
            _buildTopBar(
              context,
              title: 'Import Deck',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Import from\nGoogle Sheets',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter a public Google Sheet URL to instantly generate flashcards.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF9DA8B9)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.link),
                        hintText: 'https://docs.google.com/spreadsheets/...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _viewModel.importFromUrl(_controller.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Import Deck',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Text(
                          'Need help formatting?',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? const Color(0xFF9DA8B9)
                                    : const Color(0xFF64748B),
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: open example sheet help
                          },
                          icon: const Icon(Icons.table_view),
                          label: const Text('View Example Sheet'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    Color backgroundColor,
    Color primaryColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: backgroundColor,
        child: Column(
          children: [
            _buildTopBar(context, title: 'Import Deck', onBack: null),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Google Sheet Link',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.2),
                                      width: 4,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: primaryColor,
                                  ),
                                ),
                                Icon(
                                  Icons.cloud_sync,
                                  color: primaryColor,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Fetching your data...',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Verifying sheet permissions and parsing vocabulary list.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF9DA8B9)
                                      : const Color(0xFF64748B),
                                ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isDark
                                              ? const Color(0xFF9DA8B9)
                                              : const Color(0xFF64748B),
                                        ),
                                  ),
                                  Text(
                                    '45%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isDark
                                              ? const Color(0xFF9DA8B9)
                                              : const Color(0xFF64748B),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: 0.45,
                                  minHeight: 6,
                                  backgroundColor: isDark
                                      ? const Color(0xFF3B4554)
                                      : const Color(0xFFE5E7EB),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        label: const Text('Importing...'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor.withOpacity(0.6),
                          disabledBackgroundColor: primaryColor.withOpacity(
                            0.6,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    Color backgroundColor,
    Color primaryColor, {
    required int cardsCount,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: backgroundColor,
        child: Column(
          children: [
            _buildTopBar(
              context,
              title: 'Import Status',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Import Successful!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Google Sheet has been successfully synced and converted into flashcards.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF93A2B7)
                            : const Color(0xFF637588),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _SuccessStatCard(
                            title: 'Cards Added',
                            value: cardsCount.toString(),
                            icon: Icons.filter_none,
                            primaryColor: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SuccessStatCard(
                            title: 'Deck Name',
                            value: 'Imported Deck',
                            icon: Icons.folder_open,
                            primaryColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: navigate to study screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Study Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Back to Library',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    Color backgroundColor,
    Color primaryColor, {
    required String errorMessage,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: backgroundColor,
        child: Column(
          children: [
            _buildTopBar(
              context,
              title: 'Import from Sheets',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF3F1B1B)
                            : const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFFFCA5A5).withOpacity(0.4)
                              : const Color(0xFFFCA5A5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error,
                            color: isDark
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Import Failed',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? const Color(0xFFFCA5A5)
                                            : const Color(0xFFB91C1C),
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  errorMessage,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? const Color(
                                                0xFFFCA5A5,
                                              ).withOpacity(0.8)
                                            : const Color(
                                                0xFFDC2626,
                                              ).withOpacity(0.9),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Google Sheet Link',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.warning,
                          color: isDark
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Make sure your sheet is set to 'Anyone with the link can view'.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          _viewModel.importFromUrl(_controller.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Retry Import',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: open how-to format help
                      },
                      icon: const Icon(Icons.help_outline),
                      label: const Text('How to format your sheet'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color primaryColor;

  const _SuccessStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A232E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3B4554) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDark
                    ? const Color(0xFF93A2B7)
                    : const Color(0xFF637588),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? const Color(0xFF93A2B7)
                      : const Color(0xFF637588),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: title == 'Cards Added'
                  ? primaryColor
                  : isDark
                  ? Colors.white
                  : const Color(0xFF111418),
            ),
          ),
        ],
      ),
    );
  }
}
