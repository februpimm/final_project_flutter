import 'package:flutter/material.dart';
import 'genre_selection_screen.dart';

class ExistingAccountScreen extends StatefulWidget {
  const ExistingAccountScreen({super.key});

  @override
  State<ExistingAccountScreen> createState() => _ExistingAccountScreenState();
}

class _ExistingAccountScreenState extends State<ExistingAccountScreen> {
  int? _selectedMembership;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Existing Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Instruction text
            const Text(
              'This number is registered with multiples existing membership. Please select which one you want to use.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            
            // Membership Cards
            Expanded(
              child: Column(
                children: [
                  // M GEN Student Card
                  _buildMembershipCard(
                    index: 0,
                    title: 'M GEN Student',
                    memberId: '7415911029484375',
                    logoColor: const Color(0xFFE91E63), // Pink/light red
                  ),
                  const SizedBox(height: 16),
                  
                  // M GEN Next Premium Card
                  _buildMembershipCard(
                    index: 1,
                    title: 'M GEN Next Premium',
                    memberId: '991490211271200013',
                    logoColor: const Color(0xFF00BCD4), // Teal/light blue
                  ),
                  
                  const Spacer(),
                  
                  // Continue Button
                  if (_selectedMembership != null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to genre selection screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const GenreSelectionScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipCard({
    required int index,
    required String title,
    required String memberId,
    required Color logoColor,
  }) {
    bool isSelected = _selectedMembership == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMembership = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: const Color(0xFFFFD700), width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Logo section
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: logoColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'GENERATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Details section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    memberId,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFFD700),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
