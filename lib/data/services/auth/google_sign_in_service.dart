import "dart:async";

import "package:app_links/app_links.dart";
import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart"
    show LoginResponse;
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:result_dart/result_dart.dart";
import "package:url_launcher/url_launcher.dart";

/// Coordinates the RFC 8252 external-browser Google OAuth flow.
class GoogleSignInService {
  GoogleSignInService({
    required AuthApiClient authApiClient,
    AppLinks? appLinks,
  }) : _authApiClient = authApiClient,
       _appLinks = appLinks ?? AppLinks();

  static const _callbackScheme = "blocnatarua";
  static const _callbackHost = "auth";
  static const _callbackPath = "/callback";
  static const _pollInterval = Duration(seconds: 2);
  static const _timeout = Duration(seconds: 60);

  final AuthApiClient _authApiClient;
  final AppLinks _appLinks;

  Future<Result<LoginResponse>> launchGoogleSignIn() async {
    final completion = Completer<Result<LoginResponse>>();
    var callbackReceived = false;

    bool isCallback(Uri uri) =>
        uri.scheme == _callbackScheme &&
        uri.host == _callbackHost &&
        uri.path == _callbackPath;

    Future<void> completeFromCallback(Uri uri) async {
      if (callbackReceived || !isCallback(uri)) return;
      callbackReceived = true;
      final result = await _authApiClient.googleComplete();
      if (!completion.isCompleted) completion.complete(result);
    }

    final subscription = _appLinks.uriLinkStream.listen(completeFromCallback);
    try {
      final launched = await launchUrl(
        Uri.parse(_authApiClient.googleChallengeUrl()),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        return Failure(Exception("Could not launch Google sign-in"));
      }

      // ponytail: /complete has no documented callback payload or pending-state
      // contract in Swagger, so poll it as a fallback until the deep link wins.
      final deadline = DateTime.now().add(_timeout);
      while (!completion.isCompleted && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(_pollInterval);
        if (completion.isCompleted || callbackReceived) break;
        final result = await _authApiClient.googleComplete();
        if (!completion.isCompleted) completion.complete(result);
      }

      if (!completion.isCompleted && !callbackReceived) {
        completion.complete(Failure(Exception("Google sign-in timed out")));
      }
      return await completion.future;
    } finally {
      await subscription.cancel();
    }
  }
}
