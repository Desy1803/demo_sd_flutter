class UserResponse {
  String? username;
  String? firstName;
  String? lastName;
  String? email;

  UserResponse({
    this.username,
    this.firstName,
    this.lastName,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User(username: $username, firstName: $firstName, lastName: $lastName, email: $email)';
  }
}
