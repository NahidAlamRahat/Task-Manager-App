class UserData {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  /// full name
  String? get fullName => '$firstName $lastName';

  /// Constructor to create a UserData object from JSON
  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }

  /// Method to convert UserData object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'photo': photo,
    };
  }
}
