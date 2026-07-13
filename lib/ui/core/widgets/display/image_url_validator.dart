// URL validator for image providers.
//
// Guards CachedNetworkImageProvider / CachedNetworkImage callsites from
// backend placeholder strings such as "img" that lack a scheme/host and
// would otherwise throw asynchronously inside the image cache (where no
// errorBuilder can catch them). See session handoff §16 for the original
// runtime error captured against the live app.

/// Returns true when [url] is an absolute http(s) URL with a parseable host.
///
/// Rejects: null, empty, whitespace, relative paths, protocol-relative URLs,
/// non-http(s) schemes, and URLs missing a host. Pass a custom
/// [allowedSchemes] set if a different scheme (e.g. "data") is acceptable.
bool isValidImageUrl(
  String? url, {
  Set<String> allowedSchemes = const {"http", "https"},
}) {
  if (url == null) return false;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;

  // Relative paths and protocol-relative URLs have no scheme separator.
  // Examples rejected: "img", "img/foo.png", "//cdn.example.com/img.png".
  if (!trimmed.contains("://") || trimmed.startsWith("//")) return false;

  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme) return false;
  if (!allowedSchemes.contains(uri.scheme.toLowerCase())) return false;

  // The runtime error "No host specified in URI" originates here.
  if (uri.host.isEmpty) return false;

  return true;
}
