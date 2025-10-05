import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';
import 'notification_permission_screen.dart';
import '../services/auth_service.dart';

class PrivacyConsentScreen extends StatefulWidget {
  final String mobileNumber;
  
  const PrivacyConsentScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  bool _consent1 = false; // For membership benefits (required)
  bool _consent2 = false; // For marketing activities
  bool _consent3 = false; // For product offers
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Privacy Policy Content
                  const Text(
                    'Major Cineplex Group Public Company Limited ("Company")',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Major Cineplex Group Public Company Limited and its affiliates ("Company") recognize the importance of protecting your personal data as a data subject under the Personal Data Protection Act B.E. 2562 ("PDPA"). The Company has therefore prepared this Privacy Policy to inform you, as the data subject, of the purposes and details of the collection, use, and/or disclosure of your personal data, as well as your rights under the PDPA.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Consent checkboxes
                  const Text(
                    'Please mark the boxes to give consent as you wish.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _ConsentCheckbox(
                    text: 'For receiving membership benefits as specified by the company *',
                    isChecked: _consent1,
                    onChanged: (bool? value) {
                      setState(() {
                        _consent1 = value ?? false;
                      });
                    },
                    isRequired: true,
                  ),
                  _ConsentCheckbox(
                    text: 'For improving or developing marketing activities',
                    isChecked: _consent2,
                    onChanged: (bool? value) {
                      setState(() {
                        _consent2 = value ?? false;
                      });
                    },
                  ),
                  _ConsentCheckbox(
                    text: 'For presenting products, news, product activities, services, benefits, and other special offers',
                    isChecked: _consent3,
                    onChanged: (bool? value) {
                      setState(() {
                        _consent3 = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Fixed bottom button
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(
                top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _consent1 && !_isLoading ? () async {
                    setState(() {
                      _isLoading = true;
                    });
                    
                    try {
                      // Send OTP to the phone number
                      await _authService.sendOTP(widget.mobileNumber);
                      
                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationPermissionScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error sending OTP: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _consent1 
                        ? const Color(0xFFFFD700) // Yellow when enabled
                        : const Color(0xFF2A2A2A), // Dark gray when disabled
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final bool isRequired;

  const _ConsentCheckbox({
    required this.text,
    required this.isChecked,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: const Color(0xFFFFD700),
              checkColor: Colors.black,
              side: BorderSide(
                color: isRequired && !isChecked ? Colors.red : Colors.grey,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}