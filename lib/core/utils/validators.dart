class Validators {
  bool isValidEmail(String email) {
    final trimmedEmail = email.trim();

    // Basic email regex pattern
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    return emailRegex.hasMatch(trimmedEmail);
  }

  bool isLegacySigninPasswordValid(String password) {
    // Backward-compatible sign-in: allow any non-empty password.
    return password.trim().isNotEmpty;
  }

  bool isStrongPassword(String password) {
    final trimmedPassword = password.trim();
    if (trimmedPassword.isEmpty) return false;
    if (trimmedPassword.length < 6) return false;
    if (!RegExp(r'[A-Z]').hasMatch(trimmedPassword)) return false;
    if (!RegExp(r'[a-z]').hasMatch(trimmedPassword)) return false;
    if (!RegExp(r'[0-9]').hasMatch(trimmedPassword)) return false;
    if (!RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(trimmedPassword)) {
      return false;
    }
    return true;
  }
}
