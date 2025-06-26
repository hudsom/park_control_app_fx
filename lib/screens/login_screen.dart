import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  final AuthProvider? injectedAuth;

  const LoginScreen({Key? key, this.injectedAuth}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = widget.injectedAuth ?? Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('emailField'),
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              key: const Key('passwordField'),
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            auth.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              key: const Key('loginButton'),
              onPressed: () async {
                await auth.login(
                  _emailController.text,
                  _passwordController.text,
                );
                if (auth.isAuthenticated) {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              },
              child: Text('Entrar'),
            ),
            if (auth.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  auth.error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
