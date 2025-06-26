import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_control_app/screens/vaga_screen.dart';

import 'vaga_screen_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockVagaCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockVagaCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('vagas')).thenReturn(mockVagaCollection);
    when(mockVagaCollection.add(any)).thenAnswer((_) async => mockDocRef);
  });

  testWidgets('Valida campo obrigatório da vaga', (tester) async {
    await tester.pumpWidget(MaterialApp(home: VagaScreen(firestore: mockFirestore)));
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Informe o número da vaga'), findsOneWidget);
  });

  testWidgets('Salva vaga corretamente', (tester) async {
    await tester.pumpWidget(MaterialApp(home: VagaScreen(firestore: mockFirestore)));

    await tester.enterText(find.byType(TextFormField), '101');
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SnackBar), findsOneWidget);
    final field = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(field.controller!.text, isEmpty);
  });
}
