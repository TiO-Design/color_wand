Color wand ✨ 🍭🧙‍♂️
=====
A color library which can be used to create, convert, alter, and compare colors to be used in both Flutter and the web.

Installation 💻
-----
1. Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  color: any
```

2. Get the package using your IDE's GUI or via command line with

```bash
$ pub get
```

3. Import the `color_wand.dart` file in your app

```dart
import 'package:color_wand/color_wand.dart';
```

Usage 🥒
-----
Color objects can be constructed by either using the factory constructors of the `Color` interface or by directly 
instantiating an `RgbColor` or an `HslColor` using one of their constructors.

- From HEX: `Color.hex(0xRRGGBBAA)`
- From RGB: `Color.rgb(red: red, green: green, blue: blue)`
- From RGBA: `Color.rgba(red: red, green: green, blue: blue, alpha: alpha)`
- From RGBO: `Color.rgbo(red: red, green: green, blue: blue, opacity: opacity)`
- From HSL: `Color.hsl(hue: hue, saturation: saturation, lightness: lightness)`
- From HSLO: `Color.hslo(hue: hue, saturation: saturation, lightnesss: lightness, opacity: opacity)`
- From the lower 32 bits of an integer to be used e.g. for fast conversion to and from the Flutter color lib: `RgbColor(value)`

Colors are immutable, and can be created using const constructors:
```dart
Color color = const Color.hex(0x12345678);
```

Colors can be converted from one color space to another by calling `toRgb` or `toHsl` on them.

Colors can be compared using the `==` operator, which will implicitly convert the color to an `RgbColor` and then compare there values.


Colors can be converted to a CSS color string by using one of the different implementations of the `CssColorFormat` interface.

Available formats are:
- `RgbFormat`: `rgb(red, green, blue)` or `rgb(red, green, blue, alpha)`
- `RgbaFormat`: `rgba(red, green, blue)` or `rgba(red, green, blue, alpha)`
- `HslFormat`: `hsl(hue, saturation, lightness)` or `hsl(hue, saturation, lightness, alpha)`
- `HslaFormat`: `hsla(hue, saturation, lightness)` or `hsla(hue, saturation, lightness, alpha)`
- `HexFormat` `#RRGGBB`or `#RRGGBBAA`

Most of the formats can be customized to e.g. represent the values as percentages or decimal numbers.

```dart
final rgbFormat = RgbFormat(rgbStyle: PercentOrAlpha.alpha);
final hslFormat = HslFormat(hueStyle: DegreeOrDecimal.degree);
final color = Color.hsl(24, 100, 50);
assert(rgbFormat.format(color) == 'rgb(255, 102, 0)');
assert(hslFormat.format(color) == 'hsl(24deg, 100%, 50%)');
```