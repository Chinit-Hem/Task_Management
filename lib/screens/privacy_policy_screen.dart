import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy Matters',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: February 22, 2026',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            _buildSection(
              title: 'Introduction',
              content:
                  'Task Manager ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),

            // Information We Collect
            _buildSection(
              title: 'Information We Collect',
              content: 'We collect the following types of information:',
              bulletPoints: [
                'Personal Information: Name, email address, phone number, and profile photo',
                'Task Data: Task titles, descriptions, priorities, due dates, and categories',
                'Usage Data: How you interact with the app, features used, and time spent',
                'Device Information: Device type, operating system, and app version',
                'Location Data: Only if you enable location services for task reminders',
              ],
            ),

            // How We Use Your Information
            _buildSection(
              title: 'How We Use Your Information',
              content: 'We use your information to:',
              bulletPoints: [
                'Provide and maintain our task management services',
                'Send notifications and reminders for your tasks',
                'Improve and personalize your app experience',
                'Analyze usage patterns to enhance app features',
                'Communicate with you about updates and support',
                'Ensure security and prevent fraudulent activity',
              ],
            ),

            // Data Storage
            _buildSection(
              title: 'Data Storage & Security',
              content:
                  'Your data is stored securely using industry-standard encryption. Task data is primarily stored locally on your device using Isar database. If you enable cloud backup, your data is encrypted and stored on our secure servers.',
              bulletPoints: [
                'Local data is protected by your device security',
                'Cloud backups use AES-256 encryption',
                'We never sell your personal information',
                'Data retention: We keep your data until you delete your account',
              ],
            ),

            // Your Rights
            _buildSection(
              title: 'Your Rights',
              content: 'You have the following rights regarding your data:',
              bulletPoints: [
                'Access: View all data we have about you',
                'Correction: Update or correct your information',
                'Deletion: Delete your account and all associated data',
                'Export: Download a copy of your data',
                'Opt-out: Disable data collection features',
              ],
            ),

            // Third Party Services
            _buildSection(
              title: 'Third-Party Services',
              content:
                  'We may use third-party services for analytics and crash reporting. These services have their own privacy policies:',
              bulletPoints: [
                'Google Analytics for app usage statistics',
                'Firebase for push notifications',
                'Google Play Services for app distribution',
              ],
            ),

            // Children's Privacy
            _buildSection(
              title: "Children's Privacy",
              content:
                  'Our app is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you are a parent and believe your child has provided us with personal information, please contact us.',
            ),

            // Changes to Policy
            _buildSection(
              title: 'Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the "Last updated" date. Your continued use of the app after changes constitutes acceptance of the new policy.',
            ),

            // Contact Us
            _buildSection(
              title: 'Contact Us',
              content:
                  'If you have any questions about this Privacy Policy or our data practices, please contact us:',
              bulletPoints: [
                'Email: privacy@taskmanager.com',
                'Address: Phnom Penh, Cambodia',
                'Phone: +855 123 456 789',
                'Data Protection Officer: Chinit Hem',
              ],
            ),

            const SizedBox(height: 24),

            // Agreement Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Do you agree to our Privacy Policy?',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please review the policy carefully before continuing'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Thank you for agreeing to our Privacy Policy'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('I Agree'),
                        ),
                      ),
                    ],
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

  Widget _buildSection({
    required String title,
    required String content,
    List<String>? bulletPoints,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          if (bulletPoints != null) ...[
            const SizedBox(height: 12),
            ...bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
