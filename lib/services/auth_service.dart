import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Prove ownership of the inbox; the AuthGate holds the account at the
      // verification screen until the link is clicked.
      await credential.user?.sendEmailVerification();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      }
      throw e.message ?? 'Sign up failed.';
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // One identical message for every "those credentials are wrong"
        // outcome. Separating "no such account" from "wrong password" would
        // reveal which addresses are registered — see [sendPasswordReset].
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-email':
          throw 'Incorrect email or password.';
        case 'user-disabled':
          throw 'This account has been disabled.';
        case 'too-many-requests':
          throw 'Too many attempts. Please wait a minute before trying again.';
      }
      throw e.message ?? 'Sign in failed.';
    }
  }

  /// Emails a password-reset link.
  ///
  /// `user-not-found` is deliberately swallowed rather than surfaced: telling
  /// the caller an address has no account turns this screen into an oracle for
  /// probing which emails are registered. Callers show the same confirmation
  /// either way.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return;
      if (e.code == 'invalid-email') {
        throw 'Please enter a valid email address.';
      }
      if (e.code == 'too-many-requests') {
        throw 'Too many attempts. Please wait a minute before trying again.';
      }
      throw e.message ?? 'Could not send the reset email.';
    }
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;

  Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw 'Too many attempts. Please wait a minute before resending.';
      }
      throw e.message ?? 'Could not send verification email.';
    }
  }

  /// Fetches the latest account state from the server. `emailVerified` is
  /// cached on-device, so clicking the link in the inbox is invisible to the
  /// app until a reload like this one runs.
  Future<bool> reloadAndCheckVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Like [authStateChanges], but also emits on profile refreshes (reload,
  /// display-name updates), so listeners notice email verification.
  Stream<User?> get userChanges => _auth.userChanges();
}