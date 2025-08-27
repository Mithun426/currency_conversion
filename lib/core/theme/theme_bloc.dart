import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeInitialEvent extends ThemeEvent {}

class ThemeToggleEvent extends ThemeEvent {}

class ThemeChangeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChangeEvent(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded(this.themeMode);

  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object> get props => [themeMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeInitialEvent>(_onThemeInitial);
    on<ThemeToggleEvent>(_onThemeToggle);
    on<ThemeChangeEvent>(_onThemeChange);
  }

  Future<void> _onThemeInitial(
    ThemeInitialEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeLoaded(themeMode));
    } catch (e) {
      emit(const ThemeLoaded(ThemeMode.light)); // Default to light mode
    }
  }

  Future<void> _onThemeToggle(
    ThemeToggleEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final newThemeMode = currentState.themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
      
      await _saveTheme(newThemeMode);
      emit(ThemeLoaded(newThemeMode));
    }
  }

  Future<void> _onThemeChange(
    ThemeChangeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveTheme(event.themeMode);
    emit(ThemeLoaded(event.themeMode));
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, themeMode == ThemeMode.dark);
    } catch (e) {
      // Handle error silently
    }
  }
}

// Enhanced Beautiful Themes
class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 4,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF64B5F6),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0E13),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1D23),
      foregroundColor: const Color(0xFFE3F2FD),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE3F2FD),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 12,
      shadowColor: const Color(0xFF64B5F6).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color(0xFF1E2329),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2D37),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3D47)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3D47)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 8,
        shadowColor: const Color(0xFF64B5F6).withOpacity(0.3),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1A1D23),
    ),
    dividerColor: const Color(0xFF3A3D47),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE3F2FD)),
      bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
      titleLarge: TextStyle(color: Color(0xFFE3F2FD)),
      titleMedium: TextStyle(color: Color(0xFFE3F2FD)),
    ),
  );
} 