import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_controller.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color, size: 28),
          onPressed: controller.goBack,
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumBanner(),
            const SizedBox(height: 24),
            _buildSectionHeader('General Settings',context),
            const SizedBox(height: 8),
            _buildSettingsCard(
              children: [
                _buildChevronRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  context: context,
                  trailingWidget: Obx(() => Text(
                    // ✅ Read from ThemeController directly, not SettingsController
                    Get.find<ThemeController>().themeModeString.value,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54) ?? Colors.white54, fontSize: 16),
                  )),
                  onTap: controller.openThemeSettings,
                ),
              ],
              context: context
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Sound Settings',context),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context: context,
              children: [
                _buildToggleRow(
                  icon: Icons.volume_off_outlined,
                  title: 'Chime in Silent Mode',
                  obsValue: controller.soundEnabled,
                  onChanged: controller.toggleSound,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.timer_outlined,
                  title: 'Quiet Hours',
                  trailingWidget: Obx(() => Text(
                    controller.quietHoursEnabled.value
                        ? '${controller.formatTime(controller.quietHoursStartHour.value, controller.quietHoursStartMinute.value, controller.quietHoursStartIsPM.value)} to ${controller.formatTime(controller.quietHoursEndHour.value, controller.quietHoursEndMinute.value, controller.quietHoursEndIsPM.value)}'
                        : 'Off',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54) ?? Colors.white54, fontSize: 16),
                  )),
                  onTap: controller.openQuietHours,
                  context: context,
                ),
                _buildDivider(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.volume_up_outlined, color: Theme.of(context).iconTheme.color, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Volume',
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16),
                            ),
                          ),
                          Obx(() => Text(
                            '${(controller.volume.value * 100).round()}%',
                            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54) ?? Colors.white54, fontSize: 16),
                          )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Obx(() => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF2979FF),
                          inactiveTrackColor: const Color(0xFF2C2C3E),
                          thumbColor: const Color(0xFF2979FF),
                          overlayColor: const Color(0x292979FF),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: controller.volume.value,
                          min: 0,
                          max: 1,
                          onChanged: controller.setVolume,
                        ),
                      )),
                    ],
                  ),
                ),
                _buildDivider(context),
                _buildToggleRow(
                  icon: Icons.music_note_outlined,
                  title: 'Chime over music',
                  obsValue: controller.chimeOverMusic,
                  onChanged: controller.toggleChimeOverMusic,
                  context: context,
                ),
                _buildDivider(context),
                _buildToggleRow(
                  icon: Icons.phone_outlined,
                  title: 'Chime during calls',
                  obsValue: controller.chimeDuringCalls,
                  onChanged: controller.toggleChimeDuringCalls,
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notification Settings Section
            _buildSectionHeader('Notification Settings',context),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context: context,
              children: [
                _buildToggleRow(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  obsValue: controller.notificationsEnabled,
                  onChanged: controller.toggleNotifications,
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // About Us Section
            _buildSectionHeader('About Us',context),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context: context,
              children: [
                _buildChevronRow(
                  icon: Icons.feedback_outlined,
                  title: 'Feedback',
                  onTap: controller.openFeedback,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.apps_outlined,
                  title: 'Our Apps',
                  onTap: controller.openOurApps,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.star_outline,
                  title: 'Rate Hourly Chime',
                  onTap: controller.rateApp,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: controller.shareApp,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: controller.openPrivacyPolicy,
                  context: context,
                ),
                _buildDivider(context),
                _buildChevronRow(
                  icon: Icons.check_box_outlined,
                  title: 'Version',
                  trailingText: '1.4.5',
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return GestureDetector(
      onTap: controller.openPremium,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF5A623), Color(0xFFFF6D00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6D00),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock the Full Experience',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'More Chimes, More Sounds, Build More Habits.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
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

  Widget _buildSectionHeader(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.38) ?? Colors.white38,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children, required BuildContext context}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor ?? const Color(0xFF2C2C3E),
      height: 1,
      indent: 50,
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required RxBool obsValue,
    required Function(bool) onChanged,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).iconTheme.color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16),
            ),
          ),
          Obx(() => Switch(
            value: obsValue.value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
            inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
            inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
          )),
        ],
      ),
    );
  }

  Widget _buildChevronRow({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16),
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.38) ?? Colors.white38, fontSize: 14),
              ),
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.24) ?? Colors.white24, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}