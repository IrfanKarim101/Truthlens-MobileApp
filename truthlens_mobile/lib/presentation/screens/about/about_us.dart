import 'package:flutter/material.dart';
import 'dart:ui';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
                Colors.purple.withOpacity(0.3),
                Colors.purple.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Truthlens',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Fighting misinformation',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TruthLens Logo Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.lightBlueAccent,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.purpleAccent.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.shield_outlined,
                                      color: Colors.purpleAccent.shade100,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Truth',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'lens',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.lightBlueAccent,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Advanced deepfake detection technology\nfor images and videos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Our Mission Section
                    _buildSectionHeader('Our Mission', Icons.flag_outlined),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'TruthLens is dedicated to combating the spread of deepfake content by providing cutting-edge detection technology. We aim to help users verify the authenticity of digital media and protect against misinformation.',
                    ),

                    const SizedBox(height: 24),

                    // Key Features Section
                    _buildSectionHeader('Key Features', Icons.star_outline),
                    const SizedBox(height: 12),

                    _buildFeatureItem(
                      icon: Icons.speed_outlined,
                      iconColor: Colors.lightBlueAccent,
                      title: 'Fast Analysis',
                      description:
                          'Get results within seconds with our optimized AI models',
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureItem(
                      icon: Icons.verified_outlined,
                      iconColor: Colors.purpleAccent.shade100,
                      title: 'High Accuracy',
                      description:
                          'State-of-the-art algorithms for detecting deepfakes',
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureItem(
                      icon: Icons.perm_media_outlined,
                      iconColor: Colors.lightBlueAccent,
                      title: 'Multiple Formats',
                      description:
                          'Supports both images (JPG, PNG) and videos (MP4, MOV)',
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureItem(
                      icon: Icons.security_outlined,
                      iconColor: Colors.purpleAccent.shade100,
                      title: 'Privacy-Focused',
                      description:
                          'Your data is analyzed securely with complete confidentiality',
                    ),

                    const SizedBox(height: 24),

                    // Technology Section
                    _buildSectionHeader('Technology', Icons.code_outlined),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'TruthLens employs advanced deep learning algorithms and neural networks. Our platform analyzes facial landmarks, skin texture, eye movements, and temporal patterns to detect manipulated content with high precision.',
                    ),

                    const SizedBox(height: 16),

                    // Statistics
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            value: '98%',
                            label: 'Accuracy Rate',
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            value: '<3s',
                            label: 'Avg. Analysis Time',
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Our Team Section
                    _buildSectionHeader('Our Team', Icons.groups_outlined),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'TruthLens is developed by a team of AI researchers, computer vision experts, and cybersecurity professionals dedicated to fighting misinformation.',
                    ),

                    const SizedBox(height: 24),

                    // Contact Us Section
                    _buildSectionHeader('Contact Us', Icons.email_outlined),
                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildContactItem(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                value: 'irfan.karimie@gmail.com',
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: Colors.white.withOpacity(0.1),
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                icon: Icons.language_outlined,
                                label: 'Website',
                                value: 'www.truthlens.ai',
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: Colors.white.withOpacity(0.1),
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                icon: Icons.alternate_email,
                                label: 'Twitter',
                                value: '@truthlens_ai',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Version 1.0.0 • © 2025 TruthLens',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.lightBlueAccent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.lightBlueAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
