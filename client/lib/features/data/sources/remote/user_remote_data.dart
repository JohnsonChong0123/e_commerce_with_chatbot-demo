import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/core/errors/exception.dart';
import '/features/data/models/user_model.dart';

import '../../../../core/common/utils/firebase_util.dart';

abstract interface class UserRemoteData {
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithFacebook();

  Future<void> signOut();

  Future<void> forgetPassword({
    required String email,
  });

  Future<UserModel?> getCurrentUser();

  Future<UserModel> getUserProfile();

  Future<UserModel> updateUser({
    required UserModel userModel,
  });

  Future<String> uploadUserImage({
    required File image,
    required UserModel user,
  });

  Future<String> getStorageImage({
    required String userId,
  });

  Future<void> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<void> deleteUser();

  Future<void> updateUserWallet({
    required double amount,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class UserRemoteDataImpl implements UserRemoteData {
  @override
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const ServerException('User is null!');
      }

      final imageFile = await _downloadImage(
          "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y");

      final imagesRef = FirebaseStorage.instance
          .ref('profileImages')
          .child(userCredential.user!.uid);

      final uploadTask = imagesRef.putFile(imageFile);
      final taskSnapshot = await uploadTask;

      final imageURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(
        {
          'userId': userCredential.user!.uid,
          'userFirstName': firstName,
          'userLastName': lastName,
          'userEmail': email,
          'userPhone': phone,
          'userImage': imageURL,
        },
      );
      await userCredential.user!.updateDisplayName('$firstName $lastName');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const ServerException(
              'An account already exists with that email');
        case 'invalid-email':
          throw const ServerException('The email address is not valid');
        case 'operation-not-allowed':
          throw const ServerException(
              'userEmail/password accounts are not enabled');
        case 'weak-password':
          throw const ServerException('The password provided is too weak');
        case 'network-request-failed':
          throw const ServerException('A network error occurred');
        default:
          throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const ServerException('User is null!');
      }

      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();

      if (userCredential.user!.email != userData.data()!['userEmail']) {
        throw const ServerException(
            'Please verify your email. A verification link has been sent to your email address.');
      }

      return UserModel.fromJson(userData.data()!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const ServerException('No user found for that email.');
        case 'wrong-password':
          throw const ServerException('Wrong password provided for that user.');
        case 'invalid-email':
          throw const ServerException('The email address is not valid.');
        case 'user-disabled':
          throw const ServerException('This user has been disabled.');
        case 'too-many-requests':
          throw const ServerException('Too many requests. Try again later.');
        case 'operation-not-allowed':
          throw const ServerException(
              'userEmail/password accounts are not enabled.');
        default:
          throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const ServerException('Google sign-in was cancelled by user.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          await _handleNewUser(userCredential);
        }
      } else {
        throw const ServerException(
            'Failed to retrieve Google authentication tokens.');
      }

      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();

      return UserModel.fromJson(userData.data()!);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    }
    throw const ServerException('Failed to login with Google.');
  }

  @override
  Future<UserModel> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success) {
        throw ServerException(
            'Facebook sign-in failed: ${loginResult.message}');
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      if (userCredential.user != null) {
        _handleNewUser(userCredential);
      }

      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();

      return UserModel.fromJson(userData.data()!);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    }
    throw const ServerException('Failed to login with Facebook.');
  }

  @override
  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.isSignedIn();
      final facebookAccessToken = await FacebookAuth.instance.accessToken;

      if (googleUser) {
        await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      } else if (facebookAccessToken != null) {
        await FacebookAuth.instance.logOut();
        await FirebaseAuth.instance.signOut();
      } else {
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> forgetPassword({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw const ServerException('The email address is not valid.');
        case 'user-not-found':
          throw const ServerException('No user found for that email.');
        default:
          throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUser != null) {
        final userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .get();

        return UserModel.fromJson(userData.data()!);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();

      if (!userData.exists) {
        throw const ServerException('User not found!');
      }

      return UserModel.fromJson(userData.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser({
    required UserModel userModel,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update(userModel.toJson());
      await currentUser!
          .updateDisplayName('${userModel.firstName} ${userModel.lastName}');
      if (currentUser!.email != userModel.email) {
        await currentUser!.verifyBeforeUpdateEmail(userModel.email);
      }
      return userModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadUserImage({
    required File image,
    required UserModel user,
  }) async {
    try {
      final imagesRef =
          FirebaseStorage.instance.ref('profileImages').child(currentUser!.uid);

      final uploadTask = imagesRef.putFile(image);
      final taskSnapshot = await uploadTask;

      final imageURL = await taskSnapshot.ref.getDownloadURL();
      return imageURL;
    } on ServerException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> getStorageImage({
    required String userId,
  }) async {
    try {
      final imagesRef =
          FirebaseStorage.instance.ref('profileImages').child(userId);

      final imageURL = await imagesRef.getDownloadURL();

      return imageURL;
    } on ServerException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update(
        {
          'userAddress': address,
          'userLatitude': latitude,
          'userLongitude': longitude
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await FirebaseStorage.instance
          .ref('profileImages')
          .child(currentUser!.uid)
          .delete();

      final wishlistData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Wishlists')
          .get();

      for (final data in wishlistData.docs) {
        await data.reference.delete();
      }

      final orderData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Orders')
          .get();

      for (final data in orderData.docs) {
        await data.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .delete();

      final user = FirebaseAuth.instance.currentUser;
      final providers = user?.providerData ?? [];

      bool isGoogle = providers.any((p) => p.providerId == 'google.com');
      bool isFacebook = providers.any((p) => p.providerId == 'facebook.com');
      bool isEmail = providers.any((p) => p.providerId == 'password');

      if (isGoogle) {
        await user!.delete();
        await GoogleSignIn().signOut();
      } else if (isFacebook) {
        await user!.delete();
        await FacebookAuth.instance.logOut();
      } else if (isEmail) {
        await user!.delete();
      } else {
        await user!.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateUserWallet({
    required double amount,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update(
        {
          'userWallet': amount,
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<File> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/profile_image.png');
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<void> _handleNewUser(UserCredential userCredential) async {
    if (userCredential.additionalUserInfo!.isNewUser) {
      final fullName = userCredential.user!.displayName ?? '';
      final nameParts = fullName.split(' ');
      final firstName = nameParts.length > 1
          ? nameParts.sublist(0, nameParts.length - 1).join(' ')
          : '';
      final lastName = nameParts.last;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(
        {
          'userId': userCredential.user!.uid,
          'userFirstName': firstName,
          'userLastName': lastName,
          'userEmail': userCredential.user!.email,
          'userPhone': userCredential.user!.phoneNumber,
          'userImage': userCredential.user!.photoURL,
        },
      );
      if (userCredential.user!.photoURL != null) {
        final imageFile = await _downloadImage(userCredential.user!.photoURL!);

        final imagesRef = FirebaseStorage.instance
            .ref('profileImages')
            .child(currentUser!.uid);

        imagesRef.putFile(imageFile);
      }
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        throw const ServerException(
            'An account already exists with a different credential.');
      case 'invalid-credential':
        throw const ServerException('The credential is invalid or expired.');
      case 'operation-not-allowed':
        throw const ServerException('Operation not allowed.');
      case 'user-disabled':
        throw const ServerException('This user has been disabled.');
      case 'user-not-found':
        throw const ServerException('No user found for that email.');
      case 'wrong-password':
        throw const ServerException('Wrong password provided for that user.');
      case 'invalid-verification-code':
        throw const ServerException('The verification code is invalid.');
      case 'invalid-verification-id':
        throw const ServerException('The verification ID is invalid.');
      default:
        throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: oldPassword,
      );

      await currentUser!.reauthenticateWithCredential(credential);

      await currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw const ServerException("The old password is incorrect.");
      } else {
        throw ServerException(e.toString());
      }
    } on ServerException catch (e) {
      throw ServerException(e.toString());
    }
  }
}
