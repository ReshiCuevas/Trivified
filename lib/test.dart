import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tech_media/utils/routes/route_name.dart';
import 'package:tech_media/utils/utils.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Google SignIn Screen')),
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return (userCredential.value == '' ||
                      userCredential.value == null)
                  ? Center(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          iconSize: 40,
                          icon: const FaIcon(FontAwesomeIcons.google),
                          onPressed: () async {
                            userCredential.value =
                                await signInWithGoogle(context);
                            if (userCredential.value != null)
                              print(userCredential.value.user!.email);
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.5, color: Colors.black54)),
                            child: Image.network(
                                userCredential.value.user!.photoURL.toString()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(userCredential.value.user!.displayName
                              .toString()),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(userCredential.value.user!.email.toString()),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                bool result = await signOutFromGoogle();
                                if (result) userCredential.value = '';
                              },
                              child: const Text('Logout'))
                        ],
                      ),
                    );
            }));
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
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

      // Signing in with Google and obtaining user information
      final UserCredential value =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Storing user information in the Realtime Database
      ref.child(value.user!.uid.toString()).set({
        'uid': value.user!.uid.toString(),
        'email': value.user!.email.toString(),
        'username': value.user!.displayName
            .toString(), // Set your default or initial username
        'onlineStatus': 'No one',
        'profile': value.user!.photoURL.toString(),
        'phoneNumber': '',
      }).then((_) {
        // Navigate to the desired screen after successful Google sign-in
        Navigator.pushNamed(context, RouteName.dashboardView);
        Utils().toastMessage('Google Sign-In Successful');
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        // setLoading(false);
      });
      return value;
    } on Exception catch (e) {
      // Handle exceptions
      print('exception->$e');
      return null;
    }
  }
}
