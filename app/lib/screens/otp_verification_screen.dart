import 'package:flutter/material.dart';
import 'dart:async';
import 'existing_account_screen.dart';
import 'privacy_consent_screen.dart';
import 'genre_selection_screen.dart';
import '../services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  
  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _timer;
  int _countdown = 30; // 30 seconds countdown
  String _otpCode = '';
  final AuthService _authService = AuthService();
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_isVerifying) return;
    
    setState(() {
      _isVerifying = true;
    });

    try {
      final result = await _authService.verifyOTP(_otpCode);
      
      if (mounted) {
        // Check if this is a new phone number
        final isExistingNumber = await _authService.checkPhoneNumberExists(widget.mobileNumber);
        
        if (isExistingNumber) {
          // Existing number - skip consent and notification, go directly to genre selection
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GenreSelectionScreen(),
            ),
          );
        } else {
          // New number - go to privacy consent for registration
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PrivacyConsentScreen(
                mobileNumber: widget.mobileNumber,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }


  void _resendCode() {
    if (_countdown == 0) {
      setState(() {
        _countdown = 30;
      });
      _startTimer();
      // Here you would typically resend the OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP code resent successfully'),
          backgroundColor: Color(0xFF2A2A2A),
        ),
      );
    }
  }


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
        title: const Text(
          'OTP Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Instruction text
                  const Text(
                    'Enter the confirmation code that we sent to your registered mobile number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(22.5),
                          border: _otpCode.length > index
                              ? Border.all(color: const Color(0xFFFFD700), width: 2)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Dot placeholder, visible when field is empty
                            if (_otpControllers[index].text.isEmpty)
                              Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            // Actual TextField for input
                            TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                color: _otpControllers[index].text.isEmpty
                                    ? Colors.transparent // Hide text when empty, show dot
                                    : Colors.white, // Show text when filled
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _otpCode = '';
                                  for (int i = 0; i < 6; i++) {
                                    _otpCode += _otpControllers[i].text;
                                  }
                                });
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                } else {
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                }
                                
                                // Auto-verify when all 6 digits are entered
                                if (_otpCode.length == 6) {
                                  _verifyOTP();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  
                  // Resend code option
                  GestureDetector(
                    onTap: _resendCode,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Didn\'t receive it? '),
                          TextSpan(
                            text: _countdown > 0 
                                ? 'Resend the code in ${_countdown.toString().padLeft(2, '0')}:${(30 - _countdown).toString().padLeft(2, '0')}'
                                : 'Resend the code',
                            style: TextStyle(
                              color: _countdown > 0 ? Colors.grey[400] : const Color(0xFFFFD700),
                              fontWeight: _countdown > 0 ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

}
