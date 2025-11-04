# TruthLens 🔍🛡️

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

**TruthLens** is a cutting-edge mobile application designed to detect deepfake content in images and videos using advanced AI/ML models. With an intuitive interface and powerful detection algorithms, TruthLens helps users verify the authenticity of digital media.

## 📱 Features

- **🎭 Deepfake Detection**: Analyze images and videos for deepfake manipulation
- **🔐 Secure Authentication**: User registration and login with secure password handling
- **📸 Image Upload**: Upload and analyze images for authenticity
- **🎥 Video Upload**: Detect deepfakes in video content
- **📊 Detection Results**: Visual confidence meter and detailed analysis
- **ℹ️ About Section**: Learn more about deepfake technology and TruthLens
- **🎨 Modern UI**: Beautiful glassmorphism design with smooth animations

## 🏗️ Architecture

TruthLens follows the **MVC (Model-View-Controller)** architecture pattern with **BLoC** (Business Logic Component) for state management, ensuring clean, maintainable, and scalable code.

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App-wide constants (colors, strings, routes)
│   ├── themes/             # App theming and text styles
│   └── utils/              # Helper functions and validators
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   └── data_sources/       # API and local storage
├── business_logic/          # Business logic layer
│   ├── blocs/              # BLoC state management
│   └── cubits/             # Cubit state management
├── presentation/            # Presentation layer
│   ├── screens/            # All app screens
│   ├── widgets/            # Reusable widgets
│   └── routes/             # Navigation routes
└── services/                # App services (DI, notifications)
```

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

### Core Dependencies
```yaml
flutter_bloc: ^8.1.3          # State management
equatable: ^2.0.5             # Value equality
dio: ^5.4.0                   # HTTP client
get_it: ^7.6.4                # Dependency injection
go_router: ^13.0.0            # Navigation
```

### UI & Media
```yaml
image_picker: ^1.0.7          # Image selection
file_picker: ^6.1.1           # File selection
cached_network_image: ^3.3.1  # Image caching
flutter_svg: ^2.0.9          # SVG support
```

### Storage
```yaml
shared_preferences: ^2.2.2    # Local storage
flutter_secure_storage: ^9.0.0 # Secure storage
```

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
- **LinkedIn**: [Irfan Karim](https://linkedin.com/in/yourprofile)

---

<p align="center">Made with ❤️ and Flutter</p> 🔍🛡️

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

**TruthLens** is a cutting-edge mobile application designed to detect deepfake content in images and videos using advanced AI/ML models. With an intuitive interface and powerful detection algorithms, TruthLens helps users verify the authenticity of digital media.

## 📱 Features

- **🎭 Deepfake Detection**: Analyze images and videos for deepfake manipulation
- **🔐 Secure Authentication**: User registration and login with secure password handling
- **📸 Image Upload**: Upload and analyze images for authenticity
- **🎥 Video Upload**: Detect deepfakes in video content
- **📊 Detection Results**: Visual confidence meter and detailed analysis
- **ℹ️ About Section**: Learn more about deepfake technology and TruthLens
- **🎨 Modern UI**: Beautiful glassmorphism design with smooth animations

## 🏗️ Architecture

TruthLens follows the **MVC (Model-View-Controller)** architecture pattern with **BLoC** (Business Logic Component) for state management, ensuring clean, maintainable, and scalable code.

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App-wide constants (colors, strings, routes)
│   ├── themes/             # App theming and text styles
│   └── utils/              # Helper functions and validators
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   └── data_sources/       # API and local storage
├── business_logic/          # Business logic layer
│   ├── blocs/              # BLoC state management
│   └── cubits/             # Cubit state management
├── presentation/            # Presentation layer
│   ├── screens/            # All app screens
│   ├── widgets/            # Reusable widgets
│   └── routes/             # Navigation routes
└── services/                # App services (DI, notifications)
```

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

### Core Dependencies
```yaml
flutter_bloc: ^8.1.3          # State management
equatable: ^2.0.5             # Value equality
dio: ^5.4.0                   # HTTP client
get_it: ^7.6.4                # Dependency injection
go_router: ^13.0.0            # Navigation
```

### UI & Media
```yaml
image_picker: ^1.0.7          # Image selection
file_picker: ^6.1.1           # File selection
cached_network_image: ^3.3.1  # Image caching
flutter_svg: ^2.0.9           # SVG support
```

### Storage
```yaml
shared_preferences: ^2.2.2    # Local storage
flutter_secure_storage: ^9.0.0 # Secure storage
```

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
