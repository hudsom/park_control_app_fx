import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VagaScreen extends StatefulWidget {
  final FirebaseFirestore? firestore;

  const VagaScreen({super.key, this.firestore});

  @override
  _VagaScreenState createState() => _VagaScreenState();
}

class _VagaScreenState extends State<VagaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroVagaController = TextEditingController();

  Future<void> _salvarVaga() async {
    if (_formKey.currentState!.validate()) {
      final numeroVaga = _numeroVagaController.text;
      try {
        final firestore = widget.firestore ?? FirebaseFirestore.instance;
        await firestore.collection('vagas').add({
          'numero': numeroVaga,
          'criadoEm': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vaga "$numeroVaga" cadastrada com sucesso!')),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: \$e')),
        );
      }
    }
  }

  void _navegarPara(String rota) {
    Navigator.pushNamed(context, rota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Vaga'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _navegarPara,
            itemBuilder: (context) => [
              PopupMenuItem(value: AppRoutes.home, child: Text('Início')),
              PopupMenuItem(value: AppRoutes.empresa, child: Text('Cadastrar Empresa')),
              PopupMenuItem(value: AppRoutes.associacao, child: Text('Associar Vaga')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numeroVagaController,
                decoration: InputDecoration(labelText: 'Número da Vaga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número da vaga';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarVaga,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
