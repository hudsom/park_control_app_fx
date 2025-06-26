import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/empresa_screen.dart';
import '../screens/vaga_screen.dart';
import '../screens/empresa_vaga_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String empresa = '/empresa';
  static const String vaga = '/vaga';
  static const String associacao = '/associacao';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => LoginScreen(),
    home: (_) => HomeScreen(),
    empresa: (_) => EmpresaScreen(),
    vaga: (_) => VagaScreen(),
    associacao: (_) => EmpresaVagaScreen(),
  };
}
