import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_bloc.dart';

class EnhancedMenuDrawer extends StatefulWidget {
  final VoidCallback onLogout;

  const EnhancedMenuDrawer({
    super.key,
    required this.onLogout,
  });

  @override
  State<EnhancedMenuDrawer> createState() => _EnhancedMenuDrawerState();
}

class _EnhancedMenuDrawerState extends State<EnhancedMenuDrawer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations when drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkMode = state is ThemeLoaded ? state.isDarkMode : false;
        
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A1D23),
                        const Color(0xFF0A0E13),
                        const Color(0xFF2A2D37),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1976D2),
                        const Color(0xFF1565C0),
                        const Color(0xFF0D47A1),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Enhanced Header Section
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Animated Logo with glow effect
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: isDarkMode
                                      ? [
                                          const Color(0xFF64B5F6).withOpacity(0.8),
                                          const Color(0xFF42A5F5).withOpacity(0.6),
                                          const Color(0xFF2196F3).withOpacity(0.4),
                                        ]
                                      : [
                                          Colors.white.withOpacity(0.9),
                                          Colors.white.withOpacity(0.7),
                                          Colors.white.withOpacity(0.5),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode 
                                        ? const Color(0xFF64B5F6).withOpacity(0.4)
                                        : Colors.white.withOpacity(0.6),
                                    blurRadius: 20 * _pulseAnimation.value,
                                    spreadRadius: 8 * _pulseAnimation.value,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.currency_exchange_rounded,
                                size: 50,
                                color: isDarkMode 
                                    ? const Color(0xFF0A0E13)
                                    : const Color(0xFF1976D2),
                              ),
                            );
                          },
                        ).animate()
                            .fadeIn(duration: const Duration(milliseconds: 800))
                            .scale(duration: const Duration(milliseconds: 800)),
                        
                        const SizedBox(height: 24),
                        
                        // App Title with shimmer effect
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isDarkMode
                                ? [
                                    const Color(0xFF64B5F6),
                                    const Color(0xFFE3F2FD),
                                    const Color(0xFF64B5F6),
                                  ]
                                : [
                                    Colors.white,
                                    Colors.white.withOpacity(0.8),
                                    Colors.white,
                                  ],
                          ).createShader(bounds),
                          child: const Text(
                            'Currency Converter',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ).animate()
                            .fadeIn(duration: const Duration(milliseconds: 1000), delay: const Duration(milliseconds: 300))
                            .slideY(begin: 0.5, duration: const Duration(milliseconds: 1000)),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle with typing effect
                        Text(
                          'Beautiful • Fast • Reliable',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode 
                                ? const Color(0xFFB0BEC5)
                                : Colors.white.withOpacity(0.9),
                            letterSpacing: 1.2,
                          ),
                        ).animate()
                            .fadeIn(duration: const Duration(milliseconds: 1200), delay: const Duration(milliseconds: 600))
                            .slideY(begin: 0.5, duration: const Duration(milliseconds: 1200)),
                      ],
                    ),
                  ),
                  
                  // Content Area with glassmorphism effect
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode 
                            ? const Color(0xFF0A0E13).withOpacity(0.8)
                            : Colors.white.withOpacity(0.95),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                        child: Column(
                          children: [
                            // Enhanced Theme Toggle
                            AnimatedBuilder(
                              animation: _slideAnimation,
                              child: _buildEnhancedThemeToggle(isDarkMode),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_slideAnimation.value * 150, 0),
                                  child: child,
                                );
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Glowing Divider
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDarkMode
                                      ? [
                                          Colors.transparent,
                                          const Color(0xFF64B5F6).withOpacity(0.6),
                                          Colors.transparent,
                                        ]
                                      : [
                                          Colors.transparent,
                                          const Color(0xFF1976D2).withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                ),
                              ),
                            ).animate()
                                .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 1000))
                                .scaleX(duration: const Duration(milliseconds: 800)),
                            
                            const SizedBox(height: 32),
                            
                            // Menu Items with enhanced animations
                            ..._buildMenuItems(isDarkMode),
                            
                            const Spacer(),
                            
                            // Enhanced Logout
                            AnimatedBuilder(
                              animation: _slideAnimation,
                              child: _buildEnhancedLogoutButton(isDarkMode),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_slideAnimation.value * 150, 0),
                                  child: child,
                                );
                              },
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedThemeToggle(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? LinearGradient(
                colors: [
                  const Color(0xFF2A2D37),
                  const Color(0xFF1E2329),
                ],
              )
            : LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? const Color(0xFF64B5F6).withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Icon Container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? LinearGradient(
                      colors: [
                        const Color(0xFFFF9800),
                        const Color(0xFFFFC107),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        const Color(0xFF2196F3),
                        const Color(0xFF64B5F6),
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                      ? const Color(0xFFFF9800).withOpacity(0.4)
                      : const Color(0xFF2196F3).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: Colors.white,
              size: 28,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: const Duration(milliseconds: 2000), color: Colors.white.withOpacity(0.5)),
          
          const SizedBox(width: 20),
          
          // Theme Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Theme',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? const Color(0xFFE3F2FD) : const Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDarkMode ? 'Dark Mode Active' : 'Light Mode Active',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode 
                        ? const Color(0xFFB0BEC5)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced Switch
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Switch.adaptive(
              value: isDarkMode,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ThemeToggleEvent());
              },
              activeColor: const Color(0xFF64B5F6),
              inactiveThumbColor: const Color(0xFF1976D2),
              inactiveTrackColor: const Color(0xFF1976D2).withOpacity(0.3),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 800))
        .slideX(begin: 0.5, duration: const Duration(milliseconds: 800));
  }

  List<Widget> _buildMenuItems(bool isDarkMode) {
    final items = [
      {
        'icon': Icons.info_outline_rounded,
        'title': 'About App',
        'subtitle': 'Learn more about features',
        'onTap': () => _showAboutDialog(),
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Help & Support',
        'subtitle': 'Get assistance',
        'onTap': () => Navigator.pop(context),
      },
      {
        'icon': Icons.star_outline_rounded,
        'title': 'Rate App',
        'subtitle': 'Share your feedback',
        'onTap': () => Navigator.pop(context),
      },
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      return AnimatedBuilder(
        animation: _slideAnimation,
        child: _buildEnhancedMenuItem(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          onTap: item['onTap'] as VoidCallback,
          isDarkMode: isDarkMode,
        ),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_slideAnimation.value * 150, 0),
            child: child,
          );
        },
      ).animate()
          .fadeIn(
            duration: const Duration(milliseconds: 600), 
            delay: Duration(milliseconds: 1200 + (index * 200)),
          )
          .slideX(
            begin: 0.5, 
            duration: const Duration(milliseconds: 600),
          );
    }).toList();
  }

  Widget _buildEnhancedMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? const Color(0xFF1E2329).withOpacity(0.6)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode 
                    ? const Color(0xFF3A3D47).withOpacity(0.5)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? const Color(0xFF64B5F6).withOpacity(0.2)
                        : const Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDarkMode 
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1976D2),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode 
                              ? const Color(0xFFE3F2FD)
                              : const Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode 
                              ? const Color(0xFFB0BEC5)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode 
                      ? const Color(0xFF64B5F6).withOpacity(0.6)
                      : const Color(0xFF1976D2).withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLogoutButton(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red[600]!,
                  Colors.red[700]!,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 1600))
        .slideY(begin: 0.5, duration: const Duration(milliseconds: 800));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red[600]),
              const SizedBox(width: 12),
              const Text('Confirm Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout from your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close drawer
                widget.onLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    Navigator.pop(context); // Close drawer first
    showAboutDialog(
      context: context,
      applicationName: 'Currency Converter',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.currency_exchange_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
      children: [
        const Text(
          'A beautiful and feature-rich currency conversion app with real-time exchange rates, stunning animations, and elegant dark mode support.',
        ),
      ],
    );
  }
} 