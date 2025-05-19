class SignUpUser {
  final String firstName;
  final String lastName;
  final String gender;
  final String mobileNo;
  final String email;
  final String? country;
  final String password;
  final String confirmPassword;

  SignUpUser({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.mobileNo,
    required this.email,
    required this.country,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "mobile_no": mobileNo,
      "email": email,
      "country": country,
      "password": password,
      "confirm_password": confirmPassword,
    };
  }
}
