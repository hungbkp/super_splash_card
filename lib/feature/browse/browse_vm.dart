import 'package:flutter/foundation.dart';

import '../../core/utils/validators.dart';
import '../../data/model/flashcard.dart';
import '../../data/repository/flashcard_repository.dart';
import 'browse_state.dart';

/// ViewModel for browsing imported flashcards.
///
/// Reads data from [FlashCardRepository]'s in-memory cache only.
class BrowseViewModel extends ChangeNotifier {
  final FlashCardRepository _repository;

  BrowseState _state = const BrowseIdle();

  BrowseViewModel(this._repository);

  BrowseState get state => _state;

  bool get isLoading => _state is BrowseLoading;
  bool get isLoaded => _state is BrowseLoaded;
  bool get isEmpty => _state is BrowseEmpty;
  bool get isError => _state is BrowseError;

  Future<void> load() async {
    _setState(const BrowseLoading());

    final result = _repository.getLastImportedFlashCards();

    if (result is Failure<List<FlashCard>>) {
      _setState(BrowseError(result.error));
      return;
    }

    final cards = (result as Success<List<FlashCard>>).value;

    if (cards.isEmpty) {
      _setState(const BrowseEmpty());
    } else {
      _setState(BrowseLoaded(cards));
    }
  }

  void _setState(BrowseState newState) {
    _state = newState;
    notifyListeners();
  }
}


