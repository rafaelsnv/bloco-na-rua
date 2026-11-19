import "package:shared_preferences/shared_preferences.dart";

/// Persists whether the user has already gone through the onboarding.
///
/// Same storage pattern as the theme mode (SharedPreferences), just a
/// different key.
///
/// ponytail: the flag is per device, not per account. Key it by user id if
/// shared devices ever need a fresh onboarding for each account.
class OnboardingPrefs {
  OnboardingPrefs._();

  static const String _key = "HAS_SEEN_ONBOARDING";

  /// Whether the onboarding was already completed on this device.
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Marks the onboarding as completed, so it is never shown again.
  static Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
