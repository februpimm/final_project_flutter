import 'package:flutter/material.dart';
import '../widgets/poster_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _selectedTab = 0; // 0 = Now Showing, 1 = Coming Soon
  Set<String> _selectedCategories = {'All'};

  final List<String> _categories = ['All', 'IMAX', '4DX', 'Screen X', 'Kids', 'LED'];

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
                    'Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Tabs
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
                      left: _selectedTab == 0 ? 0 : MediaQuery.of(context).size.width * 0.5 - 16,
                      top: 0,
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 2,
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
                            onTap: () => setState(() => _selectedTab = 0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Now Showing',
                                  style: TextStyle(
                                    color: _selectedTab == 0 ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTab = 1),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    color: _selectedTab == 1 ? Colors.black : Colors.white,
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
                            // If "All" is selected, clear other selections
                            _selectedCategories = {'All'};
                          } else {
                            // Remove "All" if it's selected and select specific category
                            _selectedCategories.remove('All');
                            
                            if (isSelected) {
                              // If already selected, deselect it
                              _selectedCategories.remove(category);
                              // If no categories selected, select "All"
                              if (_selectedCategories.isEmpty) {
                                _selectedCategories.add('All');
                              }
                            } else {
                              // If not selected, add it
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
            
            // Movie Grid
            Expanded(
              child: _selectedTab == 0 ? _NowShowingGrid() : _ComingSoonGrid(),
            ),
          ],
        ),
      ),
    );
  }
}


class _NowShowingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: _mockNowShowingMovies.length,
      itemBuilder: (context, index) {
        final movie = _mockNowShowingMovies[index];
        return _MovieCard(
          title: movie['title']!,
          genre: movie['genre']!,
          releaseDate: movie['releaseDate']!,
          imageUrl: movie['imageUrl']!,
          isTrending: movie['isTrending']!,
          technologies: movie['technologies']!,
        );
      },
    );
  }
}

class _ComingSoonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: _mockComingSoonMovies.length,
      itemBuilder: (context, index) {
        final movie = _mockComingSoonMovies[index];
        return _MovieCard(
          title: movie['title']!,
          genre: movie['genre']!,
          releaseDate: movie['releaseDate']!,
          imageUrl: movie['imageUrl']!,
          isTrending: false,
          technologies: movie['technologies']!,
        );
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.imageUrl,
    required this.isTrending,
    required this.technologies,
  });

  final String title;
  final String genre;
  final String releaseDate;
  final String imageUrl;
  final bool isTrending;
  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie Poster
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.white38, size: 40),
                        ),
                      );
                    },
                  ),
                  // TRENDING banner
                  if (isTrending)
                    Positioned(
                      top: 8,
                      right: -10,
                      child: Transform.rotate(
                        angle: 0.6,
                        child: Container(
                          width: 80,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAC23A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFFFAC23A),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'TRENDING',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Technology logos
        Row(
          children: technologies.map((tech) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              tech,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )).toList(),
        ),
        
        const SizedBox(height: 4),
        
        // Movie Title
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 2),
        
        // Genre
        Text(
          genre,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Release Date
        Text(
          releaseDate,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Mock data
final List<Map<String, dynamic>> _mockNowShowingMovies = [
  {
    'title': 'Tee Yod 3',
    'genre': 'Action · Horror',
    'releaseDate': '01 Oct 2025',
    'imageUrl': 'assets/now showing/image19.jpg',
    'isTrending': true,
    'technologies': ['IMAX', 'Dolby'],
  },
  {
    'title': 'Avatar The Way of Water RE',
    'genre': 'Action · Adventure',
    'releaseDate': '02 Oct 2025',
    'imageUrl': 'assets/now showing/image20.jpg',
    'isTrending': false,
    'technologies': ['3D', '4DX', 'IMAX'],
  },
  {
    'title': 'One Batt Another',
    'genre': 'Action · Crime',
    'releaseDate': '25 Sep 2025',
    'imageUrl': 'assets/now showing/image21.jpg',
    'isTrending': false,
    'technologies': ['4DX'],
  },
  {
    'title': 'The Last Kingdom',
    'genre': 'Drama · History',
    'releaseDate': '30 Sep 2025',
    'imageUrl': 'assets/now showing/image22.jpg',
    'isTrending': false,
    'technologies': ['LED'],
  },
  {
    'title': 'Epic Adventure',
    'genre': 'Fantasy · Adventure',
    'releaseDate': '05 Oct 2025',
    'imageUrl': 'assets/now showing/image23.jpg',
    'isTrending': false,
    'technologies': ['IMAX', '4DX'],
  },
  {
    'title': 'Thriller Night',
    'genre': 'Thriller · Mystery',
    'releaseDate': '08 Oct 2025',
    'imageUrl': 'assets/now showing/image24.jpg',
    'isTrending': false,
    'technologies': ['Screen X'],
  },
];

final List<Map<String, dynamic>> _mockComingSoonMovies = [
  {
    'title': 'Epic Adventure',
    'genre': 'Action · Sci-Fi',
    'releaseDate': '15 Oct 2025',
    'imageUrl': 'assets/movie/image.jpg',
    'isTrending': false,
    'technologies': ['IMAX', '4DX'],
  },
  {
    'title': 'Family Fun',
    'genre': 'Comedy · Family',
    'releaseDate': '20 Oct 2025',
    'imageUrl': 'assets/movie/image1.jpg',
    'isTrending': false,
    'technologies': ['Kids'],
  },
  {
    'title': 'Mystery Thriller',
    'genre': 'Thriller · Mystery',
    'releaseDate': '25 Oct 2025',
    'imageUrl': 'assets/movie/image2.jpg',
    'isTrending': false,
    'technologies': ['Screen X'],
  },
  {
    'title': 'Romantic Drama',
    'genre': 'Romance · Drama',
    'releaseDate': '30 Oct 2025',
    'imageUrl': 'assets/movie/image3.jpg',
    'isTrending': false,
    'technologies': ['LED'],
  },
  {
    'title': 'Action Hero',
    'genre': 'Action · Adventure',
    'releaseDate': '05 Nov 2025',
    'imageUrl': 'assets/movie/Image4.jpg',
    'isTrending': false,
    'technologies': ['IMAX', '4DX'],
  },
  {
    'title': 'Sci-Fi Journey',
    'genre': 'Sci-Fi · Fantasy',
    'releaseDate': '10 Nov 2025',
    'imageUrl': 'assets/movie/image5.jpg',
    'isTrending': false,
    'technologies': ['Screen X'],
  },
  {
    'title': 'Comedy Night',
    'genre': 'Comedy · Romance',
    'releaseDate': '15 Nov 2025',
    'imageUrl': 'assets/movie/image6.jpg',
    'isTrending': false,
    'technologies': ['LED'],
  },
  {
    'title': 'Horror Story',
    'genre': 'Horror · Thriller',
    'releaseDate': '20 Nov 2025',
    'imageUrl': 'assets/movie/image7.jpg',
    'isTrending': false,
    'technologies': ['4DX'],
  },
];



