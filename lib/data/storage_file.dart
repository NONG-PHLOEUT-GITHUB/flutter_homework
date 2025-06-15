import 'package:path_provider/path_provider.dart';

class StorageFile {
  Future<String> _getCurrenPath () async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getFilePath(fileName) async {
    final filePath = await _getCurrenPath();
    return filePath;
  }
}

