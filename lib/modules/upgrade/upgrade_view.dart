import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'upgrade_controller.dart';

class UpgradeView extends GetView<UpgradeController> {
  const UpgradeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: controller.goBack,
        ),
        title: const Text(
          'Upgrade to Premium',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Crown Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5A623), Color(0xFFFF6D00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'Unlock the Full Experience',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Get unlimited chimes, premium sounds, and advanced features to build better habits.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Features List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.all_inclusive,
                    title: 'Unlimited Chimes',
                    description: 'Create as many custom chimes as you want',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.music_note,
                    title: 'Premium Sounds',
                    description: 'Access to 50+ exclusive chime sounds',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.cloud_sync,
                    title: 'Cloud Sync',
                    description: 'Sync your chimes across all devices',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon:Icons.block,
                    title: 'No Ads',
                    description: 'Enjoy a completely ad-free experience',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.support_agent,
                    title: 'Priority Support',
                    description: 'Get faster response times for help',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pricing Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildPricingCard(
                    title: 'Monthly',
                    price: '\$4.99',
                    period: '/month',
                    isSelected: false,
                    onTap: () => controller.selectPlan('monthly'),
                  ),
                  const SizedBox(height: 16),
                  _buildPricingCard(
                    title: 'Yearly',
                    price: '\$39.99',
                    period: '/year',
                    isSelected: true,
                    onTap: () => controller.selectPlan('yearly'),
                    badge: 'SAVE 33%',
                  ),
                  const SizedBox(height: 16),
                  _buildPricingCard(
                    title: 'Lifetime',
                    price: '\$79.99',
                    period: 'one-time',
                    isSelected: false,
                    onTap: () => controller.selectPlan('lifetime'),
                    badge: 'BEST VALUE',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Upgrade Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.upgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Upgrade Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cancel anytime. No questions asked.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 32),

            // Terms
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.openTerms,
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: Color(0xFF2979FF),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: controller.openPrivacy,
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF2979FF),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C22),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFF5A623), size: 24),
        ),
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String period,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1C22) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2979FF) : const Color(0xFF2C2C3E),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2979FF) : Colors.white70,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.check_circle, color: Color(0xFF2979FF), size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
