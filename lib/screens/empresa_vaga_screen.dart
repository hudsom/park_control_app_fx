import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresaVagaScreen extends StatefulWidget {
  final FirebaseFirestore firestore;

  EmpresaVagaScreen({Key? key, FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance,
        super(key: key);

  @override
  _EmpresaVagaScreenState createState() => _EmpresaVagaScreenState();
}

class _EmpresaVagaScreenState extends State<EmpresaVagaScreen> {
  String? _empresaSelecionada;
  String? _vagaSelecionada;
  DateTime? _data;
  TimeOfDay? _hora;

  Future<List<String>> _buscarEmpresas() async {
    final snapshot = await widget.firestore.collection('empresas').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> _buscarVagas() async {
    final snapshot = await widget.firestore.collection('vagas').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _hora = picked);
  }

  Future<void> _salvarAssociacao() async {
    if (_empresaSelecionada == null ||
        _vagaSelecionada == null ||
        _data == null ||
        _hora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    final dataHora = DateTime(
      _data!.year,
      _data!.month,
      _data!.day,
      _hora!.hour,
      _hora!.minute,
    );

    final fimDoDia = DateTime(
      _data!.year,
      _data!.month,
      _data!.day,
      23,
      59,
      59,
    );

    if (dataHora.isAfter(fimDoDia)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O horário não pode ultrapassar 23:59:59 do mesmo dia.')),
      );
      return;
    }

    await widget.firestore.collection('associacoes').add({
      'empresaId': _empresaSelecionada,
      'vagaId': _vagaSelecionada,
      'dataHora': Timestamp.fromDate(dataHora),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Associação salva com sucesso!')),
    );
  }

  void _irParaTela(String rota) {
    Navigator.pushNamed(context, rota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Associar Vaga à Empresa'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _irParaTela,
            itemBuilder: (context) => [
              PopupMenuItem(value: '/home', child: Text('Início')),
              PopupMenuItem(value: '/empresa', child: Text('Cadastrar Empresa')),
              PopupMenuItem(value: '/vaga', child: Text('Cadastrar Vaga')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _buscarEmpresas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButtonFormField<String>(
                  value: _empresaSelecionada,
                  hint: Text('Selecione a Empresa'),
                  items: snapshot.data!
                      .map((id) => DropdownMenuItem(value: id, child: Text(id)))
                      .toList(),
                  onChanged: (val) => setState(() => _empresaSelecionada = val),
                );
              },
            ),
            SizedBox(height: 10),
            FutureBuilder<List<String>>(
              future: _buscarVagas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButtonFormField<String>(
                  value: _vagaSelecionada,
                  hint: Text('Selecione a Vaga'),
                  items: snapshot.data!
                      .map((id) => DropdownMenuItem(value: id, child: Text(id)))
                      .toList(),
                  onChanged: (val) => setState(() => _vagaSelecionada = val),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selecionarData,
              child: Text(_data == null ? 'Selecionar Data' : _data.toString().split(' ')[0]),
            ),
            ElevatedButton(
              onPressed: _selecionarHora,
              child: Text(_hora == null ? 'Selecionar Hora' : _hora!.format(context)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarAssociacao,
              child: Text('Salvar Associação'),
            ),
          ],
        ),
      ),
    );
  }
}
