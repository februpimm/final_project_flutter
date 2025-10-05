import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import 'main_shell.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({
    super.key,
    this.movieTitle,
    this.movieImage,
    this.cinemaName,
    this.theatreName,
    this.date,
    this.time,
    this.selectedSeats,
    this.totalPrice,
  });

  final String? movieTitle;
  final String? movieImage;
  final String? cinemaName;
  final String? theatreName;
  final String? date;
  final String? time;
  final List<String>? selectedSeats;
  final double? totalPrice;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<Map<String, dynamic>> _userTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('🎫 TicketScreen initState - Loading tickets...');
    _loadUserTickets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload tickets when screen becomes visible
    _loadUserTickets();
  }

  @override
  void didUpdateWidget(TicketScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload tickets when widget updates (e.g., new ticket data passed)
    print('🎫 TicketScreen didUpdateWidget - Reloading tickets...');
    _loadUserTickets();
  }

  Future<void> _loadUserTickets() async {
    final authService = AuthService();
    if (authService.currentUser != null) {
      try {
        print('🎫 Loading tickets for user: ${authService.currentUser!.uid}');
        // Load user's tickets from Firebase
        final tickets = await FirebaseService.getUserTickets(authService.currentUser!.uid);
        setState(() {
          _userTickets = tickets;
          _isLoading = false;
        });
        print('✅ Loaded ${tickets.length} tickets from Firebase');
        if (tickets.isNotEmpty) {
          print('📊 First ticket data: ${tickets.first}');
          print('🎫 Ticket details:');
          tickets.forEach((ticket) {
            print('  - Movie: ${ticket['movieTitle']}');
            print('  - Cinema: ${ticket['cinemaName']}');
            print('  - Date: ${ticket['date']}');
            print('  - Time: ${ticket['time']}');
            print('  - Seats: ${ticket['selectedSeats']}');
            print('  - Price: ${ticket['totalPrice']}');
          });
          print('🎫 UI will show ${tickets.length} tickets');
        } else {
          print('❌ No tickets found in Firebase');
          print('🔍 Checking if user has any tickets...');
          print('👤 User ID: ${authService.currentUser!.uid}');
          print('🎫 UI will show "No tickets found" message');
        }
      } catch (e) {
        print('❌ Error loading tickets: $e');
        setState(() {
          _isLoading = false;
        });
        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่สามารถโหลดตั๋วได้: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // If no user is logged in, show empty state
      print('❌ No user logged in');
      setState(() {
        _userTickets = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add new ticket to the list if it was passed from TicketSuccessScreen
    if (widget.movieTitle != null && widget.movieTitle!.isNotEmpty) {
      final newTicket = {
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
        'isNew': true, // Mark as new ticket
      };
      
      // Add to the beginning of the list if not already present
      if (!_userTickets.any((ticket) => 
          ticket['movieTitle'] == widget.movieTitle &&
          ticket['date'] == widget.date &&
          ticket['time'] == widget.time)) {
        _userTickets.insert(0, newTicket);
        print('🎫 Added new ticket to display: ${widget.movieTitle}');
        print('🎫 Total tickets now: ${_userTickets.length}');
      }
    }

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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainShell(initialIndex: 0), // Home tab
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text(
          'My Tickets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _loadUserTickets();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFAC23A),
                ),
              )
            : _userTickets.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Sample ticket card
                      _buildSampleTicketCard(context),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _userTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = _userTickets[index];
                      return _buildTicketCard(ticket);
                    },
                  ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return GestureDetector(
      onTap: () => _showTicketDetail(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket['movieTitle'] ?? 'Unknown Movie',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket['cinemaName'] ?? 'Unknown Cinema',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${ticket['date'] ?? 'Unknown Date'} at ${ticket['time'] ?? 'Unknown Time'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seats: ${(ticket['seats'] as List?)?.join(', ') ?? 'Unknown'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '฿${ticket['totalPrice']?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    color: Color(0xFFFAC23A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketDetail(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Movie poster
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    ticket['movieImage'] ?? 'assets/movie/image.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.movie,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Movie title
              Text(
                ticket['movieTitle'] ?? 'Unknown Movie',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Details
              _buildDetailRow('Cinema', ticket['cinemaName'] ?? 'Unknown Cinema'),
              const SizedBox(height: 12),
              _buildDetailRow('Theatre', ticket['theatreName'] ?? 'Unknown Theatre'),
              const SizedBox(height: 12),
              _buildDetailRow('Date', ticket['date'] ?? 'Unknown Date'),
              const SizedBox(height: 12),
              _buildDetailRow('Time', ticket['time'] ?? 'Unknown Time'),
              const SizedBox(height: 12),
              _buildDetailRow('Seats', (ticket['selectedSeats'] as List?)?.join(', ') ?? 'Unknown'),
              const SizedBox(height: 12),
              _buildDetailRow('Total', '฿${ticket['totalPrice']?.toStringAsFixed(0) ?? '0'}', isAmount: true),
              const SizedBox(height: 24),
              // Dashed divider
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainter(),
              ),
              const SizedBox(height: 24),
              // QR Code section
              const Text(
                'Show this QR code at the cinema',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Image.asset(
                  'assets/qr code/ticket qrcode.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_2,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ticket QR Code',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Booking ID
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Booking ID: ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'MJ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isAmount ? const Color(0xFF00C853) : Colors.black87,
            fontSize: isAmount ? 18 : 14,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Helper function for building detail rows
Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: isAmount ? const Color(0xFF00C853) : Colors.black87,
          fontSize: isAmount ? 18 : 14,
          fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    ],
  );
}

// Dashed line painter
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget _buildSampleTicketCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Show sample ticket detail
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Movie poster
                  Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/movie/image.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.movie,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Movie title
                  const Text(
                    'Tee Yod 3',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Details
                  _buildDetailRow('Cinema', 'Major Central Rama III'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Theatre', 'IMAX Theatre'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Date', '05 Oct 2025'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Time', '10:30'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Seats', 'F10, F11'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Total', '฿660', isAmount: true),
                  const SizedBox(height: 24),
                  // Dashed divider
                  CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DashedLinePainter(),
                  ),
                  const SizedBox(height: 24),
                  // QR Code section
                  const Text(
                    'Show this QR code at the cinema',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'assets/qr code/ticket qrcode.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_2,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ticket QR Code',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Booking ID
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Booking ID: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'MJ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tee Yod 3',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Major Central Rama III',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '05 Oct 2025 at 10:30',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Seats: F10, F11',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '฿660',
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
  );
}