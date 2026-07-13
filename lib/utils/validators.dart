/// Loose format check: "something@something.something".
///
/// Deliberately permissive — strict RFC regexes reject real addresses, and
/// syntax can never prove ownership anyway. Real proof comes from the
/// verification email, so this only needs to catch obvious typos early.
final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());
