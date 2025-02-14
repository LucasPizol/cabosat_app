import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }
}
