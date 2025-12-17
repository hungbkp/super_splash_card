class FlashCard {
  /// Raw ID from Google Sheets (may be empty)
  final String? id;

  /// Required fields
  final String word;
  final String meaning;

  /// Optional fields
  final String? definition;
  final String? example;
  final String? ipa;
  final String? note;
  final String? deck;

  /// Raw updated_at value from Google Sheets (unparsed)
  final String? updatedAt;

  FlashCard({
    this.id,
    required this.word,
    required this.meaning,
    this.definition,
    this.example,
    this.ipa,
    this.note,
    this.deck,
    this.updatedAt,
  })  : assert(word.trim().isNotEmpty, 'word cannot be empty'),
        assert(meaning.trim().isNotEmpty, 'meaning cannot be empty');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          word == other.word &&
          meaning == other.meaning &&
          definition == other.definition &&
          example == other.example &&
          ipa == other.ipa &&
          note == other.note &&
          deck == other.deck &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      word.hashCode ^
      meaning.hashCode ^
      definition.hashCode ^
      example.hashCode ^
      ipa.hashCode ^
      note.hashCode ^
      deck.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'FlashCard(id: $id, word: $word, meaning: $meaning, definition: $definition, '
      'example: $example, ipa: $ipa, note: $note, deck: $deck, updatedAt: $updatedAt)';
}
