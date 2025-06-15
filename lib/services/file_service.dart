import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  final String fileName;

  FileService({this.fileName = 'emails.txt'});

  /// Get file path
  Future<String> get _filePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName';
  }

  /// Save full name and email
  Future<void> saveEntry(String fullName, String email) async {
    final file = File(await _filePath);
    final line = '$fullName <$email>\n';
    await file.writeAsString(line, mode: FileMode.append);
  }

  /// Read saved entries
  Future<List<String>> readEntries() async {
    final file = File(await _filePath);
    if (!await file.exists()) return [];
    return await file.readAsLines();
  }

  /// Optional: Clear file
  Future<void> clearEntries() async {
    final file = File(await _filePath);
    if (await file.exists()) {
      await file.writeAsString('');
    }
  }
}
