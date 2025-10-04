import 'package:flutter/material.dart';

class CinemasScreen extends StatefulWidget {
  const CinemasScreen({super.key});

  @override
  State<CinemasScreen> createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen> {
  int _selectedTab = 0; // 0 = All Cinemas, 1 = Favourite, 2 = Recents
  Set<String> _selectedCategories = {'All'};
  final TextEditingController _searchController = TextEditingController();
  Set<String> _favouriteCinemas = {'Major Big C Suksawat'};
  List<String> _recentCinemas = ['Major Big C Suksawat'];

  final List<String> _categories = ['All', 'IMAX', '4DX', 'Screen X', 'Kids', 'LED'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavourite(String cinemaName) {
    setState(() {
      if (_favouriteCinemas.contains(cinemaName)) {
        _favouriteCinemas.remove(cinemaName);
      } else {
        _favouriteCinemas.add(cinemaName);
      }
    });
  }

  void _addToRecent(String cinemaName) {
    setState(() {
      // Remove if already exists to avoid duplicates
      _recentCinemas.remove(cinemaName);
      // Add to the beginning of the list
      _recentCinemas.insert(0, cinemaName);
      // Keep only the last 10 recent cinemas
      if (_recentCinemas.length > 10) {
        _recentCinemas = _recentCinemas.take(10).toList();
      }
    });
  }

  void _onTabChanged(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
      // Reset categories when switching to Recents tab
      if (tabIndex == 2) {
        _selectedCategories = {'All'};
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredCinemas() {
    List<Map<String, dynamic>> cinemas = List.from(_mockCinemas);
    
    // Filter by tab
    if (_selectedTab == 1) { // Favourite
      cinemas = cinemas.where((cinema) => _favouriteCinemas.contains(cinema['name'])).toList();
    } else if (_selectedTab == 2) { // Recents
      cinemas = cinemas.where((cinema) => _recentCinemas.contains(cinema['name'])).toList();
    }
    // For All Cinemas tab (_selectedTab == 0), show all cinemas
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      cinemas = cinemas.where((cinema) => 
        cinema['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    // Filter by selected categories (only apply to All Cinemas and Favourite tabs)
    if (_selectedTab != 2 && _selectedCategories.isNotEmpty && !_selectedCategories.contains('All')) {
      cinemas = cinemas.where((cinema) {
        final cinemaFeatures = List<String>.from(cinema['features'] ?? []);
        return _selectedCategories.any((category) => cinemaFeatures.contains(category));
      }).toList();
    }
    
    // Remove duplicates based on cinema name and distance
    cinemas = cinemas.fold<List<Map<String, dynamic>>>([], (list, cinema) {
      if (!list.any((item) => 
          item['name'] == cinema['name'] && 
          item['distance'] == cinema['distance'])) {
        list.add(cinema);
      }
      return list;
    });
    
    return cinemas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Cinemas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Primary Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Animated background
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: _selectedTab == 0 ? 0 : 
                            _selectedTab == 1 ? (MediaQuery.of(context).size.width - 32) / 3 : 
                            (MediaQuery.of(context).size.width - 32) * 2 / 3,
                      top: 0,
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAC23A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Tab buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onTabChanged(0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'All Cinemas',
                                  style: TextStyle(
                                    color: _selectedTab == 0 ? Colors.black : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onTabChanged(1),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Favourite',
                                  style: TextStyle(
                                    color: _selectedTab == 1 ? Colors.black : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onTabChanged(2),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Recents',
                                  style: TextStyle(
                                    color: _selectedTab == 2 ? Colors.black : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ),
            
            const SizedBox(height: 16),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search a cinema',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.tune,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Category Filters
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategories.contains(category);
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (category == 'All') {
                            _selectedCategories = {'All'};
                          } else {
                            _selectedCategories.remove('All');
                            
                            if (isSelected) {
                              _selectedCategories.remove(category);
                              if (_selectedCategories.isEmpty) {
                                _selectedCategories.add('All');
                              }
                            } else {
                              _selectedCategories.add(category);
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFAC23A) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected ? null : Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Nearby Cinemas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cinema List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nearby Cinemas (first 5 items)
                    ..._getFilteredCinemas().take(5).map((cinema) {
                      final isFavourite = _favouriteCinemas.contains(cinema['name']);
                      return GestureDetector(
                        onTap: () => _addToRecent(cinema['name']!),
                        child: _CinemaCard(
                          name: cinema['name']!,
                          distance: cinema['distance']!,
                          logoType: cinema['logoType']!,
                          isFavourite: isFavourite,
                          onFavouriteToggle: () => _toggleFavourite(cinema['name']!),
                          showFavouriteButton: true,
                        ),
                      );
                    }).toList(),
                    
                    // All Cinemas section (only for All Cinemas tab)
                    if (_selectedTab == 0) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'All Cinemas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Remaining cinemas
                      ..._getFilteredCinemas().skip(5).map((cinema) {
                        final isFavourite = _favouriteCinemas.contains(cinema['name']);
                        return GestureDetector(
                          onTap: () => _addToRecent(cinema['name']!),
                          child: _CinemaCard(
                            name: cinema['name']!,
                            distance: cinema['distance']!,
                            logoType: cinema['logoType']!,
                            isFavourite: isFavourite,
                            onFavouriteToggle: () => _toggleFavourite(cinema['name']!),
                            showFavouriteButton: true,
                          ),
                        );
                      }).toList(),
                    ] else ...[
                      // For Favourite and Recents tabs, show all filtered cinemas
                      ..._getFilteredCinemas().map((cinema) {
                        final isFavourite = _favouriteCinemas.contains(cinema['name']);
                        return GestureDetector(
                          onTap: () => _addToRecent(cinema['name']!),
                          child: _CinemaCard(
                            name: cinema['name']!,
                            distance: cinema['distance']!,
                            logoType: cinema['logoType']!,
                            isFavourite: isFavourite,
                            onFavouriteToggle: () => _toggleFavourite(cinema['name']!),
                            showFavouriteButton: true,
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CinemaCard extends StatelessWidget {
  const _CinemaCard({
    required this.name,
    required this.distance,
    required this.logoType,
    required this.isFavourite,
    required this.onFavouriteToggle,
    this.showFavouriteButton = true,
  });

  final String name;
  final String distance;
  final String logoType; // 'major', 'icon', 'quartier', 'esplanade', 'krungsri_imax', 'paragon'
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;
  final bool showFavouriteButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getLogoColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: _buildLogo(),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Cinema Info
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
                Text(
                  distance,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showFavouriteButton) ...[
                GestureDetector(
                  onTap: onFavouriteToggle,
                  child: Icon(
                    isFavourite ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFAC23A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              const Icon(
                Icons.share_outlined,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLogoColor() {
    switch (logoType) {
      case 'major':
        return const Color(0xFF8B4513); // Brown
      case 'icon':
        return Colors.black;
      case 'quartier':
        return const Color(0xFF8A2BE2); // Purple
      case 'esplanade':
        return const Color(0xFF8A2BE2); // Purple
      case 'krungsri_imax':
        return const Color(0xFF2A2A2A); // Dark grey
      case 'paragon':
        return const Color(0xFFDC143C); // Red
      default:
        return const Color(0xFF2A2A2A);
    }
  }

  Widget _buildLogo() {
    switch (logoType) {
      case 'major':
        return Image.asset(
          'assets/Logo/Major.png',
          width: 30,
          height: 30,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'M',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 'icon':
        return const Text(
          'ICON\nCINECONIC',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'quartier':
        return const Text(
          'QUARTIER\nCINEART',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'esplanade':
        return const Text(
          'ESPLANADE\nCINEPLEX',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'krungsri_imax':
        return const Text(
          'KRUNGSRI\nIMAX',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'paragon':
        return const Text(
          'PARAGON\nCINEPLEX',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return const Icon(
          Icons.movie,
          color: Colors.white,
          size: 24,
        );
    }
  }
}

// Mock data
final List<Map<String, dynamic>> _mockCinemas = [
  {
    'name': 'Major Big C Suksawat',
    'distance': '4.37 km',
    'logoType': 'major',
    'features': ['IMAX', 'Kids'],
  },
];
