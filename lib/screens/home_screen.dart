import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';
import '../services/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vagas por Empresa'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo! Aqui você verá as vagas por empresa.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.empresa),
              child: Text('Cadastrar Empresa'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.vaga),
              child: Text('Cadastrar Vaga'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.associacao),
              child: Text('Associar Vaga à Empresa'),
            ),
          ],
        ),
      ),
    );
  }
}
