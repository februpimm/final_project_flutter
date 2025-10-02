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
                  Icon(Icons.movie_filter_rounded, color: colorScheme.primary),
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
                ),
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemCount: _mockDiscounts.length,
              ),
            ),

            const SizedBox(height: 16),
            const SectionHeader(title: 'Coming soon'),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // ฟังก์ชัน fast booking
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFFFAC23A),
                      padding: const EdgeInsets.all(12),
                      elevation: 4,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.black, size: 28),
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
    _controller = PageController(viewportFraction: 0.72);
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
    // PageView uses viewportFraction 0.72, so estimate card width from that
    final cardWidth = screenWidth * 0.72;
    final posterHeight = cardWidth * 1.5; // aspectRatio 2:3 => h = 1.5 * w
    final totalHeight = posterHeight + 72; // include title/subtitle/padding

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
  const _DiscountItem({required this.title, required this.subtitle, required this.imagePath});
  final String title;
  final String subtitle;
  final String imagePath;
}

const List<_MovieItem> _mockNowShowing = [
  _MovieItem(
    title: 'Tee Yod 3',
    subtitle: 'Action · Horror  •  01 Oct 2025',
    imageUrl: 'assets/image.jpg',
  ),
  _MovieItem(
    title: 'Avatar The Way of Water RE',
    subtitle: 'Action · Adventure  •  02 Oct 2025',
    imageUrl: 'assets/image1.jpg',
  ),
  _MovieItem(
    title: 'One Battle Another',
    subtitle: 'Action · Comedy  •  25 Sep 2025',
    imageUrl: 'assets/image2.jpg',
  ),
  _MovieItem(
    title: 'Feature Film 4',
    subtitle: 'Adventure · Fantasy',
    imageUrl: 'assets/image3.jpg',
  ),
  _MovieItem(
    title: 'Feature Film 5',
    subtitle: 'Sci‑Fi · IMAX',
    imageUrl: 'assets/Image4.jpg',
  ),
  _MovieItem(
    title: 'Feature Film 6',
    subtitle: 'Drama',
    imageUrl: 'assets/image5.jpg',
  ),
  _MovieItem(
    title: 'Feature Film 7',
    subtitle: 'Comedy',
    imageUrl: 'assets/image6.jpg',
  ),
  _MovieItem(
    title: 'Feature Film 8',
    subtitle: 'Thriller',
    imageUrl: 'assets/image7.jpg',
  ),
];

const List<_DiscountItem> _mockDiscounts = [
  _DiscountItem(title: 'IMAX with Laser 50 THB', subtitle: 'Valid until 08 Oct 2025', imagePath: 'assets/coupon/image17.png'),
  _DiscountItem(title: 'M Coupon 10% OFF', subtitle: 'For members only', imagePath: 'assets/coupon/image18.png'),
  _DiscountItem(title: 'Snack Combo 20% OFF', subtitle: 'Weekends only', imagePath: 'assets/coupon/image19.png'),
];


