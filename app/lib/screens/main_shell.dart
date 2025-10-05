import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'movies_screen.dart';
import 'cinemas_screen.dart';
import 'gifts_screen.dart';
import 'more_screen.dart';
import 'initial_more_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  
  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final PageController _pageController;
  bool _isLoggedIn = false;

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    // Start with logged out state for More tab
    _isLoggedIn = false;
    
    _updateTabs();
  }

  void _updateTabs() {
    _tabs = [
      HomeScreen(onScroll: _handleHomeScroll),
      const MoviesScreen(),
      const CinemasScreen(),
      const GiftsScreen(),
      _isLoggedIn 
          ? MoreScreen(onLogout: () => _setLoggedIn(false))
          : InitialMoreScreen(onLoginComplete: () => _setLoggedIn(true)),
    ];
  }


  void _setLoggedIn(bool loggedIn) {
    setState(() {
      _isLoggedIn = loggedIn;
      _updateTabs();
    });
    
    // If user just logged in, stay on More tab but show MoreScreen
    if (loggedIn && _currentIndex == 4) {
      print('✅ User logged in - staying on More tab with MoreScreen');
    }
  }

  double _homeScroll = 0.0;
  void _handleHomeScroll(double pixels) {
    setState(() => _homeScroll = pixels);
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
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
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: _currentIndex == 0,
              onTap: () => _onNavTap(0),
            ),
            // Movies
            _NavItem(
              icon: Icons.movie_outlined,
              label: 'Movies',
              isSelected: _currentIndex == 1,
              onTap: () => _onNavTap(1),
            ),
            // Cinema
            _NavItem(
              icon: Icons.location_on_outlined,
              label: 'Cinema',
              isSelected: _currentIndex == 2,
              onTap: () => _onNavTap(2),
            ),
            // Gifts
            _NavItem(
              icon: Icons.card_giftcard_outlined,
              label: 'Documents',
              isSelected: _currentIndex == 3,
              onTap: () => _onNavTap(3),
            ),
            // More
            _NavItem(
              icon: Icons.more_horiz,
              label: 'More',
              isSelected: _currentIndex == 4,
              onTap: () => _onNavTap(4),
            ),
          ],
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFAC23A) : Colors.grey,
              size: 24,
            ),
            // Show label only when selected
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFFAC23A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


