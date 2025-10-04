import 'package:flutter/material.dart';
import '../widgets/discount_card.dart';
import '../widgets/news_card.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({super.key});

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  int _selectedTab = 0; // 0 = Discounts, 1 = News

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                    'Discounts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Promotional Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A2BE2), Color(0xFFFF69B4), Color(0xFFFFD700)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Smartphone image placeholder
                      Container(
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Thai text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'คลิกแล้วได้ส่วนลดทันที 20 บาท*',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'ได้ส่วนลดเพิ่ม! M Gen Next ได้ส่วนลดเพิ่ม 10 บาท',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1 ต.ค. 2025 - 31 ต.ค. 2025',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            const Text(
                              'เฉพาะสาขาที่เข้าร่วม เมื่อซื้อตั๋วหนังผ่าน MAJOR APP',
                      style: TextStyle(
                        color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      left: _selectedTab == 0 ? 0 : MediaQuery.of(context).size.width / 2 - 32,
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
                                  'Discounts',
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
                            onTap: () => setState(() => _selectedTab = 1),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'News',
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
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Content Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: _selectedTab == 0 ? _buildDiscountsContent() : _buildNewsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerLogo(int index) {
    return Container(
      decoration: BoxDecoration(
        color: _getLogoColor(index),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: _buildLogoContent(index),
      ),
    );
  }

  Widget _buildLogoContent(int index) {
    switch (index) {
      case 0: // Major Cineplex
        return Image.asset(
          'assets/Logo/Major.png',
          width: 50,
          height: 50,
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
      case 1: // AIS
        return Image.asset(
          'assets/Logo/AIS.jpg',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'AIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 2: // Privilege Plus+
        return Image.asset(
          'assets/Logo/Privillege.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Privilege+',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 3: // Global House
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GLOBAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'House',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      case 4: // True
        return const Text(
          'tru',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      case 5: // Green (placeholder)
        return const Icon(
          Icons.local_activity,
          color: Colors.white,
          size: 30,
        );
      case 6: // AIA
        return Image.asset(
          'assets/Logo/AIA.jpg',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'AIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 7: // KBank
        return Image.asset(
          'assets/Logo/Kbank.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'KBank',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      case 8: // Krungthai Bank
        return Image.asset(
          'assets/Logo/Krungsri.jpg',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'กรุงไทย',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Bank',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        );
      case 9: // UOB
        return const Text(
          'UOB',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return const Text(
          '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  Color _getLogoColor(int index) {
    final colors = [
      const Color(0xFF8B4513), // Major - Brown
      const Color(0xFF00C851), // AIS - Green
      const Color(0xFF1E88E5), // Privilege+ - Blue
      const Color(0xFFFF6B35), // Global House - Orange
      const Color(0xFFE91E63), // True - Pink
      const Color(0xFF4CAF50), // Green
      const Color(0xFFD32F2F), // AIA - Red
      const Color(0xFF388E3C), // KBank - Green
      const Color(0xFF1976D2), // Krungthai - Blue
      const Color(0xFFD32F2F), // UOB - Red
      const Color(0xFF4CAF50), // Green2
      const Color(0xFF757575), // More - Grey
    ];
    return colors[index % colors.length];
  }

  Widget _buildDiscountsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Partner Logos Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildPartnerLogo(index);
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Discounts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Color(0xFFFAC23A),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Discount Cards List
        Column(
          children: const [
            DiscountCard(
              imagePath: 'assets/coupon/image17.jpg',
              title: 'IMAX with Laser',
              subtitle: 'Special Discount at Westgate Cineplex',
              discountAmount: '50',
              validUntil: '08 Oct, 2025',
            ),
            DiscountCard(
              imagePath: 'assets/coupon/image18.jpg',
              title: 'AIA Prestige Club',
              subtitle: 'PARAGON CINEPLEX / ICON CINECONIC / QUARTIER CINEART',
              discountAmount: '100',
              validUntil: '31 Dec, 2025',
            ),
            DiscountCard(
              imagePath: 'assets/coupon/image19.jpg',
              title: 'AIA Prestige Club',
              subtitle: 'Exclusive Benefits for Members',
              discountAmount: '150',
              validUntil: '31 Dec, 2025',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // News Cards List
        Column(
          children: const [
            NewsCard(
              imagePath: 'assets/movie/image1.jpg',
              title: 'M GEN ดู "รี่หยด3" 😱 3 ที่นั่งขึ้นไป มีสิทธิ์ลุ้นรับ!',
              description: 'กรอบรูปเสื้อพร้อม กระพรวนมงคล สุด Exclusive ✨ ดูหนังรี่หยด3 กับเพื่อนๆ 3 คนขึ้นไป ผ่าน Major App',
              timeAgo: '1 day ago',
            ),
            NewsCard(
              imagePath: 'assets/movie/image2.jpg',
              title: 'ซื้อบัตรชมภาพยนตร์เรื่อง "รี่หยด 3" และ "TRON"',
              description: 'รับ Exclusive Fan Art Mini Poster ฟรี! งานศิลปะสุดพิเศษจากหนังที่คุณชื่นชอบ',
              timeAgo: '3 days ago',
            ),
            NewsCard(
              imagePath: 'assets/movie/image3.jpg',
              title: '🔥 ล่าผี รี่หยด 3 ในไอแมกซ์ 🔥',
              description: 'ทุกที่นั่งรับของที่ระลึกพิเศษ เฉพาะรอบ IMAX Special Screening ที่กำหนดเท่านั้น',
              timeAgo: '3 days ago',
            ),
            NewsCard(
              imagePath: 'assets/movie/image4.jpg',
              title: '👻 บ้าน รี่หยด3 Bucket set ของมันต้องมี',
              description: 'เสียงเพรียกแห่งความสยองจาก รี่ หยด3 กำลังจะตามมาหลอกหลอนคุณ...',
              timeAgo: '3 days ago',
            ),
            NewsCard(
              imagePath: 'assets/movie/image5.jpg',
              title: 'ลุ้นตะลุยบ้านผีสิงรี่หยด ที่สิงคโปร์ 👻✈️🎢',
              description: 'เพียงซื้อตั๋วหนัง "รี่หยด 3" ตั้งแต่ 1 ที่นั่งขึ้นไปผ่าน Major App 📲',
              timeAgo: '3 days ago',
            ),
            NewsCard(
              imagePath: 'assets/movie/image6.jpg',
              title: '📢 กดปุ๊บ คุ้มปั๊บ! ลดทันที 20 บาท 🥰',
              description: 'ซื้อตั๋วหนังผ่าน Major App 📲 1 - 31 ตุลาคม 2568',
              timeAgo: '1 week ago',
            ),
          ],
        ),
      ],
    );
  }
}



