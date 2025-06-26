import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresaScreen extends StatefulWidget {
  final FirebaseFirestore firestore;

  EmpresaScreen({Key? key, FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance,
        super(key: key);

  @override
  _EmpresaScreenState createState() => _EmpresaScreenState();
}

class _EmpresaScreenState extends State<EmpresaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  Future<void> _salvarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      final nomeEmpresa = _nomeController.text;
      try {
        await widget.firestore.collection('empresas').add({
          'nome': nomeEmpresa,
          'criadoEm': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Empresa "$nomeEmpresa" cadastrada com sucesso!')),
        );
        _formKey.currentState!.reset();
        _nomeController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
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
        title: Text('Cadastrar Empresa'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _navegarPara,
            itemBuilder: (context) => [
              PopupMenuItem(value: AppRoutes.home, child: Text('Início')),
              PopupMenuItem(value: AppRoutes.vaga, child: Text('Cadastrar Vaga')),
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
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da empresa';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarEmpresa,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
