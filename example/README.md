# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Maestro smoke tests

With the example running on an iOS simulator (`flutter run -d <simulator-id>`), run
`maestro --device <simulator-id> test .maestro` from this folder. The flows expect a
390pt-wide phone such as the iPhone 16e (`tabletSmall`); on an iPad Air 13" add
`-e EXPECTED_BREAKPOINT=desktopSmall`.
