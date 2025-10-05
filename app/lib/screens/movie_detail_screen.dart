import 'package:flutter/material.dart';
import 'ticket_summary_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieTitle;
  final String movieImage;
  final String releaseDate;
  final String genre;
  final String rating;
  final String duration;
  final bool isComingSoon;

  const MovieDetailScreen({
    super.key,
    required this.movieTitle,
    required this.movieImage,
    required this.releaseDate,
    required this.genre,
    required this.rating,
    required this.duration,
    this.isComingSoon = false,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _selectedDateIndex = 0;
  Map<String, int> _selectedTimeIndices = {};
  int _expandedCinemaIndex = -1;
  bool _showSeatSelection = false;
  int _selectedTimeIndex = 0;
  String _selectedCinema = '';
  String _selectedTheatre = '';
  String _selectedLanguage = '';
  String _selectedSubtitle = '';
  String _selectedFormat = '';
  Set<String> _selectedSeats = {};

  final List<String> _dates = ['Today 05', 'Mon 06', 'Tue 07', 'Wed 08'];
  
  final List<Map<String, dynamic>> _cinemas = [
    {
      'name': 'Major Central Rama III',
      'distance': '0.69 km',
      'isFavorite': false,
      'theatres': [
        {
          'name': 'Theatre 5',
          'language': 'TH',
          'subtitle': 'CC',
          'format': 'IMAX',
          'times': ['10:30', '13:00', '15:30', '18:00']
        },
      ]
    },
    {
      'name': 'ICON CINECONIC',
      'distance': '4.89 km',
      'isFavorite': false,
      'theatres': [
        {
          'name': 'Theatre 3',
          'language': 'EN',
          'subtitle': 'CC TH',
          'format': 'IMAX',
          'times': ['14:00', '20:00']
        }
      ]
    },
    {
      'name': 'Quartier CineArt',
      'distance': '5.77 km',
      'isFavorite': false,
      'theatres': [
        {
          'name': 'Theatre 2',
          'language': 'TH',
          'subtitle': 'CC NONE',
          'format': '4DX',
          'times': ['13:00', '17:00', '21:00']
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_showSeatSelection) {
      return _buildSeatSelectionScreen();
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          // App Bar with movie poster
          SliverAppBar(
            expandedHeight: _showSeatSelection ? MediaQuery.of(context).size.height * 0.5 : 300,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (_showSeatSelection) {
                  setState(() {
                    _showSeatSelection = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Movie poster background
                  Image.asset(
                    widget.movieImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Movie details content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie title
                  Text(
                    widget.movieTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Genre and duration
                  Row(
                    children: [
                      Text(
                        widget.genre,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.duration} mins',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'R${widget.rating}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date selection
                  const Text(
                    'Select date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date buttons
                  Row(
                    children: List.generate(_dates.length, (index) {
                      bool isSelected = index == _selectedDateIndex;
                      
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFAC23A) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _dates[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Nearby cinemas
                  const Text(
                    'Nearby',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cinema list
                  ..._cinemas.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> cinema = entry.value;
                    bool isExpanded = _expandedCinemaIndex == index;
                    
                    return Column(
                      children: [
                        _buildCinemaCard(
                          name: cinema['name'],
                          distance: cinema['distance'],
                          isFavorite: cinema['isFavorite'],
                          isExpanded: isExpanded,
                          onTap: () {
                            setState(() {
                              _expandedCinemaIndex = isExpanded ? -1 : index;
                            });
                          },
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 8),
                          _buildCinemaDetails(cinema['theatres'], cinema['name']),
                        ],
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaCard({
    required String name,
    required String distance,
    required bool isFavorite,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Cinema logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Cinema info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Expand icon
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCinemaDetails(List<Map<String, dynamic>> theatres, String cinemaName) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: theatres.map((theatre) {
          return Column(
            children: [
              // Theatre info
              Row(
                children: [
                  Text(
                    theatre['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.volume_up, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    theatre['language'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    theatre['subtitle'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      theatre['format'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Show times
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: theatre['times'].map<Widget>((time) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeIndices[cinemaName] = theatre['times'].indexOf(time);
                          _showSeatSelection = true;
                          _selectedCinema = cinemaName;
                          _selectedTheatre = theatre['name'];
                          _selectedLanguage = theatre['language'];
                          _selectedSubtitle = theatre['subtitle'];
                          _selectedFormat = theatre['format'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTimeIndices[cinemaName] == theatre['times'].indexOf(time) 
                              ? const Color(0xFFFAC23A) 
                              : Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _selectedTimeIndices[cinemaName] == theatre['times'].indexOf(time) 
                                ? const Color(0xFFFAC23A) 
                                : Colors.grey,
                          ),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            color: _selectedTimeIndices[cinemaName] == theatre['times'].indexOf(time) 
                                ? Colors.black 
                                : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getSeatType(int row) {
    if (row >= 0 && row <= 6) {
      return 'Normal'; // Rows M-G (Red)
    } else if (row >= 7 && row <= 9) {
      return 'Premium'; // Rows F-D (Blue)
    } else {
      return 'Opera'; // Rows C-B (Red with higher price)
    }
  }

  int _getSeatPrice(String seatType) {
    switch (seatType) {
      case 'Normal':
        return 260;
      case 'Premium':
        return 290;
      case 'Opera':
        return 740;
      default:
        return 260;
    }
  }

  String _getSeatLabel(int row, int col) {
    final rows = ['M', 'L', 'K', 'J', 'I', 'H', 'G', 'F', 'E', 'D', 'C', 'B'];
    return '${rows[row]}${col + 1}';
  }

  Widget _buildSeatMap() {
    final rows = ['M', 'L', 'K', 'J', 'I', 'H', 'G', 'F', 'E', 'D', 'C', 'B'];
    final seatsPerSide = 7; // 7 seats on each side
    
    return Column(
      children: rows.asMap().entries.map((entry) {
        final rowIndex = entry.key;
        final rowLabel = entry.value;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left row label
              SizedBox(
                width: 20,
                child: Text(
                  rowLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 4),
              
              // Left side seats
              ...List.generate(seatsPerSide, (seatIndex) {
                return _buildSeat(rowIndex, seatIndex, rowLabel);
              }),
              
              // Center aisle
              const SizedBox(width: 16),
              
              // Right side seats
              ...List.generate(seatsPerSide, (seatIndex) {
                return _buildSeat(rowIndex, seatIndex + seatsPerSide, rowLabel);
              }),
              
              const SizedBox(width: 4),
              // Right row label
              SizedBox(
                width: 20,
                child: Text(
                  rowLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeat(int rowIndex, int seatIndex, String rowLabel) {
    final seatNumber = seatIndex + 1;
    final seatLabel = '$rowLabel$seatNumber';
    final seatType = _getSeatType(rowIndex);
    
    // Some seats are occupied (example - every 13th seat)
    final globalIndex = (rowIndex * 14) + seatIndex;
    final isOccupied = (globalIndex % 13 == 0);
    final isSelected = _selectedSeats.contains(seatLabel);
    
    // Determine seat color based on type
    Color seatColor;
    if (isOccupied) {
      seatColor = Colors.grey.shade700;
    } else if (isSelected) {
      seatColor = const Color(0xFFFAC23A); // Yellow when selected
    } else {
      switch (seatType) {
        case 'Normal':
          seatColor = const Color(0xFFE53E3E); // Red
          break;
        case 'Premium':
          seatColor = const Color(0xFF1976D2); // Blue
          break;
        case 'Opera':
          seatColor = const Color(0xFFE53E3E); // Red (same as normal but different price)
          break;
        default:
          seatColor = const Color(0xFFE53E3E);
      }
    }
    
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: GestureDetector(
        onTap: isOccupied ? null : () {
          setState(() {
            if (_selectedSeats.contains(seatLabel)) {
              _selectedSeats.remove(seatLabel);
            } else {
              _selectedSeats.add(seatLabel);
            }
          });
        },
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: seatColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.2),
              width: isSelected ? 1.5 : 0.5,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Text(
                    '$seatNumber',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSeatSelectionScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          // Movie poster header with back button
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showSeatSelection = false;
                });
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Movie poster background
                  Image.asset(
                    widget.movieImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Movie title overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movieTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.genre,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.duration} mins',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Movie details content
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thai title
                  const Text(
                    'ตี๋ยอด 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Release info
                  const Row(
                    children: [
                      Text(
                        '1 ตุลาคมนี้ ในโรงภาพยนตร์',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'EXPERIENCE IT IN IMAX',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Cinema info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Major logo
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B4513).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'M',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedCinema,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedTheatre,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Language and subtitle info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.volume_up,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedLanguage,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.closed_caption,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedSubtitle,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Laser Cinema tag
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LASER CINEMA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Rating and format tags
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedFormat,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Date
                  const Text(
                    'Today 05',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Showtime selection
                  Row(
                    children: [
                      // 10:30
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTimeIndex == 0 ? const Color(0xFFE0E0E0) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedTimeIndex == 0 ? const Color(0xFFE0E0E0) : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '10:30',
                                style: TextStyle(
                                  color: _selectedTimeIndex == 0 ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // 13:00
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTimeIndex == 1 ? const Color(0xFFE0E0E0) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedTimeIndex == 1 ? const Color(0xFFE0E0E0) : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '13:00',
                                style: TextStyle(
                                  color: _selectedTimeIndex == 1 ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // 15:30
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeIndex = 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTimeIndex == 2 ? const Color(0xFFE0E0E0) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedTimeIndex == 2 ? const Color(0xFFE0E0E0) : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '15:30',
                                style: TextStyle(
                                  color: _selectedTimeIndex == 2 ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // 18:00
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeIndex = 3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTimeIndex == 3 ? const Color(0xFFE0E0E0) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedTimeIndex == 3 ? const Color(0xFFE0E0E0) : Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '18:00',
                                style: TextStyle(
                                  color: _selectedTimeIndex == 3 ? Colors.black : Colors.white,
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
                  const SizedBox(height: 32),
                  
                  // Screen indicator
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B4513),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'SCREEN',
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
                  _buildSeatMap(),
                  const SizedBox(height: 24),
                  
                  // Seat type legend
                  Row(
                    children: [
                      // Normal seat
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE53E3E)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.chair, color: Color(0xFFE53E3E), size: 20),
                              SizedBox(height: 4),
                              Text(
                                'Normal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '฿260',
                                style: TextStyle(
                                  color: Color(0xFFE53E3E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Premium seat
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1976D2)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.chair, color: Color(0xFF1976D2), size: 20),
                              SizedBox(height: 4),
                              Text(
                                'Premium',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '฿290',
                                style: TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Opera Chair
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE53E3E)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.chair, color: Color(0xFFE53E3E), size: 20),
                              SizedBox(height: 4),
                              Text(
                                'Opera Chair',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '฿740',
                                style: TextStyle(
                                  color: Color(0xFFE53E3E),
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
                  const SizedBox(height: 24),
                  
                  // Selected seats and total price (always show)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selected Seats',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _selectedSeats.isEmpty ? '' : _selectedSeats.join(', '),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: _selectedSeats.isEmpty ? Colors.white30 : const Color(0xFFFAC23A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedSeats.isEmpty ? '' : '฿${_calculateTotal()}',
                              style: TextStyle(
                                color: _selectedSeats.isEmpty ? Colors.white30 : const Color(0xFFFAC23A),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Mobile number input
                  TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Continue button
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedSeats.isEmpty ? null : () {
                            // Navigate to ticket summary
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TicketSummaryScreen(
                                  movieTitle: widget.movieTitle,
                                  movieImage: widget.movieImage,
                                  cinemaName: _selectedCinema,
                                  theatreName: _selectedTheatre,
                                  date: '05 Oct 2025',
                                  time: ['10:30', '13:00', '15:30', '18:00'][_selectedTimeIndex],
                                  language: _selectedLanguage,
                                  subtitle: _selectedSubtitle,
                                  format: _selectedFormat,
                                  selectedSeats: _selectedSeats,
                                  totalPrice: _calculateTotal(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedSeats.isEmpty ? const Color(0xFF3A3A3A) : const Color(0xFFFAC23A),
                            foregroundColor: _selectedSeats.isEmpty ? Colors.white30 : Colors.black,
                            disabledBackgroundColor: const Color(0xFF3A3A3A),
                            disabledForegroundColor: Colors.white30,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: _selectedSeats.isEmpty ? 0 : 8,
                            shadowColor: const Color(0xFFFAC23A).withOpacity(0.4),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Terms and Privacy text
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                          children: const [
                            TextSpan(text: 'By continuing, you agree to our '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Color(0xFFFAC23A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFFFAC23A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotal() {
    int total = 0;
    for (String seatLabel in _selectedSeats) {
      // Extract row from seat label (e.g., "M1" -> "M")
      final rowLetter = seatLabel[0];
      final rows = ['M', 'L', 'K', 'J', 'I', 'H', 'G', 'F', 'E', 'D', 'C', 'B'];
      final rowIndex = rows.indexOf(rowLetter);
      
      if (rowIndex != -1) {
        final seatType = _getSeatType(rowIndex);
        total += _getSeatPrice(seatType);
      }
    }
    return total;
  }
}
