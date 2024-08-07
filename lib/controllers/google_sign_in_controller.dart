import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  GoogleSignInController() : _auth = FirebaseAuth.instance;

  static GoogleSignInController get to => Get.find();

  // Object for Google Sign In & Firebase Authentification
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  User? _firebaseUser;
  GoogleSignInAccount? _currentUser;

  User? get user => _firebaseUser;
  bool get isUserSignedIn => _firebaseUser != null;
  String get userUid => user != null ? user!.uid : '';

  @override
  void onInit() {
    super.onInit();
    Get.put(ProjectsController());

    // Set Firebase Authentification listener
    _auth.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      ProjectsController.to.getProjects(userUid);
      update();
    });

    // Log in with Google
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account!;
      update();
      if (_currentUser != null) {
        print('Logged in with Google: ${_currentUser!.displayName}');
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Log out with Google
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
