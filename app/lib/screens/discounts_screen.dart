import 'package:flutter/material.dart';

import '../widgets/discount_card.dart';

class DiscountsScreen extends StatelessWidget {
  const DiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'All Discounts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reset functionality
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Color(0xFFFF9800),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Discount Cards List - Direct display without section headers
          const SizedBox(height: 16),
          const DiscountCard(
            imagePath: 'assets/coupon/image17.jpg',
            title: 'IMAX with Laser',
            subtitle: 'Special Discount at Westgate Cineplex',
            discountAmount: '50',
            validUntil: '08 Oct, 2025',
          ),
          const SizedBox(height: 16),
          const DiscountCard(
            imagePath: 'assets/coupon/image18.jpg',
            title: 'Kids Cinema',
            subtitle: 'Seacon Cineplex',
            discountAmount: '50',
            validUntil: '31 Dec, 2025',
          ),
          const SizedBox(height: 16),
          const DiscountCard(
            imagePath: 'assets/coupon/image19.jpg',
            title: 'AIA Prestige Club',
            subtitle: 'Exclusive Benefits for Members',
            discountAmount: '150',
            validUntil: '31 Dec, 2025',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}
