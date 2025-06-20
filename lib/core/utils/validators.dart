class Validators {
  bool isValidEmail(String email) {
    final trimmedEmail = email.trim();

    // Basic email regex pattern
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    return emailRegex.hasMatch(trimmedEmail);
  }
}
