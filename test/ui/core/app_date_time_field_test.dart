// Regression lock-in for the AppDateTimeField widget (M1).
//
// The field replaced two hand-rolled read-only pickers that allocated a
// TextEditingController inside build() and never disposed it. These tests
// pin the three things that matter:
// - the field renders its label and value,
// - a tap invokes the picker's callback,
// - the error text is painted below the field.

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_date_time_field.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

/// The Portuguese catalog, read straight from the ARB-generated localizations.
///
/// The copy these tests assert on moved into the catalog during the ARB/i18n
/// migration, so the expectations are built from the same source the widgets
/// read from.
final AppLocalizations _pt = lookupAppLocalizations(const Locale("pt"));

/// The app shell used by every harness below.
///
/// Since the ARB/i18n migration the core widgets read their copy through
/// `AppLocalizations.of(context)!`, so a bare `MaterialApp` crashes the build
/// with a null-check error. The delegates and the explicit `pt` locale keep
/// the Portuguese copy the assertions below expect.
Widget _app({required Widget home}) => MaterialApp(
  theme: AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

void main() {
  group("M1 — AppDateTimeField", () {
    testWidgets("M1: the field renders the label and the current value", (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: "25/12/2026");
      addTearDown(controller.dispose);

      // Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppDateTimeField(
              label: _pt.meetingsDateLabel,
              controller: controller,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(_pt.meetingsDateLabel), findsOneWidget);
      expect(find.text("25/12/2026"), findsOneWidget);
      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets("M1: a tap invokes the picker callback", (tester) async {
      // Arrange
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var tapped = false;

      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppDateTimeField(
              label: _pt.meetingsDateLabel,
              controller: controller,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(
        find.byKey(Key("app_date_time_field_${_pt.meetingsDateLabel}")),
      );
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets("M1: the error text is painted below the field", (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      // Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppDateTimeField(
              label: _pt.meetingsDateLabel,
              controller: controller,
              errorText: _pt.meetingsSelectDate,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(_pt.meetingsSelectDate), findsOneWidget);
      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.errorText, _pt.meetingsSelectDate);
    });

    testWidgets("M1: the field announces itself as a button", (tester) async {
      // Arrange
      final handle = tester.ensureSemantics();
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      // Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppDateTimeField(
              label: _pt.meetingsDateLabel,
              semanticsLabel: _pt.meetingsSelectDateSemantics,
              controller: controller,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.bySemanticsLabel(_pt.meetingsSelectDateSemantics),
        findsOneWidget,
      );
      final node = tester.getSemantics(
        find.byKey(Key("app_date_time_field_${_pt.meetingsDateLabel}")),
      );
      expect(node.getSemanticsData().flagsCollection.isButton, isTrue);

      handle.dispose();
    });
  });
}
