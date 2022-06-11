import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickchat/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uId) async {
    UserModel? userModel;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();

    if (snapshot.data() != null) {
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      // return userModel;
    }
    return userModel;
  }

  // get user stream from firebase
  static Stream<UserModel?> getUserStream(String uId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .snapshots()
        .map((snapshot) =>
            UserModel.fromMap(snapshot.data() as Map<String, dynamic>));
  }
}
