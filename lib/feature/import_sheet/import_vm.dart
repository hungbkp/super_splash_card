import 'package:flutter/foundation.dart';
import '../../../core/utils/validators.dart';
import '../../../data/model/flashcard.dart';
import 'import_state.dart';
import 'domain/usecase/import_flashcards_usecase.dart';

/// ViewModel for the import sheet feature
///
/// Manages state and coordinates with ImportFlashCardsUseCase to import
/// flashcards from Google Sheets. Uses ChangeNotifier for state updates.
class ImportSheetViewModel extends ChangeNotifier {
  final ImportFlashCardsUseCase _useCase;
  ImportSheetState _state = const ImportSheetIdle();

  /// Creates an [ImportSheetViewModel] with the given use case
  ImportSheetViewModel(this._useCase);

  /// Current state of the import operation
  ImportSheetState get state => _state;

  /// Whether the import operation is currently in progress
  bool get isLoading => _state is ImportSheetLoading;

  /// Whether the import operation completed successfully
  bool get isSuccess => _state is ImportSheetSuccess;

  /// Whether the import operation failed
  bool get isError => _state is ImportSheetError;

  /// Whether the view model is in idle state
  bool get isIdle => _state is ImportSheetIdle;

  /// Imports flashcards from the given Google Sheet URL
  ///
  /// Updates state to loading, then calls the use case. On completion,
  /// updates state to either success (with flashcards) or error (with message).
  Future<void> importFromUrl(String url) async {
    if (url.trim().isEmpty) {
      _updateState(const ImportSheetError('URL cannot be empty'));
      return;
    }

    _updateState(const ImportSheetLoading());

    final result = await _useCase.execute(url);

    if (result is Success<List<FlashCard>>) {
      _updateState(ImportSheetSuccess(result.value));
    } else if (result is Failure<List<FlashCard>>) {
      _updateState(ImportSheetError(result.error));
    }
  }

  /// Resets the state to idle
  void reset() {
    _updateState(const ImportSheetIdle());
  }

  void _updateState(ImportSheetState newState) {
    _state = newState;
    notifyListeners();
  }
}
