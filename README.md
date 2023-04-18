# productos_app

* Gallery of products which allows
  * storing products
  * taking photos
  * uploading new products

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
* Via IDE
    * Android Studio
        * Select the Flutter Device and 'main.dart'
        * Click in run button
* Via terminal
    * `flutter run lib/main.dart`
        * 'lib/main.dart' depends on the relative path between your current terminal and the 'main.dart' file
* Problems:
  * Problem1: Loading continuously '[VERBOSE-2:dart_vm_initializer.cc(41)] Unhandled Exception: type 'String' '

## Note
* Architecture of the repo
    * 'lib'
        * '/screens'
          * App's screens
        * '/models'
          * Generated via pasting the json model to [quickType](https://app.quicktype.io/)
        * '/services'
          * Handle HTTP requests
        * '/widgets'
          * Widgets to be able to reuse around the screens
* Backend
  * ways to connect to it
    * REST API
      * Example: Firebase
        * Sign in, Create a new project, Disable Google Analytics
    * Web Socket