import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FileSystemService {
  Future<void> saveFile(String fileURL, String? fileName) async {
    try {
      fileName = fileName ?? 'Recibo.pdf';

      final response = await http.get(Uri.parse(fileURL));

      String? directoryPath = await _getDownloadDirectory();

      if (directoryPath == null) return;

      final filePath = "$directoryPath/$fileName.pdf";
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(filePath);
    } finally {}
  }

  Future<String?> _getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }

    return directory?.path;
  }
}
