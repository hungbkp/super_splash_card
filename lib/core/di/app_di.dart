import 'package:http/http.dart' as http;

import '../network/sheet_client.dart';
import '../../data/repository/flashcard_repository.dart';

/// Simple application-level dependency wiring.
///
/// This keeps shared instances in one place so features can
/// reuse the same repository and client without introducing
/// a full DI framework.
final http.Client httpClient = http.Client();
final SheetCsvClient sheetCsvClient = SheetCsvClient(httpClient);
final FlashCardRepository flashCardRepository =
    FlashCardRepository(sheetCsvClient);


