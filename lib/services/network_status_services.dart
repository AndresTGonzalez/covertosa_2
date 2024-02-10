import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkStatusServices {
  Future<bool> getNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      try {
        final response = await http.get(Uri.parse("https://www.google.com"));
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }
}
