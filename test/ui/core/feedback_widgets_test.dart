// Regression lock-in for the feedback widgets (H6, L5, L8).
//
// - H6 — the snackbar uses ONE neutral surface (`colorScheme.inverseSurface`)
//   for every severity; the severity is carried by the leading icon, not by a
//   tinted container that inverted lightness.
// - L5 — the floating snackbar keeps clear of the FAB.
// - L8 — `AppDialog` takes the button wording from the caller (no hardcoded
//   pt-BR defaults) and paints itself from the colorScheme.
//
// House style follows the existing tests in `test/`: `flutter_test` only, and
// Arrange / Act / Assert inside every test body.

import "dart:math" as math;

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

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
Widget _app({required Widget home, ThemeData? theme, Key? key}) => MaterialApp(
  key: key,
  theme: theme ?? AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

/// WCAG 2.x contrast ratio between [a] and [b] (1.0 – 21.0).
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Counter that gives every pumped app its own key, so a second pump really
/// rebuilds the tree instead of reusing the previous [ScaffoldMessenger]
/// (which would keep showing the FIRST snackbar).
int _pumpCounter = 0;

/// Shows a snackbar of the given [severity] and returns the shown SnackBar.
Future<SnackBar> _showSnackBar(
  WidgetTester tester,
  ThemeData theme,
  void Function(BuildContext context) show,
) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    _app(
      key: ValueKey("snack_app_${_pumpCounter++}"),
      theme: theme,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  show(capturedContext);
  await tester.pump();
  return tester.widget<SnackBar>(find.byType(SnackBar));
}

void main() {
  // =========================================================================
  // H6 — One neutral snackbar surface for every severity
  // =========================================================================
  group("H6 — the snackbar paints one neutral surface", () {
    testWidgets("H6: every severity uses inverseSurface as its background", (
      tester,
    ) async {
      // Arrange / Act
      final success = await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.success(context, message: _pt.blocksCreateSuccess);
      });
      final error = await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.error(context, message: _pt.meetingsCreateError);
      });
      final warning = await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.warning(context, message: _pt.validation);
      });
      final info = await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.info(context, message: _pt.notFound);
      });

      // Assert — one surface for all four severities.
      final surface = AppTheme.light().colorScheme.inverseSurface;
      expect(success.backgroundColor, surface);
      expect(error.backgroundColor, surface);
      expect(warning.backgroundColor, surface);
      expect(info.backgroundColor, surface);
    });

    testWidgets("H6: the severity is carried by the leading icon", (
      tester,
    ) async {
      // Arrange / Act — show each severity and collect its icon.
      final icons = <IconData, Color>{};
      for (final severity in ["success", "error", "warning", "info"]) {
        await _showSnackBar(tester, AppTheme.light(), (context) {
          if (severity == "success") {
            AppSnackbar.success(context, message: "ok");
          } else if (severity == "error") {
            AppSnackbar.error(context, message: "ok");
          } else if (severity == "warning") {
            AppSnackbar.warning(context, message: "ok");
          } else {
            AppSnackbar.info(context, message: "ok");
          }
        });
        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.byType(Icon),
          ),
        );
        icons[icon.icon!] = icon.color!;
      }

      // Assert — four distinct glyphs, so the severity is readable even
      // without colour.
      expect(icons.length, 4);

      // Assert — every severity icon clears 3:1 on BOTH neutral surfaces.
      // The surface flips lightness with the theme (near-black in light mode,
      // near-white in dark mode), so an ink that only works on one of them
      // would disappear in the other.
      final lightSurface = AppTheme.light().colorScheme.inverseSurface;
      final darkSurface = AppTheme.dark().colorScheme.inverseSurface;
      for (final entry in icons.entries) {
        for (final surface in [lightSurface, darkSurface]) {
          expect(
            _contrastRatio(entry.value, surface),
            greaterThanOrEqualTo(3.0),
            reason: "${entry.key} must stay readable on $surface",
          );
        }
      }
    });

    testWidgets("H6: the content ink is onInverseSurface in both modes", (
      tester,
    ) async {
      // Arrange / Act — light mode.
      await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.success(context, message: _pt.blocksCreateSuccess);
      });
      var text = tester.widget<Text>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(_pt.blocksCreateSuccess),
        ),
      );

      // Assert — the theme's inverse pair, in both brightnesses.
      var scheme = AppTheme.light().colorScheme;
      expect(text.style?.color, scheme.onInverseSurface);
      expect(
        _contrastRatio(text.style!.color!, scheme.inverseSurface),
        greaterThanOrEqualTo(4.5),
      );

      // Arrange / Act — dark mode (fresh pump so the whole tree rebuilds).
      await _showSnackBar(tester, AppTheme.dark(), (context) {
        AppSnackbar.success(context, message: _pt.blocksCreateSuccess);
      });
      text = tester.widget<Text>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(_pt.blocksCreateSuccess),
        ),
      );
      scheme = AppTheme.dark().colorScheme;
      expect(text.style?.color, scheme.onInverseSurface);
      expect(
        _contrastRatio(text.style!.color!, scheme.inverseSurface),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  // =========================================================================
  // L5 — The snackbar clears the FAB
  // =========================================================================
  group("L5 — the floating snackbar keeps clear of the FAB", () {
    testWidgets("L5: the bottom margin leaves room for the FAB", (
      tester,
    ) async {
      // Arrange / Act
      final snackBar = await _showSnackBar(tester, AppTheme.light(), (context) {
        AppSnackbar.success(context, message: _pt.blocksCreateSuccess);
      });

      // Assert — 88px of bottom clearance (56px FAB + 16px margin + 16px).
      final margin = snackBar.margin! as EdgeInsets;
      expect(margin.bottom, 88.0);
      expect(margin.left, 16.0);
      expect(margin.right, 16.0);
    });
  });

  // =========================================================================
  // L8 — AppDialog wording and colours
  // =========================================================================
  group(
    "L8 — the dialog owns no wording and paints itself from the scheme",
    () {
      testWidgets("L8: the dialog shows the labels the caller passed", (
        tester,
      ) async {
        // Arrange
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _app(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        // Act
        AppDialog.confirm(
          capturedContext,
          title: _pt.meetingsDeleteTitle,
          message: "Esta ação não pode ser desfeita.",
          confirmLabel: _pt.meetingsDeleteAction,
          cancelLabel: _pt.coreBack,
        );
        await tester.pumpAndSettle();

        // Assert — the caller's wording, not a hardcoded default.
        expect(find.text(_pt.meetingsDeleteTitle), findsOneWidget);
        expect(find.text(_pt.meetingsDeleteAction), findsOneWidget);
        expect(find.text(_pt.coreBack), findsOneWidget);
        expect(find.text(_pt.meetingsConfirm), findsNothing);
        expect(find.text(_pt.meetingsCancel), findsNothing);
      });

      testWidgets("L8: the dialog surface and ink come from the colorScheme", (
        tester,
      ) async {
        // Arrange
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _app(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        // Act
        AppDialog.confirm(
          capturedContext,
          title: _pt.meetingsDeleteTitle,
          message: "Esta ação não pode ser desfeita.",
          confirmLabel: _pt.meetingsDeleteAction,
          cancelLabel: _pt.meetingsCancel,
          isDestructive: true,
        );
        await tester.pumpAndSettle();

        // Assert — the surface is the scheme's, the title ink is onSurface.
        final scheme = AppTheme.light().colorScheme;
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, scheme.surface);

        final title = tester.widget<Text>(find.text(_pt.meetingsDeleteTitle));
        expect(title.style?.color, scheme.onSurface);

        // Assert — the destructive confirm is the shared button's error
        // variant, so its fill and its ink stay a matched pair.
        final confirm = tester.widget<AppButton>(
          find.widgetWithText(AppButton, _pt.meetingsDeleteAction),
        );
        expect(confirm.variant, AppButtonVariant.error);
      });
    },
  );
}
