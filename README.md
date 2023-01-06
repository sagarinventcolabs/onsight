# on_sight_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## To run the flavor builds
-> flutter run --flavor dev
-> flutter run --flavor prod
## To make flavor builds
-> flutter build apk --flavor dev     // old
-> flutter build apk --flavor prod    // old


-> flutter build apk --flavor prod -t lib/main_prod.dart         // APK
-> flutter build apk --flavor dev -t lib/main_dev.dart           // APK
-> flutter build appbundle --flavor prod -t lib/main_prod.dart   // App Bundle
-> flutter build appbundle --flavor dev -t lib/main_dev.dart     // App Bundle

    