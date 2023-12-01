import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tech_media/ViewModel/services/session_manager.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';

class SignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('user');
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signUp(BuildContext context, String username, String email,
      String password) async {
    setLoading(true);
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'username': username,
          'onlineStatus': "No one",
          'profile': "",
          'phoneNumber': "",
        }).then((_) {
          Navigator.pushNamed(context, RouteName.dashboardView);
          Utils().toastMessage('User Created Successfully');
          setLoading(false);
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
          setLoading(false);
        });
        Utils().toastMessage('User Created Successfully');
        setLoading(false);
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setLoading(false);
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
      setLoading(false);
    }
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential value =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Set the user ID in the SessionController
      SessionController().userId = value.user!.uid.toString();

      // Storing user information in the Realtime Database
      ref.child(value.user!.uid.toString()).set({
        'uid': value.user!.uid.toString(),
        'email': value.user!.email.toString(),
        'username': value.user!.displayName ?? 'Default Username',
        'onlineStatus': 'No one',
        'profile': value.user!.photoURL ?? '',
        'phoneNumber': '',
      }).then((_) {
        // Update the user profile in Firebase Auth
        value.user!.updateProfile(
            displayName: value.user!.displayName,
            photoURL: value.user!.photoURL);

        // Navigate to the desired screen after successful Google sign-in
        Navigator.pushNamed(context, RouteName.dashboardView);
        Utils().toastMessage('Google Sign-In Successful');
        setLoading(false);
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setLoading(false);
      });

      return value;
    } on Exception catch (e) {
      // Handle exceptions
      print('exception->$e');
      return null;
    }
  }
}
