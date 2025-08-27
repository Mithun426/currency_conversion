import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:currency_picker/currency_picker.dart';
import '../bloc/currency_conversion_bloc.dart';
import '../bloc/currency_conversion_event.dart';
import '../bloc/currency_conversion_state.dart';
import '../widgets/animated_currency_picker.dart';
import '../widgets/animated_amount_input.dart';
import '../widgets/animated_convert_button.dart';
import '../widgets/animated_swap_button.dart';
import '../widgets/api_mode_toggle.dart';
import '../widgets/conversion_result_widget.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/pages/login_page.dart';
import '../../data/models/currency_model.dart';
import '../../../../core/widgets/animated_loading_widget.dart';
import '../../../../core/widgets/animated_error_widget.dart';
import '../../../../core/widgets/enhanced_menu_drawer.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../core/widgets/page_skeleton_shimmer.dart';

class CurrencyConversionPage extends StatefulWidget {
  const CurrencyConversionPage({super.key});

  @override
  State<CurrencyConversionPage> createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  ConvertButtonState _buttonState = ConvertButtonState.idle;
  String? _errorMessage;
  bool _isConverting = false; // Track if we're actually converting
  bool _isUseMockData = false; // Toggle between mock and real API
  
  // Animation controllers for currency swap
  late AnimationController _swapAnimationController;
  late Animation<double> _fromSlideAnimation;
  late Animation<double> _toSlideAnimation;

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid initial flash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CurrencyConversionBloc>().add(LoadCurrenciesEvent());
      }
    });
    
    // Initialize swap animation - optimized for 60fps
    _swapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600), // Shorter, smoother duration
      vsync: this,
    );

    // Create slide animations for currency interchange with proper easing
    _fromSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _swapAnimationController,
      curve: Curves.easeInOutCubic, // Smoother curve for better perception
    ));

    _toSlideAnimation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(CurvedAnimation(
      parent: _swapAnimationController,
      curve: Curves.easeInOutCubic, // Matching curve for symmetry
    ));

    // Reset button state when amount changes and trigger rebuild
    _amountController.addListener(() {
      setState(() {
        if (_amountController.text.isEmpty) {
          _buttonState = ConvertButtonState.idle;
          _errorMessage = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _swapAnimationController.dispose();
    super.dispose();
  }

  // Handle currency swap with animation
  void _handleSwap() async {
    // Start the animation
    await _swapAnimationController.forward();
    
    // Perform the actual swap
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    
    // Dispatch the swap event to BLoC
    if (!mounted) return;
    context.read<CurrencyConversionBloc>().add(SwapCurrenciesEvent());
    
    // Reset animation
    _swapAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0E13) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1A1D23) : const Color(0xFF1976D2),
        foregroundColor: isDarkMode ? const Color(0xFFE3F2FD) : Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF1A1D23),
                      const Color(0xFF2A2D37),
                    ]
                  : [
                      const Color(0xFF1976D2),
                      const Color(0xFF1565C0),
                    ],
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? const Color(0xFF64B5F6).withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: isDarkMode ? const Color(0xFF64B5F6) : Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
        ],
      ),
      endDrawer: EnhancedMenuDrawer(
        onLogout: () {
          context.read<AuthBloc>().add(AuthSignOutRequested());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
      body: BlocConsumer<CurrencyConversionBloc, CurrencyConversionState>(
        listener: (context, state) {
          if (state is CurrencyConversionLoaded && state.conversionResult != null && _isConverting) {
            setState(() {
              _buttonState = ConvertButtonState.success;
              _errorMessage = null;
              _isConverting = false; // Reset the flag
            });
            
            // Reset button to idle state after a short delay
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (mounted) {
                setState(() {
                  _buttonState = ConvertButtonState.idle;
                });
              }
            });
          } else if (state is CurrencyConversionError) {
            setState(() {
              _buttonState = ConvertButtonState.error;
              _errorMessage = state.message;
              _isConverting = false; // Reset the flag
            });
            
            // Show error snackbar with retry option
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                                         Icon(
                       _getErrorIcon(state.message, _isUseMockData),
                       color: Colors.white,
                       size: 20,
                     ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                                                 _getShortErrorMessage(state.message, _isUseMockData),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                                 backgroundColor: _getErrorColor(state.message, _isUseMockData),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    if (_amountController.text.trim().isNotEmpty) {
                      // Check if both currencies are the same
                      if (_fromCurrency == _toCurrency) {
                        _showSameCurrencySnackBar();
                        return;
                      }
                      
                      setState(() {
                        _buttonState = ConvertButtonState.loading;
                        _errorMessage = null;
                        _isConverting = true;
                      });
                      context.read<CurrencyConversionBloc>().add(
                        ConvertCurrencyEvent(
                          amount: _amountController.text,
                          fromCurrency: _fromCurrency,
                          toCurrency: _toCurrency,
                          useMockData: _isUseMockData,
                        ),
                      );
                    }
                  },
                ),
                duration: const Duration(seconds: 4),
              ),
            );
            
            // Reset button to idle state after showing error briefly
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                setState(() {
                  _buttonState = ConvertButtonState.idle;
                  _errorMessage = null;
                });
              }
            });
          }
        },
        builder: (context, state) {
          return _buildStateContent(state);
        },
      ),
    );
  }

  Widget _getConversionDisplay(CurrencyConversionState state, bool isDarkMode) {
    // Show skeleton shimmer when converting
    if (_buttonState == ConvertButtonState.loading) {
      return Card(
        key: const ValueKey('skeleton-loading'),
        elevation: isDarkMode ? 12 : 8,
        shadowColor: isDarkMode 
            ? const Color(0xFF64B5F6).withOpacity(0.3)
            : Colors.blue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                      Colors.green[50]!,
                    ],
            ),
          ),
          child: const ConversionSkeletonLoader(),
        ),
      );
    }
    
    // Show result if available
    if (state is CurrencyConversionLoaded && state.conversionResult != null) {
      return ConversionResultWidget(
        key: ValueKey(state.conversionResult.hashCode),
        result: state.conversionResult,
        currencies: state.currencies.cast<CurrencyModel>(),
      );
    }
    
    // Show empty state
    return const SizedBox.shrink(
      key: ValueKey('empty'),
    );
  }

  Widget _buildStateContent(CurrencyConversionState state) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    if (state is CurrencyConversionInitial || state is CurrencyConversionLoading) {
      return const PageSkeletonShimmer(
        key: ValueKey('loading'),
      );
    }

    if (state is CurrencyConversionError) {
      return AnimatedErrorWidget(
        key: const ValueKey('error'),
        message: state.message,
        errorType: _getErrorType(state.message, _isUseMockData),
        onRetry: () {
          context.read<CurrencyConversionBloc>().add(LoadCurrenciesEvent());
        },
        showRetryButton: true,
      );
    }

    if (state is CurrencyConversionLoaded) {
      return SingleChildScrollView(
        key: const ValueKey('loaded'),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Currency Conversion Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Convert Currency',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedAmountInput(
                      controller: _amountController,
                      currency: _fromCurrency,
                      onChanged: (value) {
                        // Optional: Auto-convert on input change
                      },
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      children: [
                        Row(
                          children: [
                            // From Currency with Slide Animation
                            Expanded(
                                                                child: RepaintBoundary(
                                    child: AnimatedBuilder(
                                      animation: _fromSlideAnimation,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            _fromSlideAnimation.value * MediaQuery.of(context).size.width * 0.25, // Reduced movement
                                            _fromSlideAnimation.value * 15, // Reduced vertical movement
                                          ),
                                          child: child,
                                        );
                                      },
                                  child: AnimatedCurrencyPicker(
                                    label: 'From',
                                    selectedCurrency: _fromCurrency,
                                    currencies: state.currencies.cast<CurrencyModel>(),
                                    onCurrencySelected: (Currency currency) {
                                      setState(() {
                                        _fromCurrency = currency.code;
                                      });
                                      context.read<CurrencyConversionBloc>().add(
                                        SelectFromCurrencyEvent(currency.code),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                                                          // Animated Swap Button
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: AnimatedSwapButton(
                                  onSwap: _handleSwap,
                                ),
                              ),
                            const SizedBox(width: 8),
                            // To Currency with Slide Animation
                            Expanded(
                                                                child: RepaintBoundary(
                                    child: AnimatedBuilder(
                                      animation: _toSlideAnimation,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            _toSlideAnimation.value * MediaQuery.of(context).size.width * 0.25, // Reduced movement
                                            _toSlideAnimation.value * -15, // Reduced vertical movement
                                          ),
                                          child: child,
                                        );
                                      },
                                  child: AnimatedCurrencyPicker(
                                    label: 'To',
                                    selectedCurrency: _toCurrency,
                                    currencies: state.currencies.cast<CurrencyModel>(),
                                    onCurrencySelected: (Currency currency) {
                                      setState(() {
                                        _toCurrency = currency.code;
                                      });
                                      context.read<CurrencyConversionBloc>().add(
                                        SelectToCurrencyEvent(currency.code),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AnimatedConvertButton(
                      state: _buttonState,
                      errorMessage: _errorMessage,
                      onPressed: _amountController.text.trim().isEmpty ? null : () {
                        // Check if both currencies are the same
                        if (_fromCurrency == _toCurrency) {
                          _showSameCurrencySnackBar();
                          return;
                        }
                        
                        setState(() {
                          _buttonState = ConvertButtonState.loading;
                          _errorMessage = null;
                          _isConverting = true; // Mark that we're converting
                        });
                        context.read<CurrencyConversionBloc>().add(
                          ConvertCurrencyEvent(
                            amount: _amountController.text,
                            fromCurrency: _fromCurrency,
                            toCurrency: _toCurrency,
                            useMockData: _isUseMockData,
                          ),
                        );
                      },
                    ),
                    // API Mode Toggle
                    ApiModeToggle(
                      isUseMockData: _isUseMockData,
                      onToggle: (useMock) {
                        setState(() {
                          _isUseMockData = useMock;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Conversion Result with AnimatedSwitcher
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2), // Reduced movement
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: _getConversionDisplay(state, isDarkMode),
            ),
          ],
        ),
      );
    }

    // Return a simple loading state for unknown states
    return const AnimatedLoadingWidget(
      key: ValueKey('unknown'),
      message: 'Initializing...',
      style: LoadingStyle.pulsing,
    );
  }

  ErrorType _getErrorType(String errorMessage, bool isUseMockData) {
    // In mock mode, never show network errors - it's local data
    if (isUseMockData) {
      return ErrorType.unknown; // Generic error for mock failures
    }
    
    final message = errorMessage.toLowerCase();
    
    if (message.contains('network') || message.contains('connection') || 
        message.contains('internet') || message.contains('offline')) {
      return ErrorType.network;
    } else if (message.contains('server') || message.contains('5')) {
      return ErrorType.server;
    } else if (message.contains('api') || message.contains('service')) {
      return ErrorType.api;
    } else if (message.contains('timeout') || message.contains('time')) {
      return ErrorType.timeout;
    } else {
      return ErrorType.unknown;
    }
  }

  IconData _getErrorIcon(String errorMessage, bool isUseMockData) {
    final errorType = _getErrorType(errorMessage, isUseMockData);
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.server:
        return Icons.dns;
      case ErrorType.api:
        return Icons.api;
      case ErrorType.timeout:
        return Icons.access_time;
      case ErrorType.unknown:
        return isUseMockData ? Icons.bug_report : Icons.error;
    }
  }

  String _getShortErrorMessage(String errorMessage, bool isUseMockData) {
    final errorType = _getErrorType(errorMessage, isUseMockData);
    switch (errorType) {
      case ErrorType.network:
        return 'Connection failed';
      case ErrorType.server:
        return 'Server error';
      case ErrorType.api:
        return 'Service unavailable';
      case ErrorType.timeout:
        return 'Request timeout';
      case ErrorType.unknown:
        return isUseMockData ? 'Mock data error' : 'Conversion failed';
    }
  }

  Color _getErrorColor(String errorMessage, bool isUseMockData) {
    final errorType = _getErrorType(errorMessage, isUseMockData);
    switch (errorType) {
      case ErrorType.network:
        return Colors.orange[600]!;
      case ErrorType.server:
        return Colors.red[600]!;
      case ErrorType.api:
        return Colors.purple[600]!;
      case ErrorType.timeout:
        return Colors.amber[700]!;
      case ErrorType.unknown:
        return isUseMockData ? Colors.blue[600]! : Colors.grey[600]!;
    }
  }

  void _showSameCurrencySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
                     children: [
             Icon(
               Icons.info_outline,
               color: Colors.amber[300],
               size: 20,
             ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Please select different currencies to convert',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
                 backgroundColor: Colors.grey[850],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Select',
          textColor: Colors.amber[300],
          onPressed: () {
            // Trigger currency picker for 'To' currency
            // This could open the currency picker or highlight the to currency field
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
} 