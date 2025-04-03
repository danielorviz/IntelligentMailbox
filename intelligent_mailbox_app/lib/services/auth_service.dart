import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<User?> signInWithFirebase({
    required String email,
    required String password,
  }) async {
    try {
      final User? user = await getFirebaseUser(
        email: email,
        password: password,
      );

      if (user != null) {
        if (user.emailVerified == false) {
          user.sendEmailVerification();
          await _auth.signOut();
          throw Exception('email-not-verified');
        }
        final DatabaseReference userRef = _database
            .ref()
            .child('users')
            .child(user.uid);
        final DataSnapshot snapshot = await userRef.get();

        if (!snapshot.exists) {
          await userRef.set({
            'uid': user.uid,
            'name': user.displayName ?? 'Sin nombre',
            'email': user.email,
            'photoURL': user.photoURL ?? '',
          });
        }
      }

      return user;
    } catch (e) {
      if (e.toString().contains("email-not-verified")) {
        rethrow;
      }
      return null;
    }
  }

  Future<User?> getFirebaseUser({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    return user;
  }

  Future<User?> registerWithFirebase({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
        user.sendEmailVerification();

        final DatabaseReference userRef = _database
            .ref()
            .child('users')
            .child(user.uid);

        await userRef.set({
          'uid': user.uid,
          'name': name,
          'email': user.email,
          'photoURL': user.photoURL ?? '',
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('error-registrar-usuario');
    } finally {
      await _auth.signOut();
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('error-enviar-email-restablecimiento');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Verificar si el usuario ya existe en Realtime Database
        final DatabaseReference userRef = _database
            .ref()
            .child('users')
            .child(user.uid);
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
    _database.ref().onDisconnect();
    await FirebaseAuth.instance.signOut();
  }
}
