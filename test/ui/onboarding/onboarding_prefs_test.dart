import "package:bloco_na_rua/ui/onboarding/onboarding_prefs.dart";
import "package:flutter_test/flutter_test.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test("a fresh install has not seen the onboarding", () async {
    expect(await OnboardingPrefs.hasSeenOnboarding(), isFalse);
  });

  test("the flag survives after being marked as seen", () async {
    await OnboardingPrefs.markOnboardingAsSeen();
    expect(await OnboardingPrefs.hasSeenOnboarding(), isTrue);
  });
}
