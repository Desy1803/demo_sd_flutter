class UserUpdateRequest {
  String? username;
  String? firstName;
  String? lastName;

  UserUpdateRequest({
    this.username,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequest(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  @override
  String toString() {
    return 'User(username: $username, firstName: $firstName, lastName: $lastName)';
  }
}
