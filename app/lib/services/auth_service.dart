import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('❌ OTP verification failed: ${e.message}');
          throw Exception('การส่ง OTP ล้มเหลว: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print('📱 OTP sent to: $phoneNumber');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('❌ Error sending OTP: $e');
      throw Exception('ไม่สามารถส่ง OTP ได้: ${e.toString()}');
    }
  }

  // Verify OTP code
  Future<UserCredential> verifyOTP(String otpCode) async {
    try {
      if (_verificationId == null) {
        throw Exception('ไม่พบ verification ID กรุณาส่ง OTP ใหม่');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      print('✅ OTP verification successful');
      return userCredential;
    } catch (e) {
      print('❌ OTP verification failed: $e');
      throw Exception('รหัส OTP ไม่ถูกต้อง: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('ออกจากระบบสำเร็จ');
    } catch (e) {
      print('❌ Error signing out: $e');
      throw Exception('ไม่สามารถออกจากระบบได้: ${e.toString()}');
    }
  }

  // Check if phone number exists in Firebase
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get()
          .timeout(const Duration(milliseconds: 1500));
      
      final exists = querySnapshot.docs.isNotEmpty;
      print('📞 Phone number check: $phoneNumber - ${exists ? 'exists' : 'not found'}');
      return exists;
    } catch (e) {
      print('❌ Error checking phone number: $e');
      return false;
    }
  }

  // Save new phone number to Firebase
  Future<void> savePhoneNumber(String phoneNumber) async {
    try {
      await _firestore.collection('users').add({
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'lastLogin': FieldValue.serverTimestamp(),
        'userType': 'new_user',
      });
      print('💾 Phone number saved: $phoneNumber');
    } catch (e) {
      print('❌ Error saving phone number: $e');
      throw Exception('ไม่สามารถบันทึกเบอร์โทรได้: ${e.toString()}');
    }
  }

  // Sign in with email (Firebase authentication)
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 2));
      print('✅ Email login successful for: $email');
      return userCredential;
    } catch (e) {
      print('❌ Email login failed: $e');
      throw Exception('ไม่สามารถเข้าสู่ระบบได้: ${e.toString()}');
    }
  }

  // Save email to Firebase
  Future<void> saveEmailToFirebase(String email) async {
    try {
      await _firestore.collection('users').add({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'userType': 'email_user',
      });
      print('✅ Email saved to Firebase: $email');
    } catch (e) {
      print('❌ Error saving email: $e');
      throw Exception('ไม่สามารถบันทึกอีเมลได้: ${e.toString()}');
    }
  }

  // Create account with email (Firebase authentication) - Optimized for speed
  Future<UserCredential> createAccountWithEmail(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    try {
      // Create user with ultra-fast timeout
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(milliseconds: 1500)); // 1.5 second timeout

      // Update user profile (async, don't wait)
      userCredential.user?.updateDisplayName('$firstName $lastName');
      
      // Save additional user data to Firestore (async, don't wait)
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'displayName': '$firstName $lastName',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'userType': 'registered_user',
      });

      print('✅ Account creation successful for: $email');
      print('📝 User details: $firstName $lastName, Phone: $phoneNumber');
      return userCredential;
    } catch (e) {
      print('❌ Account creation failed: $e');
      throw Exception('ไม่สามารถสร้างบัญชีได้: ${e.toString()}');
    }
  }
}