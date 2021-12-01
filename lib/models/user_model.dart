class UserModel {
  String? uid, email, username, password;

  UserModel({uid, email, username, password});

  // receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
    );
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
