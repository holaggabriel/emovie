import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Método para verificar si hay conexión de red y si realmente hay acceso a Internet
  Future<bool> isConnectedToInternet() async {
    List<ConnectivityResult> connectivityResults =
        await _connectivity.checkConnectivity();
    // Verifica si al menos uno de los resultados no es 'none'
    if (connectivityResults
        .any((result) => result != ConnectivityResult.none)) {
      return true;
    }
    return false;
  }

}
