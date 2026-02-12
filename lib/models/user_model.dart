class UserModel {
  final String name, email, address, phoneNumber, role, password, userImage;

  UserModel({
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
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? 'user',
      password:data['password']??'',
      userImage: data['userImage'] ?? '',
    );
  }
}