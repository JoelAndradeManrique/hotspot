class AuthFormState {
  final String name;
  final String email;
  final String password;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final bool isPasseordHidden;

  AuthFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.nameError,
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.isPasseordHidden = true,
  });

  bool get isFormvalid =>
      emailError == null &&
      passwordError == null &&
      (name.isEmpty || nameError == null);
}
