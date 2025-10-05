import 'package:flutter/material.dart';
import 'ticket_screen.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';

class TicketSuccessScreen extends StatefulWidget {
  final String movieTitle;
  final String movieImage;
  final String cinemaName;
  final String theatreName;
  final String date;
  final String time;
  final List<String> selectedSeats;
  final double totalPrice;

  const TicketSuccessScreen({
    super.key,
    required this.movieTitle,
    required this.movieImage,
    required this.cinemaName,
    required this.theatreName,
    required this.date,
    required this.time,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  State<TicketSuccessScreen> createState() => _TicketSuccessScreenState();
}

class _TicketSuccessScreenState extends State<TicketSuccessScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveTicketToFirebase();
  }

  Future<void> _saveTicketToFirebase() async {
    final authService = AuthService();
    print('🎫 TicketSuccessScreen - Starting to save ticket...');
    print('🔐 User logged in: ${authService.currentUser != null}');
    if (authService.currentUser != null) {
      print('👤 User ID: ${authService.currentUser!.uid}');
      setState(() {
        _isSaving = true;
      });

      try {
        final ticketData = {
          'userId': authService.currentUser!.uid,
          'movieTitle': widget.movieTitle,
          'movieImage': widget.movieImage,
          'cinemaName': widget.cinemaName,
          'theatreName': widget.theatreName,
          'date': widget.date,
          'time': widget.time,
          'selectedSeats': widget.selectedSeats,
          'totalPrice': widget.totalPrice,
          'status': 'confirmed',
          'createdAt': DateTime.now(),
        };

        await FirebaseService.saveTicket(ticketData);
        print('✅ Ticket saved to Firebase successfully');
        print('📊 Ticket data: $ticketData');
        print('🎫 Ticket saved with ID: ${ticketData['userId']}');
        print('🔍 Verifying ticket was saved...');
        
        // Navigate to TicketScreen immediately after saving
        if (mounted) {
          print('🎫 Auto navigating to TicketScreen immediately...');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TicketScreen(
                movieTitle: widget.movieTitle,
                movieImage: widget.movieImage,
                cinemaName: widget.cinemaName,
                theatreName: widget.theatreName,
                date: widget.date,
                time: widget.time,
                selectedSeats: widget.selectedSeats,
                totalPrice: widget.totalPrice,
              ),
            ),
          );
        }
        print('🎫 Ticket saved with ID: ${ticketData['userId']}');
      } catch (e) {
        print('❌ Error saving ticket: $e');
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              if (_isSaving)
                const CircularProgressIndicator(
                  color: Color(0xFFFAC23A),
                )
              else
                Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              
              // Success Title
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Success Message
              const Text(
                'Your movie ticket has been purchased successfully',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Ticket Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3A3A3A),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title
                    Text(
                      widget.movieTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Cinema
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.cinemaName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Date and Time
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Seats
                    Row(
                      children: [
                        const Icon(
                          Icons.chair,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Seats: ${widget.selectedSeats.join(', ')}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Total Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '฿${widget.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFFFAC23A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Action Buttons
              Column(
                children: [
                  // View Tickets Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => TicketScreen(
                              movieTitle: widget.movieTitle,
                              movieImage: widget.movieImage,
                              cinemaName: widget.cinemaName,
                              theatreName: widget.theatreName,
                              date: widget.date,
                              time: widget.time,
                              selectedSeats: widget.selectedSeats,
                              totalPrice: widget.totalPrice,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFAC23A),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View My Tickets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Home Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/main',
                          (route) => false,
                          arguments: {'initialIndex': 0},
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF3A3A3A),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
