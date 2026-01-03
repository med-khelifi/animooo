import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionUtils {
  /// Singleton
  InternetConnectionUtils._internal();
  static final InternetConnectionUtils instance =
  InternetConnectionUtils._internal();

  final InternetConnectionChecker _checker =
      InternetConnectionChecker.instance;

  StreamSubscription<InternetConnectionStatus>? _subscription;

  Future<bool> hasInternet() async {
    return await _checker.hasConnection;
  }

  void listen({
    required void Function() onConnected,
    required void Function() onDisconnected,
  }) {
    _subscription = _checker.onStatusChange.listen(
          (status) {
        if (status == InternetConnectionStatus.connected) {
          onConnected();
        } else {
          onDisconnected();
        }
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _checker.dispose();
  }
}
