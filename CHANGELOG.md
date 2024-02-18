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
