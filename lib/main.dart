import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/util/session_manager.dart';
import 'core/widgets/double_tap_exit_wrapper.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/pages/splash_screen.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/currency_conversion/presentation/bloc/currency_conversion_bloc.dart';
import 'features/currency_conversion/presentation/pages/currency_conversion_page.dart';
import 'injection_container.dart' as di;
import 'core/theme/theme_bloc.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Validate configuration first
  AppConfig.printConfig();
  if (!AppConfig.isConfigValid) {
    print('❌ ${AppConfig.validationMessage}');
    // You can choose to exit or show an error screen
    // For now, we'll continue but the API will fail gracefully
  }
  
  await Firebase.initializeApp();
  await di.init();
  
  // Check login status
  final isLoggedIn = await SessionManager.isLoggedIn();
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCheckingLogin = true;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
    _showSplash();
  }

  Future<void> _showSplash() async {
    // Show splash for minimum 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (mounted) {
      setState(() {
        _isCheckingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<CurrencyConversionBloc>(
          create: (_) => di.sl<CurrencyConversionBloc>(),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(ThemeInitialEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final themeMode = state is ThemeLoaded ? state.themeMode : ThemeMode.light;
          
          return MaterialApp(
            title: 'Currency Converter',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            home: DoubleTapExitWrapper(
              child: _isCheckingLogin
                  ? const SplashScreen()
                  : _isLoggedIn
                      ? const CurrencyConversionPage()
                      : const LoginPage(),
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
