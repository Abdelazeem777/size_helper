## Unreleased

- Correct the 2.2.0 notes: the `tabletNormal` change can change which option is picked (see 2.2.0).
- Add `repository` and `issue_tracker` to pubspec.yaml.
- CI also runs analyze and tests on Flutter 3.10.0, the minimum this package supports.

## 2.2.0

- **Behaviour change:** `tabletNormal` moved from 400 to 425. It had the same width as `tabletSmall`, so it was never picked when both were passed. If you pass `tabletNormal` without `tabletSmall`, some widths now pick a smaller option instead. For example, with `mobileExtraLarge` and `tabletNormal`, widths from about 388 to 400 dp (iPhone 12-15 are 390 and 393 dp) used to get `tabletNormal` and now get `mobileExtraLarge`; with `mobileLarge` and `tabletNormal`, widths from about 376 to 387 dp now get `mobileLarge`.
- Export `ScreenInfo` from `package:size_helper/size_helper.dart`, so `helpBuilder` callbacks can name the type without importing `src/`.
- Remove `mockito` from runtime dependencies (it was pulled into every app that used this package) and `build_runner: any` from dev dependencies.
- Raise minimum versions to Dart 3.0 and Flutter 3.10. 2.1.0 already needed Flutter 3.10 for `MediaQuery.sizeOf`.
- README fixes (`tabletNormal`/`tabletLarge` names, landscape behavior on web and desktop, sample log line). The demo GIF is no longer shipped in the package archive.
- Add widget tests, Maestro flows and GitHub Actions CI.

## 2.1.0

- Start using `.sizeOf(context)`instead of `.of(context).size`.

## 2.0.0

- Make the breakpoints depend on Width not Height.
- Update breakpoints values.

## 1.1.1+4

- Fix `README.md` screenshot gif.

## 1.1.0+3

- Enhance `README.md` and add more explanation for the package.
- Add some sort of caching approach for not calculating the suitable breakpoint if the widget rebuild with
  that same the screen width and height.
- Use `ScreenInfo` model for `helpBuilder` method.

```dart
// Old
SizeBox(
    height: SizeHelper.of(context).helpBuilder(
        mobileLarge: (_,height , __) => height,
        desktopNormal: (_,height, __) => height * 1.5,
    ),
)

// New
SizeBox(
    height: SizeHelper.of(context).helpBuilder(
        mobileLarge: (info) => info.height,
        desktopNormal: (info) => info.height * 1.5,
    ),
)
```

## 1.0.0+2

- Use `log` instead of `print`.
- Move package to stable version `1.0.0+2`.

## 0.0.1+1

- Update `pubspec.yaml` description.
- Add valid `homepage` URL.
- Add `orientation` option with `helpBuilder` method.

## 0.0.1

- Initial release.
