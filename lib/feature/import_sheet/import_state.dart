import '../../../data/model/flashcard.dart';

/// Base class for import sheet states
sealed class ImportSheetState {
  const ImportSheetState();
}

/// Initial state when no import operation has been started
final class ImportSheetIdle extends ImportSheetState {
  const ImportSheetIdle();
}

/// State when import operation is in progress
final class ImportSheetLoading extends ImportSheetState {
  const ImportSheetLoading();
}

/// State when import operation completed successfully
final class ImportSheetSuccess extends ImportSheetState {
  final List<FlashCard> flashcards;

  const ImportSheetSuccess(this.flashcards);
}

/// State when import operation failed
final class ImportSheetError extends ImportSheetState {
  final String errorMessage;

  const ImportSheetError(this.errorMessage);
}
