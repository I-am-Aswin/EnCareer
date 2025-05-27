// lib/utils/validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Invalid email format";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Enter name";
    return null;
  }
}