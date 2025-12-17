import '../../core/network/sheet_client.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/csv_parser.dart';
import '../model/flashcard.dart';

/// Repository for managing flashcard data operations
///
/// Coordinates URL validation, CSV fetching, and parsing to provide
/// high-level flashcard import functionality.
class FlashCardRepository {
  final SheetCsvClient _csvClient;

  /// Creates a [FlashCardRepository] with the given CSV client
  FlashCardRepository(this._csvClient);

  /// Imports flashcards from a Google Sheet URL
  ///
  /// Validates the URL, fetches CSV content, and parses it into FlashCard objects.
  /// Returns [Success] with list of flashcards on success, [Failure] with error message otherwise.
  Future<Result<List<FlashCard>>> importFromSheetUrl(String url) async {
    // Step 1: Validate URL and extract spreadsheet ID and gid
    final urlValidation = validateSheetUrl(url);
    if (urlValidation is Failure<SheetUrlData>) {
      return Failure(urlValidation.error);
    }

    final urlData = (urlValidation as Success<SheetUrlData>).value;

    // Step 2: Build CSV export URL
    final csvUrl = buildCsvUrl(
      spreadsheetId: urlData.spreadsheetId,
      gid: urlData.gid,
    );

    // Step 3: Fetch CSV content
    final csvResult = await _csvClient.fetchCsv(csvUrl);
    if (csvResult is Failure<String>) {
      return Failure(csvResult.error);
    }

    final csvContent = (csvResult as Success<String>).value;

    // Step 4: Parse CSV to flashcards
    final parseResult = parseCsvToFlashCards(csvContent);

    // Return success with parsed flashcards
    // Note: skipped rows are tracked in parseResult but not exposed in the Result
    // This follows the constraint that we only return Result<List<FlashCard>>
    return Success(parseResult.flashcards);
  }
}
