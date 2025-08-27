import 'package:flutter/material.dart';
import 'skeleton_shimmer.dart';

class PageSkeletonShimmer extends StatelessWidget {
  const PageSkeletonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Currency Conversion Card Skeleton
          Card(
            elevation: isDarkMode ? 12 : 4,
            shadowColor: isDarkMode 
                ? const Color(0xFF64B5F6).withOpacity(0.3)
                : Colors.blue.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          const Color(0xFF1E2329),
                          const Color(0xFF2A2D37),
                          const Color(0xFF1A1D23),
                        ]
                      : [
                          Colors.blue[50]!,
                          Colors.white,
                          Colors.grey[50]!,
                        ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Convert Currency Title Skeleton
                    SkeletonShimmer(
                      child: SkeletonContainer(
                        width: 150,
                        height: 24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Amount Input Skeleton
                    SkeletonShimmer(
                      child: SkeletonContainer(
                        width: double.infinity,
                        height: 56,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Currency Selection Row Skeleton
                    Row(
                      children: [
                        // From Currency Skeleton
                        Expanded(
                          child: SkeletonShimmer(
                            child: SkeletonContainer(
                              width: double.infinity,
                              height: 80,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Swap Button Skeleton
                        SkeletonShimmer(
                          child: SkeletonContainer(
                            width: 48,
                            height: 48,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // To Currency Skeleton
                        Expanded(
                          child: SkeletonShimmer(
                            child: SkeletonContainer(
                              width: double.infinity,
                              height: 80,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Convert Button Skeleton
                    SkeletonShimmer(
                      child: SkeletonContainer(
                        width: double.infinity,
                        height: 56,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Toggle Button Skeleton
                    Align(
                      alignment: Alignment.centerRight,
                      child: SkeletonShimmer(
                        child: SkeletonContainer(
                          width: 120,
                          height: 32,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Additional Content Skeletons
          Row(
            children: [
              Expanded(
                child: SkeletonShimmer(
                  child: SkeletonContainer(
                    width: double.infinity,
                    height: 100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SkeletonShimmer(
                  child: SkeletonContainer(
                    width: double.infinity,
                    height: 100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Long Content Skeleton
          SkeletonShimmer(
            child: SkeletonContainer(
              width: double.infinity,
              height: 120,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Multiple Line Skeletons
          Column(
            children: [
              SkeletonShimmer(
                child: SkeletonContainer(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              SkeletonShimmer(
                child: SkeletonContainer(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              SkeletonShimmer(
                child: SkeletonContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 16,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 