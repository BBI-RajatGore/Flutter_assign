
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }

  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!regex.hasMatch(value)) {
    return 'Please enter a valid email';
  }

  return null;
}


String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'At least one uppercase letter required';
  }

  if (!RegExp(r'\d').hasMatch(value)) {
    return 'At least one digit required';
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'At least one special character required';
  }

  if (value.contains(' ')) {
    return 'Password cannot contain spaces';
  }

  return null;
}
