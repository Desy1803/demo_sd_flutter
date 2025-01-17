class User {
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? email;

  User({
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User(username: $username, password: $password, firstName: $firstName, lastName: $lastName, email: $email,)';
  }
}
