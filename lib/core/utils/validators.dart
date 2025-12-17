/// Result type for operations that can succeed or fail
sealed class Result<T> {
  const Result();
}

/// Success result containing a value
final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

/// Failure result containing an error message
final class Failure<T> extends Result<T> {
  final String error;

  const Failure(this.error);
}

/// Data extracted from a valid Google Sheet URL
class SheetUrlData {
  final String spreadsheetId;
  final String gid;

  const SheetUrlData({
    required this.spreadsheetId,
    required this.gid,
  });
}

/// Validates a Google Sheet URL and extracts spreadsheetId and gid
///
/// Supports two URL formats:
/// 1. Regular edit URL: https://docs.google.com/spreadsheets/d/{spreadsheetId}/edit#gid={gid}
/// 2. CSV export URL: https://docs.google.com/spreadsheets/d/{spreadsheetId}/export?format=csv&gid={gid}
///
/// Returns [Success] with [SheetUrlData] if URL is valid, [Failure] with error message otherwise.
Result<SheetUrlData> validateSheetUrl(String url) {
  if (url.trim().isEmpty) {
    return const Failure('URL cannot be empty');
  }

  try {
    final uri = Uri.parse(url);

    // Validate domain
    if (uri.host != 'docs.google.com' && uri.host != 'www.docs.google.com') {
      return const Failure('URL must be from docs.google.com');
    }

    // Validate path contains /spreadsheets/d/
    final pathParts = uri.pathSegments;
    final spreadsheetIndex = pathParts.indexOf('d');
    if (spreadsheetIndex == -1 || spreadsheetIndex >= pathParts.length - 1) {
      return const Failure('URL must contain spreadsheet ID in path: /spreadsheets/d/{id}');
    }

    final spreadsheetId = pathParts[spreadsheetIndex + 1];
    if (spreadsheetId.isEmpty) {
      return const Failure('Spreadsheet ID cannot be empty');
    }

    // Extract gid from fragment (#gid=) or query parameter (?gid=)
    String? gid;

    // Try fragment first (for edit URLs: #gid=123)
    if (uri.fragment.isNotEmpty) {
      final fragmentParts = uri.fragment.split('&');
      for (final part in fragmentParts) {
        if (part.startsWith('gid=')) {
          gid = part.substring(4);
          break;
        }
      }
    }

    // Try query parameters (for export URLs: ?format=csv&gid=123)
    if (gid == null || gid.isEmpty) {
      gid = uri.queryParameters['gid'];
    }

    if (gid == null || gid.isEmpty) {
      return const Failure('URL must contain gid parameter (#gid= or ?gid=)');
    }

    return Success(SheetUrlData(
      spreadsheetId: spreadsheetId,
      gid: gid,
    ));
  } on FormatException catch (e) {
    return Failure('Invalid URL format: ${e.message}');
  } catch (e) {
    return Failure('Failed to parse URL: $e');
  }
}
