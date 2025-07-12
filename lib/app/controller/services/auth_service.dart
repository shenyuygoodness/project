import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Keys for SharedPreferences
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _firstTimeUserKey = 'first_time_user';

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  /// Check if this is the first time the user is opening the app
  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeUserKey) ?? true;
  }

  /// Mark that the user has opened the app before
  Future<void> markNotFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeUserKey, false);
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Clear all app data (useful for complete logout)
  Future<void> clearAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await signOut();
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email. Please check your credentials or sign up.';
      case 'wrong-password':
        return 'Wrong password provided. Please try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      default:
        return e.message ?? 'An unknown error occurred';
    }
  }

  /// Determine the initial route based on auth state and onboarding status
  Future<String> getInitialRoute() async {
    final bool isFirstTime = await isFirstTimeUser();
    final bool onboardingCompleted = await isOnboardingCompleted();
    final bool authenticated = isAuthenticated;

    if (isFirstTime || !onboardingCompleted) {
      return '/onboarding';
    } else if (authenticated) {
      return '/home';
    } else {
      return '/login';
    }
  }
}