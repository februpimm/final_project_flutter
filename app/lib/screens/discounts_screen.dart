import 'package:flutter/material.dart';

import '../widgets/discount_card.dart';

class DiscountsScreen extends StatelessWidget {
  const DiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Discounts title and View All button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discounts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to home screen with smooth transition
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Discount Cards List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
          const DiscountCard(
            imagePath: 'assets/coupon/image17.jpg',
            title: 'IMAX with Laser',
            subtitle: 'Special Discount at Westgate Cineplex',
            discountAmount: '50',
            validUntil: '08 Oct, 2025',
          ),
          const SizedBox(height: 24),
          const DiscountCard(
            imagePath: 'assets/coupon/image18.jpg',
            title: 'AIA Prestige Club',
            subtitle: 'PARAGON CINEPLEX / ICON CINECONIC / QUARTIER CINEART',
            discountAmount: '100',
            validUntil: '31 Dec, 2025',
          ),
          const SizedBox(height: 24),
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
            ),
          ],
        ),
      ),
    );
  }

}
