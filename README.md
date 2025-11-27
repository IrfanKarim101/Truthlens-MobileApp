 # TruthLens 🔍🛡️

 ![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
 ![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)

 **TruthLens** is a mobile application for detecting deepfake images and videos. The app integrates ML face detection, media upload and analysis, authentication, and a history dashboard.

 ## Quick start

 1. Clone the repository
    ```powershell
    git clone https://github.com/irfankarim101/truthlens.git
    cd truthlens
    ```

 2. Fetch dependencies
    ```powershell
    flutter pub get
    ```

 3. Run the app
    ```powershell
    flutter run
    ```

 ## Project structure
 A brief overview of important folders used in this project (a shortened layout):
 
 ```text
 lib/
 ├── business_logic/   # blocs/cubits and state management
 ├── core/             # DI, network, helpers, constants
 ├── data/             # models, repositories, data sources (remote)
 ├── presentation/     # UI: screens, widgets, routes
 └── services/         # small app services (SplashService, etc)
 ```

 ## Key features
 - Deepfake detection for images/videos (Backend + client upload)
 - ML face detection (using google_mlkit_face_detection) on selected media
 - Upload progress with determinate and indeterminate states
 - History view with pagination and a recent activity preview
 - Authentication (AuthBloc), secure storage for tokens

 ## Dependencies
 These reflect what is currently used in `pubspec.yaml` (versions in repo):

 ### Core
 ```yaml
 cupertino_icons: ^1.0.8
 dio: ^5.9.0
 flutter_bloc: ^8.1.3
 equatable: ^2.0.7
 get_it: ^7.7.0
 connectivity_plus: ^7.0.0
 ```

 ### Media & ML
 ```yaml
 image_picker: ^1.2.0
 video_player: ^2.10.0
 google_mlkit_face_detection: ^0.13.1
 image: ^4.5.4
 ```

 ### Storage & auth
 ```yaml
 shared_preferences: ^2.0.15
 flutter_secure_storage: ^9.2.4
 google_sign_in: ^6.1.6
 ```

 ### Utilities & Testing
 ```yaml
 logger: ^2.6.2
 intl: ^0.20.2
 http: ^1.6.0

 dev_dependencies:
 flutter_lints: ^5.0.0
 bloc_test: ^9.1.7
 mockito: ^5.4.4
 build_runner: ^2.4.8
 ```

 ## Folder specifics
 - `lib/core/injection_container.dart`: DI registration with `getIt`.
 - `lib/business_logic/blocs/`: contains BLoC files for upload, analysis, history, etc.
 - `lib/data/data_source/remote/`: API service implementations using Dio client.
 - `lib/presentation/screens/`: UI screens such as Home, Upload, History, Analysis report.

 ## Run tests
 ```powershell
 flutter test
 ```

 **Generating mocks** (for mockito):
 ```powershell
 flutter pub run build_runner build --delete-conflicting-outputs
 ```

 ## Notes & Tips
 - The ML face detection requires native setup and permissions on Android/iOS.
 - The project uses `SharedPreferences` and `flutter_secure_storage` to persist tokens and user preferences.
 - The `History` endpoints are paginated and the `HistoryBloc` handles fetching/append logic.

 ## Contributing
 1. Fork the repo and create a branch
 2. Implement features or fixes with tests
 3. Submit a PR with a clear description

 ## License
 MIT

 ---

 If you'd like, I can also update `pubspec.yaml` to bump specific dependency versions, or add/remove packages you want to use — tell me which packages to upgrade and I’ll prepare a PR-style diff.


## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for macOS) or Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/irfankarim101/truthlens.git
   cd truthlens
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

Dependencies used in the project are listed in `pubspec.yaml` and reflected below in the "Dependencies" section. For the authoritative and up-to-date versions, please prefer the `pubspec.yaml` file.

## 📱 Screens

### 1. Splash Screen
- Animated logo with fade and zoom effects
- App branding with TruthLens logo
- Smooth transition to login

### 2. Login Screen
- Email and password authentication
- Glassmorphism design
- Password visibility toggle
- "Forgot Password?" functionality

### 3. Sign Up Screen
- User registration with validation
- Full name, email, and password fields
- Confirm password with matching validation
- Glassmorphism design consistency

### 4. Home Screen
- Dashboard overview
- Quick access to upload features
- Recent detection history

### 5. Upload Image Screen
- Image picker integration
- Preview before analysis
- Upload progress indicator

### 6. Upload Video Screen
- Video picker integration
- Video preview
- Upload progress tracking

### 7. About Screen
- Information about TruthLens
- How deepfake detection works
- Team and credits

## 🎨 Design System

### Colors
- **Primary Blue**: `#40C4FF` (Light Blue Accent)
- **Primary Purple**: `#E040FB` (Purple Accent)
- **Background**: Dark gradients with blur effects
- **Text**: White with various opacity levels

### Typography
- **Headings**: Bold, 28-32px
- **Body**: Regular, 14-16px
- **Buttons**: Semi-bold, 16-18px

### UI Components
- **Glassmorphism**: Frosted glass effect with backdrop blur
- **Rounded Corners**: 16-32px border radius
- **Gradient Buttons**: Purple to Blue gradient
- **Animated Elements**: Smooth fade and slide transitions

## 🔒 Security Features

- Secure password storage using `flutter_secure_storage`
- Input validation for all forms
- JWT token-based authentication (to be implemented)
- HTTPS-only API communication

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_bloc_test.dart

# Run with coverage
flutter test --coverage
```

## 📱 Building for Production

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Comment complex logic
- Write tests for new features

## 📝 TODO

- [ ] Integrate ML model for deepfake detection
- [ ] Implement API endpoints
- [ ] Add unit and widget tests
- [ ] Implement push notifications
- [ ] Add multi-language support
- [ ] Implement dark/light theme toggle
- [ ] Add social media sharing
- [ ] Implement user profile management
- [ ] Add detection history with filters

## 🐛 Known Issues

- None at the moment

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Irfan Karim** - *Initial work* - [Github](https://github.com/irfankarim101)
- **Sohail Ahmad** - *Initial work* - [Github](https://github.com/)
- **Aliyan Ali** - *Initial work* - [Github](https://github.com/Aliyan167)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library maintainers
- Design inspiration from modern UI/UX trends
- Open-source community

## 📞 Contact

- **GitHub**: [@irfankarim101](https://github.com/irfankarim101)
- **LinkedIn**: [Irfan Karim]](https://linkedin.com/in/yourprofile)

---

<p align="center">Made with ❤️ and Flutter</p>




