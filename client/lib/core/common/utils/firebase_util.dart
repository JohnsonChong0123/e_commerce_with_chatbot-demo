import 'package:firebase_auth/firebase_auth.dart';

User? get currentUser {
  return FirebaseAuth.instance.currentUser;
}