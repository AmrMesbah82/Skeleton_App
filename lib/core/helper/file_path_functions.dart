import 'package:demo_app/core/constants/files_extensions.dart';

class FilePathFunctions {
  static bool isImage(String filePath) {
    for (var extension in FilesExtensions.imageExtensions) {
      if (filePath.contains(extension)) {
        return true;
      }
    }
    return false;
  }

 static String getFileNameFromPath(String path) {
    return path.split('/').last;

  }
}
