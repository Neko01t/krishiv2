class UserModel {
  final String? name;
  final String email;
  final String mobile;
  final String password;
  // final String? address;
  final String? profileImage;
  final String? uid;

  const UserModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    // required this.address,
    required this.profileImage,
    this.uid,
  });
  toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      // 'address': address,
      'profileImage': profileImage,
      'uid': uid
    };
  }
}
