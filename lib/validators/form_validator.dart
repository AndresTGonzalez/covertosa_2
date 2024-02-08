class FormValidator {
  static bool emailValidator(String email) {
    // Verificar si el email tiene un formato válido
    if (email.isEmpty) {
      return false;
    }
    RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }
}
