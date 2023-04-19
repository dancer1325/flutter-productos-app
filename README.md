# productos_app

Handle authentication for the app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to compile?
* `flutter pub get`
    * Get the dependencies listed in the 'pubspec.yaml'

## How to run?
* Configuration
  * Use a backend to handle your authentication
    * [Firebase](https://firebase.google.com/)
      * Sign in, Create a new project, Disable Google Analytics, Authentication, Choose your desired sign-in method
  * Use a backend to store your model and media
    * [Firebase](https://firebase.google.com/)
      * Sign in, Create a new project, Disable Google Analytics, Configure the data with the 'Product' model structure
    * [Cloudinary](https://cloudinary.com/)
      * Sign in
      * Follow the specific [Flutter SDK](https://console.cloudinary.com/documentation/flutter_integration)
* Configure your device
    * Simulator
        * Built-in IDE
            * JetBrains
                * Tools, Device Manager, Configure it, Run it
            * VSC
                * Command palette, Flutter Select Device
        * Installed one's
            * Simulator [MacOs]
                * `open -a Simulator`
    * Real physical
        * [MacOs] https://docs.flutter.dev/get-started/install/macos#deploy-to-ios-devices
* Run your flutter project
    * Via IDE
        * Android Studio
            * Select the Flutter Device and 'main.dart'
            * Click in run button
    * Via terminal
        * `flutter run lib/main.dart`
            * 'lib/main.dart' depends on the relative path between your current terminal and the 'main.dart' file