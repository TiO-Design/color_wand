import 'dart:math';

import 'package:color_wand/src/hsl_color.dart';
import 'package:color_wand/src/rgb_color.dart';
import 'package:meta/meta.dart';

/// Represents a color.
///
/// A [Color] can be constructed by specifying its value as either a Hex value,
/// a RGB vector, an RGBA (where A stands for alpha) vector,
/// a RGBO (where O stands for opacity) vector,
/// a HSL vector or a HSLO (where O stands for opacity) value.
///
/// Take a look at the underlying implementations ([RgbColor] and [HslColor])
/// for more info on how these values and vectors should look like.
@immutable
abstract class Color {
  static const maxOpacity = 1;

  const Color();

  const factory Color.hex(int value) = RgbColor.fromHex;

  const factory Color.rgb(
      {@required int red,
      @required int green,
      @required int blue}) = RgbColor.fromRgba;

  const factory Color.rgba(
      {@required int red,
      @required int green,
      @required int blue,
      int alpha}) = RgbColor.fromRgba;

  const factory Color.rgbo(
      {@required int red,
      @required int green,
      @required int blue,
      num opacity}) = RgbColor.fromRgbo;

  const factory Color.hsl(
      {@required num hue,
      @required num saturation,
      @required num lightness}) = HslColor.fromHslo;

  const factory Color.hslo(
      {@required num hue,
      @required num saturation,
      @required num lightness,
      num opacity}) = HslColor.fromHslo;

  static Color parseHex(String hex) {
    final withoutHash = hex.replaceAll('#', '');
    final value = int.parse(withoutHash, radix: 16);
    return RgbColor.fromHex(value);
  }

  num get opacity;

  bool get isOpaque => opacity == maxOpacity;

  bool get isTransparent => opacity != maxOpacity;

  /// The relative luminance of the color, as specified by
  /// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef.
  ///
  /// Only valid for opaque colors; use [withBackground] first if necessary.
  num get _relativeLuminance {
    double _luminanceChannel(double v) =>
        (v <= 0.03928) ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4);

    final asRgb = toRgb();
    return _luminanceChannel(asRgb.red / 255) * 0.2126 +
        _luminanceChannel(asRgb.green / 255) * 0.7152 +
        _luminanceChannel(asRgb.blue / 255) * 0.0722;
  }

  bool get isDark => _relativeLuminance <= 0.72;

  bool get isBright => _relativeLuminance > 0.72;

  // -----
  // Conversion
  // -----

  HslColor toHsl();

  RgbColor toRgb();

  // -----
  // Manipulation
  // -----

  /// Returns a new instance with [opacity].
  Color withOpacity(double opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Color && this.toRgb().value == other.toRgb().value;

  @override
  int get hashCode => this.toRgb().hashCode;
}
