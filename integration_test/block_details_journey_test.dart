// User Journey from userJorney.mmd:
// flowchart LR
//   n1@{ shape: "circle", label: "Start" }
//   n2["auth"]
//   n1 --- n2
//   n2 --- n3["MainPage"]
//   n3 --- n4["BlockPage"]
//   n3 --- n5@{ shape: "diam", label: "Meeting<br>Interact?" }
//   n5 --- n6["UserMeetingsPage"]
//   n5 --- n7["MeetingModal"]
//   n6 --- n7
//   n3 --- n8@{ shape: "diam", label: "Block<br>Interact?" }
//   n8 --- n9["JoinBlockModal"]
//   n8 --- n10["CreateBlockPage"]
//   n9 --- n4
//   n10 --- n4
//   n4 --- n11@{ shape: "diam", label: "Create<br>Meeting?" }
//   n11 --- n12["CreateMeetingPage"]
//   n12 --- n4
//   n4 --- n13@{ shape: "diam", label: "Edit<br>Block?" }
//   n13 --- n14["EditBlockPage"]
//   n7 --- n15@{ shape: "diam", label: "Confirm or Deny<br>Presence?" }
//   n15 --- n16["Presence Confirmed"]
//   n15 --- n17["Presence Denied"]
//
// This test covers the journey: MainPage → BlockPage (via block selection) → AddMemberScreen (via FAB)

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Block Details and Add Member Journey', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('HomeScreen displays with carousel of blocks', () async {
      // Wait for the HomeScreen to load with the "Meus blocos" text
      await driver.waitFor(find.text('Meus blocos'));
      await driver.waitFor(find.text('Entrar em Bloco'));
      await driver.waitFor(find.text('Criar Bloco'));
      await driver.waitFor(find.text('Meus Encontros'));
    });

    test('Can navigate from HomeScreen to BlockDetailsScreen by tapping a block card', () async {
      // Tap on the "fulano_block" card in the carousel
      await driver.tap(find.text('fulano_block'));

      // Wait for BlockDetailsScreen to load
      await driver.waitFor(find.text('Detalhes do Bloco'));
      await driver.waitFor(find.text('fulano_block'));
      await driver.waitFor(find.text('Código de convite:'));
      await driver.waitFor(find.text('Membros'));
    });

    test('Can navigate from BlockDetailsScreen to AddMemberScreen via FAB', () async {
      // First ensure we're on BlockDetailsScreen
      await driver.waitFor(find.text('Detalhes do Bloco'));

      // Tap the FloatingActionButton to navigate to AddMemberScreen
      await driver.tap(find.byType('FloatingActionButton'));

      // Wait for AddMemberScreen to load
      await driver.waitFor(find.text('Adicionar Membro'));
      await driver.waitFor(find.byType('TextField'));
    });

    test('Can navigate back from AddMemberScreen to BlockDetailsScreen', () async {
      // Ensure we're on AddMemberScreen
      await driver.waitFor(find.text('Adicionar Membro'));

      // Use the page back finder to navigate back
      await driver.tap(find.pageBack());

      // Wait to return to BlockDetailsScreen
      await driver.waitFor(find.text('Detalhes do Bloco'));
    });
  });
}