import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class AnimatedMenuDrawer extends StatefulWidget {
  final VoidCallback onLogout;

  const AnimatedMenuDrawer({
    super.key,
    required this.onLogout,
  });

  @override
  State<AnimatedMenuDrawer> createState() => _AnimatedMenuDrawerState();
}

class _AnimatedMenuDrawerState extends State<AnimatedMenuDrawer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation when drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[850]!,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[600]!,
                    Colors.blue[800]!,
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.currency_exchange,
                        size: 40,
                        color: Colors.white,
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .scale(duration: const Duration(milliseconds: 600)),
                    
                    const SizedBox(height: 16),
                    
                    // App Title
                    Text(
                      'Currency Converter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 200))
                        .slideY(begin: 0.3, duration: const Duration(milliseconds: 800)),
                    
                    const SizedBox(height: 8),
                    
                    // Version or subtitle
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 1000), delay: const Duration(milliseconds: 400))
                        .slideY(begin: 0.3, duration: const Duration(milliseconds: 1000)),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Menu Items
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Theme Toggle
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          child: _buildThemeToggle(themeProvider),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value * 100, 0),
                              child: child,
                            );
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Divider
                        Divider(
                          color: theme.dividerColor.withOpacity(0.3),
                          indent: 20,
                          endIndent: 20,
                        ).animate()
                            .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 800)),
                        
                        const SizedBox(height: 16),
                        
                        // About Item
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          child: _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'About',
                            onTap: () {
                              Navigator.pop(context);
                              _showAboutDialog(context);
                            },
                          ),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value * 100, 0),
                              child: child,
                            );
                          },
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Help Item
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          child: _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () {
                              Navigator.pop(context);
                              // Add help functionality
                            },
                          ),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value * 100, 0),
                              child: child,
                            );
                          },
                        ),
                        
                        const Spacer(),
                        
                        // Logout Item
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          child: _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Logout',
                            isDestructive: true,
                            onTap: () {
                              Navigator.pop(context);
                              _showLogoutDialog(context);
                            },
                          ),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value * 100, 0),
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
  }

  Widget _buildThemeToggle(ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode 
                  ? Colors.orange[100] 
                  : Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              themeProvider.isDarkMode 
                  ? Icons.dark_mode 
                  : Icons.light_mode,
              color: themeProvider.isDarkMode 
                  ? Colors.orange[700] 
                  : Colors.blue[700],
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Colors.blue[600],
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 600))
        .slideX(begin: 0.3, duration: const Duration(milliseconds: 600));
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive 
        ? Colors.red[600] 
        : Theme.of(context).textTheme.bodyLarge?.color;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color?.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 1000))
        .slideX(begin: 0.3, duration: const Duration(milliseconds: 600));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onLogout();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[600],
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Currency Converter',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.currency_exchange,
        size: 48,
        color: Colors.blue[600],
      ),
      children: [
        const Text('A beautiful and feature-rich currency conversion app with real-time exchange rates.'),
      ],
    );
  }
} 