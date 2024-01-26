import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusProvider extends ChangeNotifier {
  StreamController<NetworkStatusProvider> networkStatusController =
      StreamController<NetworkStatusProvider>();

  bool _isOnline = true;

  bool get isOnline => _isOnline;

  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  NetworkStatusProvider() {
    Connectivity().onConnectivityChanged.listen((status) {
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatusProvider _getNetworkStatus(ConnectivityResult status) {
    switch (status) {
      case ConnectivityResult.none:
        isOnline = false;
        break;
      case ConnectivityResult.mobile:
        isOnline = true;
        break;
      case ConnectivityResult.wifi:
        isOnline = true;
        break;
      default:
        isOnline = false;
        break;
    }
    return this;
  }
}
