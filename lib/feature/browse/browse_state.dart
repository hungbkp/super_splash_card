import '../../data/model/flashcard.dart';

sealed class BrowseState {
  const BrowseState();
}

class BrowseIdle extends BrowseState {
  const BrowseIdle();
}

class BrowseLoading extends BrowseState {
  const BrowseLoading();
}

class BrowseLoaded extends BrowseState {
  final List<FlashCard> flashcards;

  const BrowseLoaded(this.flashcards);
}

class BrowseEmpty extends BrowseState {
  const BrowseEmpty();
}

class BrowseError extends BrowseState {
  final String message;

  const BrowseError(this.message);
}


