class ValidationUtils {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^(?:\+1\s?)?(?:\(\d{3}\)|\d{3})[\s.-]?\d{3}[\s.-]?\d{4}$'
  );

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }
}
