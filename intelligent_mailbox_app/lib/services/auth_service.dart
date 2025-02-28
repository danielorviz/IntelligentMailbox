import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Verificar si el usuario ya existe en Realtime Database
        final DatabaseReference userRef = _database.ref().child('users').child(user.uid);
        final DataSnapshot snapshot = await userRef.get();

        if (!snapshot.exists) {
          // Registrar al usuario si no existe
          await userRef.set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
          });
        }
      }

      return user;
    } catch (e) {
      print('Error en la autenticación: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}