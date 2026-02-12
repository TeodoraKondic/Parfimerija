/*class UserModel {
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
}*/
class UserModel {
  final String uid; // ← dodaj ovo
  final String name, email, address, phoneNumber, role, password, userImage;

  UserModel({
    required this.uid, // ← obavezno u konstruktor
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
      uid: data['uid'] ?? '', // ← ovde uzimamo uid iz Firestore
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
      'uid': uid, // ← obavezno dodaj ovde
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
