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

  num get opacity;

  bool get isOpaque => opacity == maxOpacity;

  bool get isTransparent => opacity != maxOpacity;

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
}
