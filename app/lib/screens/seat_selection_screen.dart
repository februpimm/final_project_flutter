import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Set<String> _selectedSeats = {};
  String _mobileNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Cinema info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เมเจอร์ ซีนีเพล็กซ์ โลตัส พล',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Text(
                        'Theatre 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.volume_up, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'HONE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'พฤ. 29 ส.ค. 2567',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Time selection
                  Row(
                    children: [
                      // First showtime (selected)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFAC23A),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '11:00',
                              style: TextStyle(
                                color: Color(0xFFFAC23A),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Second showtime
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(
                            child: Text(
                              '16:20',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Screen indicator
            Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'หน้าจอ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Seat map
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Seat grid
                    Expanded(
                      child: Row(
                        children: [
                          // Left side seats
                          Expanded(
                            child: Column(
                              children: [
                                // Row labels
                                SizedBox(
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: ['H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'].map((label) => 
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ),
                                // Seats
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                    ),
                                    itemCount: 16, // 8 rows x 2 seats
                                    itemBuilder: (context, index) {
                                      final row = ['H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'][index ~/ 2];
                                      final seat = '${row}${index % 2 + 1}';
                                      final isSelected = _selectedSeats.contains(seat);
                                      final isHoneymoon = ['A', 'B', 'C', 'D'].contains(row);
                                      final isOccupied = ['H', 'G', 'F', 'E'].contains(row);
                                      
                                      Color seatColor;
                                      if (isSelected) {
                                        seatColor = const Color(0xFFFAC23A);
                                      } else if (isOccupied) {
                                        seatColor = const Color(0xFFE53E3E);
                                      } else if (isHoneymoon) {
                                        seatColor = const Color(0xFF9C27B0);
                                      } else {
                                        seatColor = const Color(0xFFE53E3E);
                                      }
                                      
                                      return GestureDetector(
                                        onTap: () {
                                          if (!isOccupied) {
                                            setState(() {
                                              if (isSelected) {
                                                _selectedSeats.remove(seat);
                                              } else {
                                                _selectedSeats.add(seat);
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: seatColor,
                                            borderRadius: BorderRadius.circular(4),
                                            border: isSelected ? Border.all(color: const Color(0xFFFAC23A), width: 2) : null,
                                          ),
                                          child: Center(
                                            child: isSelected ? const Icon(
                                              Icons.sentiment_very_satisfied,
                                              color: Colors.black,
                                              size: 12,
                                            ) : Text(
                                              '${index % 2 + 1}',
                                              style: TextStyle(
                                                color: isSelected ? Colors.black : Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Right side seats
                          Expanded(
                            child: Column(
                              children: [
                                // Row labels
                                SizedBox(
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: ['H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'].map((label) => 
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ),
                                // Seats
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                    ),
                                    itemCount: 16, // 8 rows x 2 seats
                                    itemBuilder: (context, index) {
                                      final row = ['H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'][index ~/ 2];
                                      final seat = '${row}${index % 2 + 3}';
                                      final isSelected = _selectedSeats.contains(seat);
                                      final isHoneymoon = ['A', 'B', 'C', 'D'].contains(row);
                                      final isOccupied = ['H', 'G', 'F', 'E'].contains(row);
                                      
                                      Color seatColor;
                                      if (isSelected) {
                                        seatColor = const Color(0xFFFAC23A);
                                      } else if (isOccupied) {
                                        seatColor = const Color(0xFFE53E3E);
                                      } else if (isHoneymoon) {
                                        seatColor = const Color(0xFF9C27B0);
                                      } else {
                                        seatColor = const Color(0xFFE53E3E);
                                      }
                                      
                                      return GestureDetector(
                                        onTap: () {
                                          if (!isOccupied) {
                                            setState(() {
                                              if (isSelected) {
                                                _selectedSeats.remove(seat);
                                              } else {
                                                _selectedSeats.add(seat);
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: seatColor,
                                            borderRadius: BorderRadius.circular(4),
                                            border: isSelected ? Border.all(color: const Color(0xFFFAC23A), width: 2) : null,
                                          ),
                                          child: Center(
                                            child: isSelected ? const Icon(
                                              Icons.sentiment_very_satisfied,
                                              color: Colors.black,
                                              size: 12,
                                            ) : Text(
                                              '${index % 2 + 3}',
                                              style: TextStyle(
                                                color: isSelected ? Colors.black : Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Continue button
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to next screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Proceeding to payment...'),
                            backgroundColor: const Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                      ),
                      child: const Text(
                        '5. ดูราคา ด้วยยย',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Seat type legend
                  Row(
                    children: [
                      // Normal seat
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53E3E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Normal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '฿109',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Honeymoon seat
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C27B0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Honeymoon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '฿129',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Selected seats info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ที่นั่งที่เลือก',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedSeats.isNotEmpty ? _selectedSeats.first : 'A8',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_selectedSeats.isNotEmpty ? _selectedSeats.length : 1} ที่นั่ง',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '฿${(_selectedSeats.isNotEmpty ? _selectedSeats.length : 1) * 129}.00',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}