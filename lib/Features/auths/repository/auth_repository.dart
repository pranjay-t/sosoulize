import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sosoulize/core/constants/constants.dart';
import 'package:sosoulize/core/constants/firebase_constants.dart';
import 'package:sosoulize/core/constants/failure.dart';
import 'package:sosoulize/core/constants/type_def.dart';
import 'package:sosoulize/models/user_models.dart';
import 'package:sosoulize/core/providers/auth_provider.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(
        FirebaseConstants.usersCollection,
      );

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModels> signInWithGoogle(bool isFromLogin) async {
    try {

      UserCredential userCredential;
      
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          final googleAuth = await googleUser?.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );

          if (isFromLogin) {
            userCredential = await _auth.signInWithCredential(credential);
          } else {
            userCredential =
                await _auth.currentUser!.linkWithCredential(credential);
          }
      }

      UserModels userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModels(
          name: userCredential.user!.displayName ?? "NO NAME",
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModels> signInWithGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserModels userModel = UserModels(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      print(e.message);
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModels> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModels.fromMap(event.data() as Map<String, dynamic>));
  }
}
