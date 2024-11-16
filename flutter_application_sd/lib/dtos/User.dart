class User {
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  String? city;
  String? country;
  String? phonePrefix;
  DateTime? birthday;

  User({
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.phonePrefix,
    this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'phonePrefix': phonePrefix,
      'birthday': birthday?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      phonePrefix: json['phonePrefix'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
    );
  }

  @override
  String toString() {
    return 'User(username: $username, password: $password, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phonePrefix $phoneNumber, address: $address, city: $city, country: $country, birthday: $birthday)';
  }
}
