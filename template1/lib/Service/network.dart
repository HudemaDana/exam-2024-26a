import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();
  final _networkConnectivity = Connectivity();
  final _controller = StreamController<Map<ConnectivityResult, bool>>.broadcast();

  static NetworkConnectivity get instance => _instance;
  Stream<Map<ConnectivityResult, bool>> get myStream => _controller.stream.asBroadcastStream();

  // 1. Initialize connectivity and listen for changes
  void initialize() {
    _checkStatus();
    _networkConnectivity.onConnectivityChanged.listen((result) {
      print(result);
      _checkStatus();
    });
  }

  // 2. Check online status based on connectivity result
  void _checkStatus() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({await _networkConnectivity.checkConnectivity(): isOnline});
  }

  // 3. Dispose of the stream controller
  void disposeStream() => _controller.close();
}
