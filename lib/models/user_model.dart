class UserModel {
  final String uid; 
  final String name, email, address, phoneNumber, role, password, userImage;

  UserModel({
    required this.uid, 
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.role,
    required this.password,
    required this.userImage,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '', 
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? 'user',
      password: data['password'] ?? '',
      userImage: data['userImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, 
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'role': role,
      'password': password,
      'userImage': userImage,
    };
  }
}
