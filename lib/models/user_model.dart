class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? profilePic;
  String? phoneNumber;
  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.profilePic,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      profilePic: map['profilePic'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
