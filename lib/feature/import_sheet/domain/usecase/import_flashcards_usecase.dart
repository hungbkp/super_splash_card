import '../../../../data/model/flashcard.dart';
import '../../../../data/repository/flashcard_repository.dart';
import '../../../../core/utils/validators.dart';

/// Use case for importing flashcards from a Google Sheet URL
///
/// Coordinates the import flow: validates URL, builds CSV export URL,
/// fetches CSV content, parses it, and returns flashcards.
///
/// This use case serves as the business logic entry point for the import feature.
class ImportFlashCardsUseCase {
  final FlashCardRepository _repository;

  /// Creates an [ImportFlashCardsUseCase] with the given repository
  ImportFlashCardsUseCase(this._repository);

  /// Imports flashcards from a Google Sheet URL
  ///
  /// Executes the following flow:
  /// 1. Validates Google Sheet URL
  /// 2. Builds CSV export URL
  /// 3. Fetches CSV content
  /// 4. Parses CSV
  /// 5. Returns FlashCards
  ///
  /// Returns [Success] with list of flashcards on success,
  /// [Failure] with error message otherwise.
  Future<Result<List<FlashCard>>> execute(String url) async {
    return await _repository.importFromSheetUrl(url);
  }
}
