import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/validators.dart';

/// Client for fetching CSV content from Google Sheets URLs
///
/// Handles HTTP GET requests with timeout and error wrapping in Result type.
/// Does not parse CSV content or perform business logic.
class SheetCsvClient {
  final http.Client _client;
  final Duration _timeout;

  /// Creates a [SheetCsvClient] with the given HTTP client
  ///
  /// [timeout] defaults to 30 seconds if not specified
  SheetCsvClient(
    this._client, {
    Duration? timeout,
  }) : _timeout = timeout ?? const Duration(seconds: 30);

  /// Fetches CSV content from the given URL
  ///
  /// Returns [Success] with CSV content as String on success,
  /// [Failure] with error message on failure (non-200 status, timeout, network errors).
  Future<Result<String>> fetchCsv(String url) async {
    if (url.trim().isEmpty) {
      return const Failure('URL cannot be empty');
    }

    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return Failure('Invalid URL format: $e');
    }

    try {
      final response = await _client
          .get(uri)
          .timeout(_timeout, onTimeout: () {
        throw TimeoutException('Request timed out after ${_timeout.inSeconds} seconds');
      });

      if (response.statusCode == 200) {
        return Success(response.body);
      } else {
        return Failure(
          'HTTP ${response.statusCode}: Failed to fetch CSV content',
        );
      }
    } on TimeoutException catch (e) {
      return Failure(e.toString());
    } on http.ClientException catch (e) {
      return Failure('Network error: ${e.message}');
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }
}

String buildCsvUrl({required String spreadsheetId, required String gid}) {
  return 'https://docs.google.com/spreadsheets/d/'
      '$spreadsheetId/export?format=csv&gid=$gid';
}
