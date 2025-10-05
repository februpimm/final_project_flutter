import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Save phone number to Firebase Firestore
  static Future<void> savePhoneNumber(String phoneNumber) async {
    try {
      await _firestore.collection('users').add({
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'lastLogin': FieldValue.serverTimestamp(),
        'userType': 'new_user',
      });
      print('✅ บันทึกเบอร์โทร $phoneNumber ใน Firebase สำเร็จ');
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการบันทึก: $e');
      throw Exception('ไม่สามารถบันทึกเบอร์โทรได้: ${e.toString()}');
    }
  }
  
  // Check if phone number exists in Firebase
  static Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get()
          .timeout(const Duration(milliseconds: 1500));
      
      final exists = querySnapshot.docs.isNotEmpty;
      print('📋 เบอร์โทร $phoneNumber ${exists ? 'มีอยู่แล้ว' : 'ยังไม่มี'}');
      return exists;
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการตรวจสอบ: $e');
      return false;
    }
  }
  
  // Get user data from Firebase by phone number
  static Future<Map<String, dynamic>?> getUserDataByPhone(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get()
          .timeout(const Duration(milliseconds: 1500));
      
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการดึงข้อมูล: $e');
      return null;
    }
  }

  // Get user data from Firebase by email - Optimized for speed
  static Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      print('🔍 Searching for email in Firebase: $email');
      
      // Special handling for test@gmail.com - Instant response
      if (email.toLowerCase() == 'test@gmail.com') {
        print('🎯 Special user detected: test@gmail.com - Instant response');
        // Return mock data immediately for test@gmail.com
        return {
          'email': 'test@gmail.com',
          'firstName': 'Test',
          'lastName': 'User',
          'userType': 'existing_user',
          'hasMultipleAccounts': true,
        };
      }
      
      // Optimized query with faster timeout
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get()
          .timeout(const Duration(milliseconds: 1000)); // 1 second timeout for speed
      
      print('📊 Query result: ${querySnapshot.docs.length} documents found');
      
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        print('✅ User data found: $userData');
        return userData;
      }
      print('❌ No user data found for email: $email');
      return null;
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการดึงข้อมูล: $e');
      return null;
    }
  }

  // Save email to Firebase
  static Future<void> saveEmailToFirebase(String email) async {
    try {
      await _firestore.collection('users').add({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'userType': 'email_user',
      });
      print('✅ บันทึกอีเมลสำเร็จ: $email');
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการบันทึกอีเมล: $e');
      throw Exception('ไม่สามารถบันทึกอีเมลได้: ${e.toString()}');
    }
  }

  // Save user data to Firebase
  static Future<void> saveUserData(
    String uid,
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'displayName': '$firstName $lastName',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'userType': 'registered_user',
      });
      print('✅ บันทึกข้อมูลผู้ใช้สำเร็จ: $firstName $lastName');
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการบันทึกข้อมูลผู้ใช้: $e');
      throw Exception('ไม่สามารถบันทึกข้อมูลผู้ใช้ได้: ${e.toString()}');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserTickets(String userId) async {
    try {
      print('🔍 Loading tickets for user: $userId');
      final querySnapshot = await _firestore
          .collection('tickets')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(const Duration(seconds: 5));
      
      final tickets = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      
      print('📊 Found ${tickets.length} tickets for user');
      if (tickets.isNotEmpty) {
        print('🎫 Ticket details from Firebase:');
        tickets.forEach((ticket) {
          print('  - ID: ${ticket['id']}');
          print('  - Movie: ${ticket['movieTitle']}');
          print('  - Cinema: ${ticket['cinemaName']}');
          print('  - Date: ${ticket['date']}');
          print('  - Time: ${ticket['time']}');
          print('  - Seats: ${ticket['selectedSeats']}');
          print('  - Price: ${ticket['totalPrice']}');
          print('  - Status: ${ticket['status']}');
        });
      } else {
        print('❌ No tickets found for user: $userId');
        print('🔍 Checking Firebase collection...');
      }
      return tickets;
    } catch (e) {
      print('❌ Error loading user tickets: $e');
      return [];
    }
  }

  static Future<void> saveTicket(Map<String, dynamic> ticketData) async {
    try {
      print('🎫 Saving ticket to Firebase...');
      print('📊 Ticket data: $ticketData');
      final docRef = await _firestore.collection('tickets').add(ticketData);
      print('✅ Ticket saved successfully with ID: ${docRef.id}');
      print('🎫 Ticket saved to collection: tickets');
    } catch (e) {
      print('❌ Error saving ticket: $e');
      throw Exception('ไม่สามารถบันทึกตั๋วได้: ${e.toString()}');
    }
  }
}
