import 'package:flutter/foundation.dart';
// Metodo que nos ayuda a imprimir mensajes en la consola solo en modo debug
void printInDebugMode(String message) {
  if (kDebugMode) {
    print(message);
  }
}
