# Guide Wizard Mobile App

A Flutter mobile application that provides personalized, step-by-step guidance through complex processes. The app delivers adaptive content based on user responses with multilingual support and intelligent logic-based personalization.

## 🚀 Features

- **Personalized Guidance**: Dynamic content adaptation based on user profile and answers
- **Step-by-Step Navigation**: Intuitive wizard-style interface guiding users through multi-step processes
- **Intelligent Logic System**: Content personalization using expression-based conditional logic
- **Multilingual Support**: Full internationalization with dynamic language switching
- **Offline Capability**: Local database caching for offline access to downloaded content
- **Image-Rich Content**: Visual guides with image-based questions and task illustrations
- **Task Management**: Track progress through checklists and subtasks
- **Clean Architecture**: MobX state management with reactive UI updates
- **Material Design**: Modern, responsive UI following Material Design guidelines

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **[Flutter SDK](https://flutter.dev/docs/get-started/install)** (2.0.0 or higher)
- **[Dart SDK](https://dart.dev/get-dart)** (2.12.0 or higher)
- **Android Studio** or **Xcode** (for mobile development)
- **Git**

### Backend Requirement

This app requires the **Guide Wizard Backend** to be running. The backend provides the API for content management, logic evaluation, and personalization.

**Backend Repository**: [Guide Wizard Backend](https://github.com/aazirani/guide_wizard_backend)

## 🔧 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/aazirani/guide_wizard.git
cd guide_wizard
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Generate Code Files

This project uses code generation for MobX stores and JSON serialization. Run the build runner:

```bash
# One-time generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# Or use watch mode for automatic regeneration during development
flutter packages pub run build_runner watch
```

### Step 4: Configure Backend URL

The app is configured to connect to `http://localhost:8080` by default for local development.

To change the backend URL, edit `lib/data/network/constants/endpoints.dart`:

```dart
class Endpoints {
  static const String baseUrl = "http://your-backend-url.com";
  // ... rest of the file
}
```

### Step 5: Run the App

```bash
# For Android
flutter run

# For iOS
flutter run

# For a specific device
flutter devices
flutter run -d <device-id>
```

## 🏗️ Project Architecture

This project follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── constants/              # App-level constants
│   ├── app_theme.dart     # Theme configuration
│   ├── endpoints.dart     # API endpoints
│   ├── preferences.dart   # SharedPreferences keys
│   └── strings.dart       # String constants
├── data/                   # Data layer
│   ├── local/             # Local database (Sembast)
│   ├── network/           # API client (Dio)
│   ├── sharedpref/        # SharedPreferences helper
│   └── repository.dart    # Central data repository
├── models/                 # Data models
│   ├── answer/
│   ├── question/
│   ├── step/
│   ├── task/
│   └── sub_task/
├── stores/                 # MobX state management
│   ├── content/           # Content store
│   ├── language/          # Language store
│   └── theme/             # Theme store
├── ui/                     # UI layer
│   ├── splash/            # Splash screen
│   ├── home/              # Home screen
│   ├── questions/         # Questions screen
│   └── tasks/             # Tasks screen
├── utils/                  # Utility functions
├── widgets/                # Reusable widgets
├── main.dart              # App entry point
└── routes.dart            # Navigation routes
```

## 📚 Key Technologies

### State Management
- **[MobX](https://github.com/mobxjs/mobx.dart)** - Reactive state management
- **[Provider](https://github.com/rrousselGit/provider)** - Dependency injection

### Networking
- **[Dio](https://github.com/flutterchina/dio)** - HTTP client for API communication

### Local Storage
- **[Sembast](https://github.com/tekartik/sembast.dart)** - NoSQL database for offline storage
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)** - Key-value storage

### Code Generation
- **[build_runner](https://pub.dev/packages/build_runner)** - Code generation tool
- **[json_serializable](https://pub.dev/packages/json_serializable)** - JSON serialization
- **[mobx_codegen](https://pub.dev/packages/mobx_codegen)** - MobX code generation

### Other Libraries
- **[get_it](https://github.com/fluttercommunity/get_it)** - Service locator
- **[validators](https://github.com/dart-league/validators)** - Input validation
- **[xxtea](https://github.com/xxtea/xxtea-dart)** - Encryption

## 🎨 Customization

### Changing Theme

Edit `lib/constants/app_theme.dart` to customize colors, typography, and other theme properties:

```dart
final ThemeData themeData = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.blueAccent,
  // ... customize other properties
);
```

### Adding Languages

1. Add translations to the backend using the admin panel
2. The app will automatically fetch and display available languages
3. Users can switch languages from the settings

### Modifying API Endpoints

Update `lib/data/network/constants/endpoints.dart` to match your backend API structure.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📱 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

The built files will be in `build/app/outputs/`.

### iOS

```bash
# Build for iOS
flutter build ios --release
```

Open `ios/Runner.xcworkspace` in Xcode to archive and submit to App Store.

## 🔍 IDE Configuration

### Hide Generated Files

#### Android Studio / IntelliJ IDEA

Navigate to **Preferences** → **Editor** → **File Types** and add the following patterns under **Ignore files and folders**:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

#### Visual Studio Code

Navigate to **Preferences** → **Settings**, search for **Files: Exclude**, and add:

```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## 🐛 Troubleshooting

### Build Runner Issues

If code generation fails:

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Network Connection Issues

- Ensure the backend is running and accessible
- Check the base URL in `endpoints.dart`
- For Android emulator connecting to localhost, use `http://10.0.2.2:8080` instead of `http://localhost:8080`
- For iOS simulator, `http://localhost:8080` should work

### Database Issues

Clear app data and reinstall:

```bash
# Uninstall from device
flutter clean

# Reinstall
flutter run
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow Flutter/Dart style guidelines
4. Write tests for new functionality
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use MobX for state management
- Write widget tests for UI components
- Keep widgets small and focused
- Use meaningful variable and function names

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🔗 Related Projects

- **Backend API**: [Guide Wizard Backend](https://github.com/aazirani/guide_wizard_backend) - The backend system powering this app

## 📞 Support

For questions and support:
- Create an issue in the GitHub repository
- Check Flutter documentation at [flutter.dev](https://flutter.dev/docs)
- Review the troubleshooting section above

## 🙏 Acknowledgments

This project was built using the [Flutter Boilerplate Project](https://github.com/zubairehman/flutter-boilerplate-project) as a foundation.

---

**Built with ❤️ using Flutter**
