class UserModel {
  final String? id;
  final String? email;
  final String? token;

  UserModel({
    this.id,
    this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(), 
      email: json['email']?.toString(),
      token: json['jwt']?.toString(),
    );
  }
}