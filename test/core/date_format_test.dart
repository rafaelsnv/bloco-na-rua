import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  setUpAll(() async {
    await initAppLocale();
  });

  group("C3 — i18n quick fix (pt + en + locale-aware DateFormat)", () {
    test("kSupportedLocales exposes pt and en", () {
      expect(kSupportedLocales, [const Locale("pt"), const Locale("en")]);
    });

    testWidgets(
      "an en_US device locale resolves to en and formats in English",
      (tester) async {
        late String formatted;
        late Locale resolvedLocale;
        late String networkError;

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale("en", "US"),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: kSupportedLocales,
            home: Builder(
              builder: (context) {
                resolvedLocale = Localizations.localeOf(context);
                formatted = formatDateTime(
                  DateTime(2026, 2, 14, 15, 30),
                  context,
                );
                networkError = AppLocalizations.of(context)!.network;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedLocale, const Locale("en"));
        expect(formatted, "14 Feb 2026 • 15:30");
        expect(networkError, contains("No internet connection"));
      },
    );

    testWidgets("a device locale outside the supported list falls back to pt", (
      tester,
    ) async {
      late String formatted;
      late Locale resolvedLocale;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("fr", "FR"),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          home: Builder(
            builder: (context) {
              resolvedLocale = Localizations.localeOf(context);
              formatted = formatDateTime(
                DateTime(2026, 2, 14, 15, 30),
                context,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedLocale, const Locale("pt"));
      expect(formatted, "14 fev. 2026 • 15:30");
    });
  });
}
