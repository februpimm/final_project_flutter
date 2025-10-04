import 'package:flutter/material.dart';

import '../widgets/section_header.dart';
import '../widgets/poster_card.dart';
import '../widgets/discount_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onScroll});

  final ValueChanged<double>? onScroll;


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (onScroll != null && n.metrics.axis == Axis.vertical) {
            onScroll!(n.metrics.pixels);
          }
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/Logo/Major.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.movie_filter_rounded, color: colorScheme.primary);
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text('Now showing', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28)),
                  const Spacer(),
                  const Icon(Icons.qr_code_2_rounded),
                  const SizedBox(width: 16),
                  const Icon(Icons.confirmation_num_outlined),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_outline),
                ],
              ),
            ),
            // Now showing snapping carousel
            _NowShowingCarousel(items: _mockNowShowing),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: Color(0xFF232323),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFFAC23A),
                          child: Text('M', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Explore Privileges', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 2),
                              Text(
                                'Discover an exclusive cinema entertainment experience',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Discounts', trailingText: 'View All'),
            SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => DiscountCard(
                  imagePath: _mockDiscounts[index].imagePath,
                  title: _mockDiscounts[index].title,
                  subtitle: _mockDiscounts[index].subtitle,
                  discountAmount: _mockDiscounts[index].discountAmount,
                  validUntil: _mockDiscounts[index].validUntil,
                ),
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemCount: _mockDiscounts.length,
              ),
            ),

            const SizedBox(height: 16),
            const SectionHeader(title: 'Coming soon'),
            const SizedBox(height: 16),
            // Coming Soon Movies
            SizedBox(
              height: 250,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _ComingSoonCard(
                  movie: _mockComingSoon[index],
                  isFirst: index == 0,
                ),
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemCount: _mockComingSoon.length,
              ),
            ),
            const SizedBox(height: 20),
            
            // Latest Technology Section (moved to bottom)
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Latest technology',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            // Technology Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: const [
                  _TechCard(
                    title: 'IMAX®',
                    subtitle: '',
                    color: Color(0xFF0070F3),
                    type: TechCardType.imax,
                  ),
                  _TechCard(
                    title: '4DX',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.normal,
                  ),
                  _TechCard(
                    title: 'DOLBY ATMOS®',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.dolby,
                  ),
                  _TechCard(
                    title: 'Kids cinema',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.kids,
                  ),
                  _TechCard(
                    title: 'GLS',
                    subtitle: 'GIANT LASER SCREEN',
                    color: Color(0xFF9C27B0),
                    type: TechCardType.gls,
                  ),
                  _TechCard(
                    title: 'SCREENX',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.normal,
                  ),
                  _TechCard(
                    title: 'LASERPLEX',
                    subtitle: 'TOTAL LASER PROJECTOR',
                    color: Colors.white,
                    type: TechCardType.normal,
                  ),
                  _TechCard(
                    title: 'LED CINEMA',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.normal,
                  ),
                  _TechCard(
                    title: 'VIP CINEMA',
                    subtitle: '',
                    color: Colors.white,
                    type: TechCardType.vip,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _NowShowingCarousel extends StatefulWidget {
  const _NowShowingCarousel({required this.items});
  final List<_MovieItem> items;

  @override
  State<_NowShowingCarousel> createState() => _NowShowingCarouselState();
}

class _NowShowingCarouselState extends State<_NowShowingCarousel> {
  late final PageController _controller;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.55);
    _controller.addListener(() {
      setState(() => _currentPage = _controller.page ?? 0);
    });
  }

  @override
  void didChangeDependencies() {
    // Precache local asset images to avoid blank while loading, especially on web
    for (final m in widget.items) {
      if (m.imageUrl.startsWith('assets/')) {
        precacheImage(AssetImage(m.imageUrl), context);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // PageView uses viewportFraction 0.55, so estimate card width from that
    final cardWidth = screenWidth * 0.55;
    final posterHeight = cardWidth * 1.5; // aspectRatio 2:3 => h = 1.5 * w
    final totalHeight = posterHeight + 60; // include title/subtitle/padding

    return SizedBox(
      height: totalHeight,
      child: PageView.builder(
        controller: _controller,
        padEnds: false,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final progress = (index - _currentPage).abs().clamp(0.0, 1.0);
          final scale = 1 - (progress * 0.06);
          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: 8,
              ),
              child: PosterCard(
                width: cardWidth,
                title: widget.items[index].title,
                subtitle: widget.items[index].subtitle,
                imageUrl: widget.items[index].imageUrl,
                isTrending: index == 0,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MovieItem {
  const _MovieItem({required this.title, required this.subtitle, required this.imageUrl});
  final String title;
  final String subtitle;
  final String imageUrl;
}

class _DiscountItem {
  const _DiscountItem({
    required this.title, 
    required this.subtitle, 
    required this.imagePath,
    required this.discountAmount,
    required this.validUntil,
  });
  final String title;
  final String subtitle;
  final String imagePath;
  final String discountAmount;
  final String validUntil;
}


class _ComingSoonItem {
  const _ComingSoonItem({
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.imagePath,
  });
  final String title;
  final String genre;
  final String releaseDate;
  final String imagePath;
}

const List<_MovieItem> _mockNowShowing = [
  _MovieItem(
    title: 'How to make millions before grandma dies',
    subtitle: 'Drama  •  01 Oct 2025',
    imageUrl: 'assets/now showing/image19.jpg',
  ),
  _MovieItem(
    title: 'The paradise of thorns',
    subtitle: 'Drama  •  02 Oct 2025',
    imageUrl: 'assets/now showing/image20.jpg',
  ),
  _MovieItem(
    title: 'You & Me & Me',
    subtitle: 'Drama · Comedy  •  9 February 2025',
    imageUrl: 'assets/now showing/image21.jpg',
  ),
  _MovieItem(
    title: 'น้องพี่ที่รัก',
    subtitle: 'Drama · Comedy  •  10 May 2025',
    imageUrl: 'assets/now showing/image22.jpg',
  ),
  _MovieItem(
    title: 'Tee Yod 2',
    subtitle: 'Drama · Horror  •  10 October 2025',
    imageUrl: 'assets/now showing/image23.jpg',
  ),
  _MovieItem(
    title: 'ฮาวทูทิ้ง',
    subtitle: 'Drama · Horror  •  26 December 2025',
    imageUrl: 'assets/now showing/image24.jpg',
  ),
];

const List<_DiscountItem> _mockDiscounts = [
  _DiscountItem(
    title: 'IMAX with Laser', 
    subtitle: 'Special Discount at Westgate Cineplex', 
    imagePath: 'assets/coupon/image17.jpg',
    discountAmount: '50',
    validUntil: '08 Oct, 2025',
  ),
  _DiscountItem(
    title: 'Kids Cinema', 
    subtitle: 'Seacon Cineplex', 
    imagePath: 'assets/coupon/image18.jpg',
    discountAmount: '50',
    validUntil: '31 Dec, 2025',
  ),
  _DiscountItem(
    title: 'AIA Prestige Club', 
    subtitle: 'Exclusive Benefits for Members', 
    imagePath: 'assets/coupon/image19.jpg',
    discountAmount: '150',
    validUntil: '31 Dec, 2025',
  ),
];

const List<_ComingSoonItem> _mockComingSoon = [
  _ComingSoonItem(
    title: 'Tron Ares',
    genre: 'Action · Adventure',
    releaseDate: '09 Oct 2025',
    imagePath: 'assets/coming soon/image 8.jpg',
  ),
  _ComingSoonItem(
    title: 'G DRAGON IN CINEMA Ubermensch',
    genre: 'Musical',
    releaseDate: '29 Oct 2025',
    imagePath: 'assets/coming soon/image 9.jpg',
  ),
  _ComingSoonItem(
    title: '4 Tigers',
    genre: 'Action · Crime',
    releaseDate: '23 Oct 2025',
    imagePath: 'assets/coming soon/image10.jpg',
  ),
  _ComingSoonItem(
    title: 'The Last Samurai 2',
    genre: 'Action · Drama',
    releaseDate: '15 Nov 2025',
    imagePath: 'assets/coming soon/image12.jpg',
  ),
];

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({required this.movie, required this.isFirst});
  final _ComingSoonItem movie;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isFirst ? null : Border.all(
                color: const Color(0xFFFAC23A),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Movie Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    movie.imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Advance Ticket Banner (only for first movie)
                if (isFirst)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAC23A),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'ADVANCE TICKET',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                // IMAX Banner at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'IMAX 4DX SCREEN X Dolby',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Movie Title
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Genre
          Text(
            movie.genre,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 1),
          // Release Date
          Text(
            movie.releaseDate,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

enum TechCardType { normal, imax, dolby, kids, gls, vip }

class _TechCard extends StatelessWidget {
  const _TechCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.type,
  });

  final String title;
  final String subtitle;
  final Color color;
  final TechCardType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (type == TechCardType.kids) ...[
              // Kids cinema with special styling
              Column(
                children: [
                  Text(
                    'Kids',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'cinema',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ] else if (type == TechCardType.vip) ...[
              // VIP CINEMA with gradient styling
              Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
                    ).createShader(bounds),
                    child: Text(
                      'VIP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'CINEMA',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ] else if (type == TechCardType.gls) ...[
              // GLS with gradient styling
              Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF69B4), Color(0xFF9C27B0)],
                    ).createShader(bounds),
                    child: Text(
                      'GLS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ] else if (type == TechCardType.dolby) ...[
              // DOLBY ATMOS with special D styling
              Text(
                'DOLBY ATMOS®',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              // Regular tech cards
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: title.length > 8 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}


