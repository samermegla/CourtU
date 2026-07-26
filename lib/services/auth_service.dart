import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The OAuth "web" client (type 3) from google-services.json. Android needs it
/// to mint an ID token Firebase will accept; without it `idToken` comes back
/// null and the sign-in silently fails. Public by design — an OAuth client ID
/// is an identifier, not a secret.
const _serverClientId =
    '725898610839-b08uf39rqvvmil9i75or8a5s8fdaeua3.apps.googleusercontent.com';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// `initialize` must run once before any other GoogleSignIn call, and is not
  /// idempotent-friendly enough to call per tap.
  static Future<void>? _googleInit;
  static Future<void> _ensureGoogleReady() =>
      _googleInit ??= GoogleSignIn.instance.initialize(
        serverClientId: _serverClientId,
      );

  /// Signs in with Google and exchanges the result for a Firebase session.
  ///
  /// Returns null when the user backs out of the Google sheet — that's a
  /// cancellation, not a failure, and callers should stay silent rather than
  /// show an error.
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleReady();

      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw 'Google did not return an ID token. Check that the SHA-1 '
            'fingerprint is registered for this build.';
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw 'Google sign-in failed: ${e.description ?? e.code.name}';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw 'An account already exists for that email. Sign in with your '
            'password instead.';
      }
      throw e.message ?? 'Google sign-in failed.';
    }
  }

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
   /// Saves the name the user wants to be called. Writing the display name
  /// makes `userChanges` emit, so the AuthGate rebuilds and moves the user off
  /// the username prompt on its own — no navigation needed at the call site.
  Future<void> updateDisplayName(String name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
      // updateDisplayName mutates the cached User in place; reload forces a
      // fresh profile so the new name is guaranteed present on the next emit.
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Could not save your name.';
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