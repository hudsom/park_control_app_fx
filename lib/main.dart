import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'services/auth_provider.dart';
import 'packages/auth_package/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Substitui FirebaseService.initialize()
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(
        authService: AuthService(
          apiKey: 'AIzaSyDvl6e8aMALTsiGBD9dJ6XrvO0rqMjIBy8',
        ),
      ),
      child: MaterialApp(
        title: 'Vagas Estacionamento',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
