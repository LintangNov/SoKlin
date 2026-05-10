import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/features/auth/data/models/user_model.dart';

class UserSessionService extends GetxService {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isLoggedIn => currentUser.value != null;
  String get userName => currentUser.value?.name ?? 'Pengguna';

  Future<UserSessionService> init() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await _loadUserFromFirestore(firebaseUser.uid);
    }
    return this;
  }

  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        currentUser.value = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      // User data not found, will be handled at login/register
      currentUser.value = null;
    }
  }

  Future<void> setUser(UserModel user) async {
    currentUser.value = user;
  }

  void clearUser() {
    currentUser.value = null;
  }
}
