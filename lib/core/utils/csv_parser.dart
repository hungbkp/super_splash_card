import '../../data/model/flashcard.dart';

/// Result of parsing CSV content
class CsvParseResult {
  final List<FlashCard> flashcards;
  final int skippedRows;

  const CsvParseResult({
    required this.flashcards,
    required this.skippedRows,
  });
}

/// Parses CSV content into FlashCard objects
///
/// Supports dynamic headers with flexible column name matching.
/// Malformed rows are skipped and counted.
///
/// Returns [CsvParseResult] containing parsed flashcards and count of skipped rows.
CsvParseResult parseCsvToFlashCards(String csvContent) {
  if (csvContent.trim().isEmpty) {
    return const CsvParseResult(flashcards: [], skippedRows: 0);
  }

  final rows = _parseCsvRows(csvContent);
  if (rows.isEmpty) {
    return const CsvParseResult(flashcards: [], skippedRows: 0);
  }

  final headers = rows[0];
  if (headers.isEmpty) {
    return const CsvParseResult(flashcards: [], skippedRows: 0);
  }

  final columnMap = _buildColumnMap(headers);
  
  // Validate required columns exist
  if (columnMap['word'] == null || columnMap['meaning'] == null) {
    return CsvParseResult(
      flashcards: [],
      skippedRows: rows.length - 1, // All data rows skipped
    );
  }

  final flashcards = <FlashCard>[];
  int skippedRows = 0;

  // Process data rows (skip header row)
  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    
    // Skip empty rows
    if (row.isEmpty || row.every((cell) => cell.trim().isEmpty)) {
      skippedRows++;
      continue;
    }

    try {
      final flashcard = _parseRowToFlashCard(row, columnMap, headers.length);
      flashcards.add(flashcard);
    } catch (e) {
      // Skip malformed rows, but track the count
      skippedRows++;
    }
  }

  return CsvParseResult(
    flashcards: flashcards,
    skippedRows: skippedRows,
  );
}

/// Parses CSV string into rows of cells
///
/// Handles quoted fields, escaped quotes, and commas within quotes.
List<List<String>> _parseCsvRows(String csvContent) {
  final rows = <List<String>>[];
  final currentRow = <String>[];
  String currentCell = '';
  bool inQuotes = false;
  bool escapedQuote = false;

  for (int i = 0; i < csvContent.length; i++) {
    final char = csvContent[i];

    if (escapedQuote) {
      if (char == '"') {
        currentCell += '"';
        escapedQuote = false;
        continue;
      } else {
        escapedQuote = false;
      }
    }

    if (char == '"') {
      if (inQuotes && i + 1 < csvContent.length && csvContent[i + 1] == '"') {
        // Escaped quote within quoted field
        escapedQuote = true;
        continue;
      } else {
        // Toggle quote state
        inQuotes = !inQuotes;
        continue;
      }
    }

    if (!inQuotes) {
      if (char == ',') {
        // End of cell
        currentRow.add(currentCell);
        currentCell = '';
        continue;
      } else if (char == '\n') {
        // End of row (handles both \n and \r\n since \r is skipped before this)
        currentRow.add(currentCell);
        if (currentRow.isNotEmpty && currentRow.any((cell) => cell.isNotEmpty)) {
          rows.add(List.from(currentRow));
        }
        currentRow.clear();
        currentCell = '';
        continue;
      } else if (char == '\r') {
        // Handle \r: if next is \n, skip this \r (next iteration handles \n)
        // If next is not \n, treat as newline (Mac-style)
        if (i + 1 >= csvContent.length || csvContent[i + 1] != '\n') {
          // Standalone \r, treat as newline
          currentRow.add(currentCell);
          if (currentRow.isNotEmpty && currentRow.any((cell) => cell.isNotEmpty)) {
            rows.add(List.from(currentRow));
          }
          currentRow.clear();
          currentCell = '';
        }
        // If next is \n, skip this \r and let next iteration handle \n
        continue;
      }
    }

    currentCell += char;
  }

  // Add last cell and row if not empty
  if (currentCell.isNotEmpty || currentRow.isNotEmpty) {
    currentRow.add(currentCell);
    if (currentRow.isNotEmpty && currentRow.any((cell) => cell.isNotEmpty)) {
      rows.add(currentRow);
    }
  }

  return rows;
}

/// Builds a map from FlashCard field names to column indices
///
/// Supports flexible column name matching (case-insensitive, underscore variations).
Map<String, int> _buildColumnMap(List<String> headers) {
  final columnMap = <String, int>{};

  for (int i = 0; i < headers.length; i++) {
    final header = headers[i].trim().toLowerCase();

    // Normalize header (remove underscores, spaces)
    final normalized = header.replaceAll(RegExp(r'[_\s]'), '');

    // Map to FlashCard field names
    if (normalized == 'id') {
      columnMap['id'] = i;
    } else if (normalized == 'word') {
      columnMap['word'] = i;
    } else if (normalized == 'meaning') {
      columnMap['meaning'] = i;
    } else if (normalized == 'definition' || normalized == 'defination') {
      // Support both correct and common misspelling
      columnMap['definition'] = i;
    } else if (normalized == 'deck') {
      columnMap['deck'] = i;
    } else if (normalized == 'example') {
      columnMap['example'] = i;
    } else if (normalized == 'ipa') {
      columnMap['ipa'] = i;
    } else if (normalized == 'note') {
      columnMap['note'] = i;
    } else if (normalized == 'updatedat' || normalized == 'updated_at') {
      columnMap['updatedAt'] = i;
    }
  }

  return columnMap;
}

/// Parses a CSV row into a FlashCard object
///
/// Throws [FormatException] if required fields are missing or invalid.
FlashCard _parseRowToFlashCard(
  List<String> row,
  Map<String, int> columnMap,
  int expectedColumnCount,
) {
  // Ensure row has enough columns (pad with empty strings if needed)
  while (row.length < expectedColumnCount) {
    row.add('');
  }

  // Extract required fields
  final wordIndex = columnMap['word']!;
  final meaningIndex = columnMap['meaning']!;

  final word = _getCellValue(row, wordIndex).trim();
  final meaning = _getCellValue(row, meaningIndex).trim();

  // Validate required fields
  if (word.isEmpty) {
    throw FormatException('Word field is empty');
  }
  if (meaning.isEmpty) {
    throw FormatException('Meaning field is empty');
  }

  // Extract optional fields
  final id = _getCellValue(row, columnMap['id']).trim();
  final definition = _getCellValue(row, columnMap['definition']).trim();
  final example = _getCellValue(row, columnMap['example']).trim();
  final ipa = _getCellValue(row, columnMap['ipa']).trim();
  final note = _getCellValue(row, columnMap['note']).trim();
  final updatedAt = _getCellValue(row, columnMap['updatedAt']).trim();
  final deck = _getCellValue(row, columnMap['deck']).trim();

  return FlashCard(
    id: id.isEmpty ? null : id,
    word: word,
    meaning: meaning,
    definition: definition.isEmpty ? null : definition,
    example: example.isEmpty ? null : example,
    ipa: ipa.isEmpty ? null : ipa,
    note: note.isEmpty ? null : note,
    updatedAt: updatedAt.isEmpty ? null : updatedAt,
    deck: deck.isEmpty ? null : deck,
  );
}

/// Safely gets cell value from row by index
///
/// Returns empty string if index is null or out of bounds.
String _getCellValue(List<String> row, int? index) {
  if (index == null || index < 0 || index >= row.length) {
    return '';
  }
  return row[index];
}
