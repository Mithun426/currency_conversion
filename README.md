# Currency Converter App

A beautiful and feature-rich Flutter currency conversion app built with Clean Architecture, BLoC pattern, and real-time exchange rates. Features stunning animations, elegant dark mode support.

##  Features

- **Real-time Currency Conversion** with live exchange rates
- **Mock Mode** for offline development and testing
- **Beautiful UI/UX** with smooth animations and dark/light themes
- **Firebase Authentication** with email/password login
- **Offline Support** with intelligent caching and fallbacks
- **Error Handling** with retry mechanisms and user-friendly messages
- **Clean Architecture** following SOLID principles
- **BLoC Pattern** for state management
- **Dependency Injection** with GetIt



### Flutter & Dart Versions
- **Flutter**: 3.19.0 or higher
- **Dart**: 3.7.2 or higher
- **Android**: API level 21+ (Android 5.0+)



##  Setup Steps

### 1. Clone the Repository
```bash
git clone <repository-url>
cd currency_conversion
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration

#### 3.1 Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### 3.2 Login to Firebase
```bash
firebase login
```

#### 3.3 Initialize Firebase in Project
```bash
firebase init
```

#### 3.4 Configure Firebase for Flutter
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

#### 3.5 Add Firebase Configuration Files
- Copy `google-services.json` to `android/app/`
- Copy `GoogleService-Info.plist` to `ios/Runner/`

### 4. API Configuration

#### 4.1 Get API Credentials
1. Sign up at [Exchange Rate API](https://api.exchangerate-api.com)
2. Get  API access key
3. Note  base URL (usually `https://api.exchangerate-api.com/v4`)

#### 4.2 Configure Environment Variables
Create a development script or use IDE run configurations:



*
flutter run --dart-define=BASE_URL=https://api.exchangerate-api.com/v4 \
           --dart-define=ACCESS_KEY=your_api_key_here \
           --dart-define=ENVIRONMENT=development
```


**Option C: VS Code Configuration**
Add to `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Currency App (Dev)",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define=BASE_URL=https://api.exchangerate-api.com/v4",
        "--dart-define=ACCESS_KEY=_api_key_here",
        "--dart-define=ENVIRONMENT=development"
      ]
    }
  ]
}
```

##  How to Run

### Mock Mode (Offline Development)
Mock mode allows you to develop and test without an internet connection or API credentials:

```bash
# Run with mock data (no API credentials needed)
flutter run
```


### Real API Mode (Production)
Real API mode connects to live exchange rate services:

```bash
# Run with real API (requires credentials)
flutter run --dart-define=BASE_URL=https://api.exchangerate-api.com/v4 \
           --dart-define=ACCESS_KEY=your_api_key_here \
           --dart-define=ENVIRONMENT=production
```

**Real API Features:**
- ✅ Live exchange rates
- ✅ Real-time currency data
- ✅ Historical rate access
- ✅ Production-ready accuracy
- ✅ Rate limiting compliance

### Switching Between Modes
The app includes a toggle in the UI to switch between mock and real API modes:

1. Open the app
2. Look for the "Mock" toggle in the top-right area
3. Tap to switch between modes
4. The app will automatically handle the transition

## Caching Strategy & TTL

### Caching Implementation
The app implements a multi-layer caching strategy:

#### 1. Memory Cache (In-Memory)
- **TTL**: 5 minutes
- **Storage**: Dart objects in memory
- **Purpose**: Fast access for repeated requests
- **Clear**: On app restart or memory pressure

#### 2. Local Storage Cache (SharedPreferences)
- **TTL**: 1 hour
- **Storage**: JSON data in device storage
- **Purpose**: Offline access and app restart persistence
- **Clear**: Manual clear or TTL expiration

#### 3. Network Cache (HTTP Cache Headers)
- **TTL**: Respects API cache headers
- **Storage**: HTTP client cache
- **Purpose**: Network-level optimization
- **Clear**: Based on HTTP cache control

### Cache Keys Structure
```
currencies_list: [timestamp, data]
exchange_rate_{from}_{to}: [timestamp, rate]
conversion_{from}_{to}_{amount}: [timestamp, result]
user_preferences: [theme, language, etc.]
```

### TTL Configuration
```dart
// Cache TTL constants
class CacheConfig {
  static const Duration memoryCacheTTL = Duration(minutes: 5);
  static const Duration localCacheTTL = Duration(hours: 1);
  static const Duration networkCacheTTL = Duration(minutes: 15);
}
```

##  API Failure Handling

### Error Types & Handling

#### 1. Network Errors
- **Detection**: Connectivity check + timeout
- **Fallback**: Cached data if available
- **UI**: Network error widget with retry button
- **Retry**: Exponential backoff (1s, 2s, 4s, 8s)

#### 2. Server Errors (5xx)
- **Detection**: HTTP status codes 500-599
- **Fallback**: Mock data or cached data
- **UI**: Server error message with retry
- **Retry**: Immediate retry with user confirmation

#### 3. API Errors (4xx)
- **Detection**: HTTP status codes 400-499
- **Fallback**: Mock data
- **UI**: API error message
- **Retry**: Manual retry only

#### 4. Timeout Errors
- **Detection**: Request timeout (30s)
- **Fallback**: Cached data or mock data
- **UI**: Timeout message with retry
- **Retry**: Immediate retry

### Retry Strategy
```dart
// Retry configuration
class RetryConfig {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);
  static const Duration maxDelay = Duration(seconds: 8);
  static const double backoffMultiplier = 2.0;
}
```

### Offline UI Components
- **Network Error Widget**: Shows when no internet
- **Retry Buttons**: Allow manual retry
- **Offline Indicator**: Shows connection status
- **Cached Data Badge**: Indicates data source
- **Fallback Messages**: User-friendly error messages

## 🏗️ Architecture

### Clean Architecture Overview
The app follows Clean Architecture principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  Pages │ Widgets │ BLoCs │ Events │ States │ Controllers   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│ Entities │ Use Cases │ Repositories │ Business Logic        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│ Models │ Data Sources │ Repository Impl │ External APIs     │
└─────────────────────────────────────────────────────────────┘
```

### Detailed Architecture Flow
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              UI LAYER                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  CurrencyConversionPage  │  LoginPage  │  SplashScreen  │  Drawer         │
│  ┌─────────────────┐     │  ┌─────────┐ │  ┌──────────┐  │  ┌─────────────┐ │
│  │   AppBar        │     │  │  Form   │ │  │  Logo    │  │  │ Theme Toggle│ │
│  │   Input Fields  │     │  │  Auth   │ │  │  Loading │  │  │ Logout      │ │
│  │   Convert Btn   │     │  │  Error  │ │  │  Progress│  │  │ Settings    │ │
│  │   Results       │     │  └─────────┘ │  └──────────┘  │  └─────────────┘ │
│  └─────────────────┘     │              │                │                  │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            BLoC LAYER                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  CurrencyConversionBloc  │  AuthBloc  │  ThemeBloc                         │
│  ┌─────────────────┐     │  ┌─────────┐ │  ┌──────────┐                      │
│  │   Events        │     │  │ Events  │ │  │ Events   │                      │
│  │   States        │     │  │ States  │ │  │ States   │                      │
│  │   Logic         │     │  │ Logic   │ │  │ Logic    │                      │
│  └─────────────────┘     │  └─────────┘ │  └──────────┘                      │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           USE CASE LAYER                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  ConvertCurrency  │  GetAllCurrencies  │  SignIn  │  Register  │  Logout   │
│  ┌─────────────┐  │  ┌──────────────┐  │  ┌─────┐ │  ┌────────┐ │  ┌──────┐ │
│  │ Validation  │  │  │ Validation   │  │  │Auth │ │  │Create  │ │  │Clear │ │
│  │ Business    │  │  │ Business     │  │  │User │ │  │Account │ │  │Sess. │ │
│  │ Rules       │  │  │ Rules        │  │  │Login│ │  │Verify  │ │  │Logout│ │
│  └─────────────┘  │  └──────────────┘  │  └─────┘ │  └────────┘ │  └──────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         REPOSITORY LAYER                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  CurrencyRepository  │  AuthRepository  │  NetworkInfo  │  SessionManager  │
│  ┌─────────────────┐ │  ┌─────────────┐ │  ┌──────────┐ │  ┌─────────────┐ │
│  │ Remote Data     │ │  │ Firebase    │ │  │Connect.  │ │  │ SharedPrefs │ │
│  │ Local Cache     │ │  │ Auth        │ │  │ Check    │ │  │ User Data   │ │
│  │ Error Handling  │ │  │ User Mgmt   │ │  │ Network  │ │  │ Settings    │ │
│  └─────────────────┘ │  └─────────────┘ │  └──────────┘ │  └─────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA SOURCE LAYER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  RemoteDataSource  │  LocalDataSource  │  Firebase  │  SharedPreferences  │
│  ┌─────────────────┐ │  ┌─────────────┐ │  ┌────────┐ │  ┌─────────────────┐ │
│  │ HTTP Client     │ │  │ File System │ │  │ Auth   │ │  │ Key-Value Store │ │
│  │ API Calls       │ │  │ JSON Cache  │ │  │ Cloud  │ │  │ Settings Cache  │ │
│  │ Response Parse  │ │  │ Offline     │ │  │ Storage│ │  │ User Prefs      │ │
│  └─────────────────┘ │  └─────────────┘ │  └────────┘ │  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EXTERNAL SERVICES                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  Exchange Rate API  │  Firebase Services  │  Device Storage  │  Network     │
│  ┌─────────────────┐ │  ┌─────────────────┐ │  ┌─────────────┐ │  ┌─────────┐ │
│  │ Live Rates      │ │  │ Authentication  │ │  │ Local Files │ │  │ Internet│ │
│  │ Currency List   │ │  │ User Database   │ │  │ Cache Data  │ │  │ WiFi    │ │
│  │ Historical Data │ │  │ Cloud Storage   │ │  │ Settings    │ │  │ Mobile  │ │
│  └─────────────────┘ │  └─────────────────┘ │  └─────────────┘ │  └─────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Folder Structure
```
lib/
├── main.dart                          # App entry point
├── injection_container.dart           # Dependency injection
├── enum.dart                          # Global enums
│
├── core/                              # Shared core functionality
│   ├── config/                        # App configuration
│   │   ├── app_config.dart           # Environment config
│   │   └── api_config.dart           # API configuration
│   ├── error/                         # Error handling
│   │   └── failures.dart             # Failure types
│   ├── network/                       # Network utilities
│   │   └── network_info.dart         # Connectivity check
│   ├── theme/                         # Theme management
│   │   ├── theme_bloc.dart           # Theme state management
│   │   └── theme_provider.dart       # Theme provider
│   ├── usecases/                      # Base use case
│   │   └── usecase.dart              # Use case interface
│   ├── util/                          # Utilities
│   │   ├── input_converter.dart      # Input validation
│   │   └── session_manager.dart      # Session management
│   └── widgets/                       # Shared widgets
│       ├── animated_error_widget.dart
│       ├── animated_loading_widget.dart
│       ├── enhanced_menu_drawer.dart
│       ├── network_error_widget.dart
│       └── ...
│
├── features/                          # Feature modules
│   ├── authentication/                # Auth feature
│   │   ├── data/                      # Data layer
│   │   │   ├── datasources/           # Data sources
│   │   │   ├── models/                # Data models
│   │   │   └── repositories/          # Repository impl
│   │   ├── domain/                    # Domain layer
│   │   │   ├── entities/              # Business entities
│   │   │   ├── repositories/          # Repository interfaces
│   │   │   └── usecases/              # Business use cases
│   │   └── presentation/              # Presentation layer
│   │       ├── bloc/                  # State management
│   │       ├── pages/                 # UI pages
│   │       └── widgets/               # Feature widgets
│   │
│   └── currency_conversion/           # Currency feature
│       ├── data/                      # Data layer
│       │   ├── datasources/           # Remote & local data sources
│       │   ├── models/                # Data models
│       │   └── repositories/          # Repository implementation
│       ├── domain/                    # Domain layer
│       │   ├── entities/              # Business entities
│       │   ├── repositories/          # Repository interfaces
│       │   └── usecases/              # Business use cases
│       └── presentation/              # Presentation layer
│           ├── bloc/                  # State management
│           ├── pages/                 # UI pages
│           └── widgets/               # Feature widgets
│
└── test/                              # Test files
    └── widget_test.dart               # Widget tests
```

### Data Flow
```
User Action → Event → BLoC → Use Case → Repository → Data Source → API/Cache
                ↓
User Interface ← State ← BLoC ← Use Case ← Repository ← Data Source
```

### Dependency Injection
The app uses GetIt for dependency injection with the following pattern:

```dart
// Registration order: Data → Domain → Presentation
sl.registerLazySingleton<DataSource>(() => DataSourceImpl());
sl.registerLazySingleton<Repository>(() => RepositoryImpl(dataSource: sl()));
sl.registerLazySingleton<UseCase>(() => UseCase(repository: sl()));
sl.registerFactory<Bloc>(() => Bloc(useCase: sl()));
```

##  Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure
- **Unit Tests**: Use cases, repositories, utilities
- **Widget Tests**: UI components and pages
- **BLoC Tests**: State management logic
- **Integration Tests**: End-to-end workflows

## 📱 Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web --release
```


### API Key Security
- Never hardcoded in source code
-  Use `--dart-define` for environment variables
-  Different keys for dev/staging/production
-  Regular key rotation
- Secure storage practices

### Data Protection
- Local data encryption 
-  Secure network communication (HTTPS)
- Input validation and sanitization
- Error messages don't expose sensitive data


1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request



