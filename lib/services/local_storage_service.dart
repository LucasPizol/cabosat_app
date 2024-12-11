import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<SharedPreferences> localStorage() async {
    return await SharedPreferences.getInstance();
  }

  add(
    String table,
    String data,
  ) async {
    (await localStorage()).setString(table, data);
  }

  get(String table) async {
    return (await localStorage()).getString(table);
  }

  remove(String table) async {
    (await localStorage()).remove(table);
  }

  reload() async {
    (await localStorage()).reload();
  }
}
