import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'initial_more_screen.dart';
import 'main_shell.dart';
import 'account_management_screen.dart';
import 'ticket_screen.dart';
import '../services/auth_service.dart';

class MoreScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const MoreScreen({
    super.key,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Menu Items
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Account Management',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {
                  // Navigate to account management
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AccountManagementScreen(),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.confirmation_number_outlined,
                title: 'Ticket History',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {
                  // Navigate to ticket history
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TicketScreen(),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.credit_card_outlined,
                title: 'Saved Cards',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {
                  // Navigate to saved cards
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved Cards - Coming Soon')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.swap_horiz_outlined,
                title: 'Transaction History',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {
                  // Navigate to transaction history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction History - Coming Soon')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.language_outlined,
                title: 'Language',
                rightWidget: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ไทย | ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'ENG',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _MenuItem(
                icon: Icons.phone_outlined,
                title: 'Contact Us',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'FAQ',
                rightWidget: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              _MenuItem(
                icon: Icons.logout_outlined,
                title: 'Log Out',
                iconColor: Colors.red,
                textColor: Colors.red,
                rightWidget: null,
                onTap: () async {
                  // Sign out from Firebase
                  final authService = AuthService();
                  await authService.signOut();
                  
                  // Navigate to MainShell with More tab (InitialMoreScreen) and clear all previous routes
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainShell(initialIndex: 4), // More tab
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
              
              const SizedBox(height: 40),
              
              // App Information
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Major Cineplex',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Version 7.25.1-210',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _MajorCineplexLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Image.asset(
        'assets/Logo/Major.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to simple M logo if image fails to load
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAC23A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.rightWidget,
    this.rightWidget2,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final Widget? rightWidget;
  final Widget? rightWidget2;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor ?? const Color(0xFFFAC23A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor == Colors.red ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (rightWidget != null) rightWidget!,
                if (rightWidget2 != null) rightWidget2!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}





