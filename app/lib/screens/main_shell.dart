import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'movies_screen.dart';
import 'gifts_screen.dart';
import 'more_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final PageController _pageController;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _tabs = [
      HomeScreen(onScroll: _handleHomeScroll),
      const MoviesScreen(),
      const GiftsScreen(),
      const MoreScreen(),
    ];
  }

  double _homeScroll = 0.0;
  void _handleHomeScroll(double pixels) {
    setState(() => _homeScroll = pixels);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          _pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.movie_outlined), selectedIcon: Icon(Icons.movie), label: 'Movies'),
          NavigationDestination(icon: Icon(Icons.card_giftcard_outlined), selectedIcon: Icon(Icons.card_giftcard), label: 'Gifts'),
          NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _FastBookingButton(progress: (_homeScroll / 120).clamp(0.0, 1.0)),
    );
  }
}

class _FastBookingButton extends StatelessWidget {
  const _FastBookingButton({required this.progress});
  // 0.0 = extended, 1.0 = small circular
  final double progress;

  @override
  Widget build(BuildContext context) {
    // Match the smaller reference size (right image)
    const double extendedWidth = 168.0;
    const double height = 40.0;
    final width = lerpDouble(extendedWidth as double, height, progress)!;
    final borderRadius = BorderRadius.circular(height / 2);
    final showLabelOpacity = (1 - progress).clamp(0.0, 1.0);

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        width: width > MediaQuery.of(context).size.width - 32
            ? MediaQuery.of(context).size.width - 32
            : width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFFAC23A),
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 8)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: Colors.black, size: 18),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  opacity: showLabelOpacity,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Fast Booking', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


