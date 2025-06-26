import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_control_app/screens/empresa_screen.dart';
import 'package:park_control_app/routes/app_routes.dart';

import 'empresa_screen_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockEmpresaCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockEmpresaCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('empresas')).thenReturn(mockEmpresaCollection);
    when(mockEmpresaCollection.add(any)).thenAnswer((_) async => mockDocRef);
  });

  testWidgets('Exibe erro ao tentar salvar empresa sem nome', (tester) async {
    await tester.pumpWidget(MaterialApp(home: EmpresaScreen(firestore: mockFirestore)));
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Informe o nome da empresa'), findsOneWidget);
  });

  testWidgets('Salva empresa e limpa o campo', (tester) async {
    await tester.pumpWidget(MaterialApp(home: EmpresaScreen(firestore: mockFirestore)));

    await tester.enterText(find.byType(TextFormField), 'Empresa XYZ');
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SnackBar), findsOneWidget);
    final field = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('Menu popup navega corretamente', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => EmpresaScreen(firestore: mockFirestore),
        AppRoutes.vaga: (_) => Placeholder(),
      },
    ));

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cadastrar Vaga'));
    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
  });
}
