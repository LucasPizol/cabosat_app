import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FileSystemService {
  Future<void> saveFile(String fileURL, String? fileName) async {
    try {
      var file = File('');

      fileName = fileName ?? 'Recibo.pdf';

      // Platform.isIOS comes from dart:io
      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        file = File('${dir.path}/$fileName.pdf');
      }

      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }
        if (status.isGranted) {
          const downloadsFolderPath = '/storage/emulated/0/Download/';
          Directory dir = Directory(downloadsFolderPath);
          file = File('${dir.path}/$fileName.pdf');
        }
      }

      if (file.existsSync()) {
        await OpenFile.open(file.path);
        return;
      }

      final byteData = await http.get(Uri.parse(fileURL));
      final bytes = byteData.bodyBytes;

      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } finally {}
  }
}
