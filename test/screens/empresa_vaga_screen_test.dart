// test/screens/empresa_vaga_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_control_app/screens/empresa_vaga_screen.dart';

import 'empresa_vaga_screen_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockEmpresas;
  late MockCollectionReference<Map<String, dynamic>> mockVagas;
  late MockCollectionReference<Map<String, dynamic>> mockAssociacoes;
  late MockQuerySnapshot<Map<String, dynamic>> mockSnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDoc;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockEmpresas = MockCollectionReference<Map<String, dynamic>>();
    mockVagas = MockCollectionReference<Map<String, dynamic>>();
    mockAssociacoes = MockCollectionReference<Map<String, dynamic>>();
    mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('empresas')).thenReturn(mockEmpresas);
    when(mockFirestore.collection('vagas')).thenReturn(mockVagas);
    when(mockFirestore.collection('associacoes')).thenReturn(mockAssociacoes);

    when(mockEmpresas.get()).thenAnswer((_) async => mockSnapshot);
    when(mockVagas.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.docs).thenReturn([mockDoc]);
    when(mockDoc.id).thenReturn('Empresa Teste');
    when(mockDoc.data()).thenReturn({'nome': 'Empresa Teste'});
  });

  testWidgets('Valida preenchimento obrigatório', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: EmpresaVagaScreen(firestore: mockFirestore),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar Associação'));
    await tester.pump();

    expect(find.text('Preencha todos os campos.'), findsOneWidget);
  });

  testWidgets('Navega via menu popup', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => EmpresaVagaScreen(firestore: mockFirestore),
        '/vaga': (_) => const Scaffold(body: Text('Tela de Vaga')),
      },
    ));

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cadastrar Vaga'));
    await tester.pumpAndSettle();

    expect(find.text('Tela de Vaga'), findsOneWidget);
  });
}
