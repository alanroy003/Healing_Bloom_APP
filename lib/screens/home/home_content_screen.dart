// healingbloom\lib\screens\home\home_content_screen.dart
import 'package:flutter/material.dart';
import 'package:healingbloom/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healingbloom/screens/skin_test/skin_test_screen.dart';
import 'package:healingbloom/screens/shop/product_list_screen.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTop = _scrollController.offset > 300;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: AppTheme.opulentLilac,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Section
              HeroSection(),

              // Features Section
              FeaturesSection(),

              // Reviews Section
              ReviewsSection(),

              // Footer Section
              FooterSection(),

              // Extra padding for bottom navigation bar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.85,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.opulentLilac.withAlpha(200),
            AppTheme.velvetAmethyst.withAlpha(150),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating petals background
          Positioned.fill(
            child: PetalBackground(),
          ),

          // Lottie animation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.3,
              child: _buildLottieAnimation(),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.opulentLilac.withAlpha(125),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: _buildAppLogo(),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // App Name
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      "Healing Bloom",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.pearlWhite,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(50),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tagline
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      "Your AI-Powered Skin Health Companion",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.pearlWhite,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(50),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // CTA Buttons
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Try Skin Scan Button
                        ElevatedButton.icon(
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SkinTestScreen(),
                                ),
                              );
                            } catch (e) {
                              _showErrorSnackBar(
                                  context, 'Could not open Skin Scan');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.royalPlum,
                            foregroundColor: AppTheme.pearlWhite,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: AppTheme.velvetAmethyst.withAlpha(125),
                          ),
                          icon: const Icon(Icons.spa_rounded),
                          label: const Text(
                            "🌼 Try Skin Scan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Shop Now Button
                        OutlinedButton.icon(
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductListScreen(),
                                ),
                              );
                            } catch (e) {
                              _showErrorSnackBar(
                                  context, 'Could not open Shop');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.pearlWhite,
                            side: BorderSide(
                              color: AppTheme.champagneGold,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text(
                            "🛒 Shop Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scroll cue
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 1500),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Scroll to discover",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.pearlWhite,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.pearlWhite,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    try {
      return SvgPicture.asset(
        'assets/icons/Logo.png',
        fit: BoxFit.contain,
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.pearlWhite,
        ),
        child: Icon(
          Icons.spa_rounded,
          size: 60,
          color: AppTheme.royalPlum,
        ),
      );
    }
  }

  Widget _buildLottieAnimation() {
    try {
      return Image.asset(
        'assets/icons/hero.png',
        fit: BoxFit.none,
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}

class PetalBackground extends StatelessWidget {
  const PetalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        20,
        (index) => Positioned(
          left: (index * 37) % MediaQuery.of(context).size.width,
          top: (index * 53) % MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: 0.2 + (index % 5) * 0.05,
            child: Transform.rotate(
              angle: (index * 0.2),
              child: Container(
                width: 20 + (index % 5) * 10,
                height: 20 + (index % 5) * 10,
                decoration: BoxDecoration(
                  color: [
                    AppTheme.velvetAmethyst.withAlpha(175),
                    AppTheme.opulentLilac.withAlpha(175),
                    AppTheme.champagneGold.withAlpha(175),
                    AppTheme.pearlWhite.withAlpha(175),
                  ][index % 4],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.search,
        'title': 'AI Skin Scan',
        'description': 'Analyze your skin condition with our advanced AI',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Dermatologist Chat',
        'description': 'Connect with certified skin specialists',
      },
      {
        'icon': Icons.recommend,
        'title': 'Product Recommender',
        'description': 'Get personalized skincare recommendations',
      },
      {
        'icon': Icons.upload_file,
        'title': 'Report Upload',
        'description': 'Securely store and manage your skin health records',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppTheme.pearlWhite,
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Text(
              "Discover Our Features",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              "Everything you need for your skin health journey",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: AppTheme.textColor.withAlpha(175),
              ),
            ),
          ),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: 200 * index),
                duration: const Duration(milliseconds: 600),
                child: GlassmorphicFeatureCard(
                  icon: features[index]['icon'] as IconData,
                  title: features[index]['title'] as String,
                  description: features[index]['description'] as String,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GlassmorphicFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const GlassmorphicFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<GlassmorphicFeatureCard> createState() =>
      _GlassmorphicFeatureCardState();
}

class _GlassmorphicFeatureCardState extends State<GlassmorphicFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppTheme.pearlWhite.withAlpha(225)
              : AppTheme.pearlWhite.withAlpha(175),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? AppTheme.velvetAmethyst.withAlpha(125)
                : AppTheme.lavenderMist.withAlpha(125),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppTheme.velvetAmethyst.withAlpha(50)
                  : Colors.black.withAlpha(12),
              blurRadius: _isHovered ? 15 : 10,
              spreadRadius: _isHovered ? 2 : 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.velvetAmethyst.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: AppTheme.velvetAmethyst,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppTheme.textColor.withAlpha(175),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'name': 'Sarah J.',
        'image': 'assets/images/profile.png',
        'review':
            'The AI skin analysis is incredibly accurate! It identified my skin concerns and recommended products that actually worked for me.',
      },
      {
        'name': 'Michael T.',
        'image': 'assets/images/profile.png',
        'review':
            "I've struggled with acne for years. Healing Bloom helped me understand my skin better and find the right treatment.",
      },
      {
        'name': 'Priya K.',
        'image': 'assets/images/profile.png',
        'review':
            'The personalized recommendations are spot on. My skin has never looked better!',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.pearlWhite,
            AppTheme.opulentLilac.withAlpha(25),
          ],
        ),
      ),
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Text(
              "What Our Users Say",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(
              reviews.length,
              (index) => FadeInUp(
                delay: Duration(milliseconds: 200 * index),
                duration: const Duration(milliseconds: 600),
                child: ReviewCard(
                  name: reviews[index]['name'] as String,
                  imagePath: reviews[index]['image'] as String,
                  review: reviews[index]['review'] as String,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String review;

  const ReviewCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 800
          ? 300
          : MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.pearlWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.velvetAmethyst.withAlpha(25),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppTheme.champagneGold.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Text(
                name,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppTheme.textColor.withAlpha(175),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 16,
                color: AppTheme.champagneGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    try {
      return CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(imagePath),
      );
    } catch (e) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.velvetAmethyst.withAlpha(50),
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.velvetAmethyst,
          ),
        ),
      );
    }
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: AppTheme.opulentLilac.withAlpha(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(context, "Terms of Service"),
              _buildDot(),
              _buildFooterLink(context, "Privacy Policy"),
              _buildDot(),
              _buildFooterLink(context, "Contact Us"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.facebook),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.camera_alt),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.video_library),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "© ${DateTime.now().year} Healing Bloom. All rights reserved.",
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppTheme.textColor.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String title) {
    return TextButton(
      onPressed: () {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $title')),
          );
        } catch (e) {
          _showErrorSnackBar(context, 'Could not navigate to $title');
        }
      },
      child: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 14,
          color: AppTheme.textColor.withAlpha(175),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "•",
        style: TextStyle(
          color: AppTheme.textColor.withAlpha(100),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.pearlWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: AppTheme.velvetAmethyst,
      ),
    );
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    debugPrint('Error showing snackbar: $e');
  }
}
