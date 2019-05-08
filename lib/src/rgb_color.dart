import 'dart:math';

import 'package:color_wand/src/color.dart';
import 'package:color_wand/src/hsl_color.dart';
import 'package:meta/meta.dart';

/// A [RgbColor] stored as a 32 bit integer where
class RgbColor extends Color {
  static const maxAlpha = 255;

  static const minAlpha = 0;

  final int value;

  /// Fractional representing the [opacity] of a color
  /// typically ranging between 0 and 1 inclusive.
  @override
  num get opacity => num.parse((alpha / maxAlpha).toStringAsFixed(2));

  /// Integer number representing the [alpha] value of a color
  /// ranging between 0 and 255 (inclusive).
  int get alpha => (value & 0xFF000000) >> 24;

  /// Integer number representing the [red] value of a color
  /// ranging between 0 and 255 (inclusive).
  int get red => (value & 0x00FF0000) >> 16;

  /// Integer number representing the [green] value of a color
  /// ranging between 0 and 255 (inclusive).
  int get green => (value & 0x0000FF00) >> 8;

  /// Integer number representing the [blue] value of a color
  /// ranging between 0 and 255 (inclusive).
  int get blue => (value & 0x000000FF) >> 0;

  // -----
  // Constructors
  // -----

  /// Construct a color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  ///
  /// In other words, if AA is the alpha value in hex, RR the red value in hex,
  /// GG the green value in hex, and BB the blue value in hex, a color can be
  /// expressed as `const Color(0xAARRGGBB)`.
  const RgbColor(int value)
      : assert(value != null),
        value = value & 0xFFFFFFFF;

  /// Construct a color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  ///
  /// * Bits 24-31 are the red value.
  /// * Bits 16-23 are the green value.
  /// * Bits 8-15 are the blue value.
  /// * Bits 0-7 are the alpha value.
  ///
  /// In other words, if RR is the red value in hex, GG the green value in hex,
  /// BB the blue value in hex, and AA the alpha value in hex, a color can be
  /// expressed as `const Color(0xRRGGBBAA)`.
  ///
  /// If you omit the alpha value then the color will be fully opaque.
  // TODO: Maybe adjust how out of range values will get brought into range.
  const RgbColor.fromHex(int hex)
      : assert(hex != null),
        value = (((hex > 0xFFFFFF ? (hex >> 8) : hex) & 0xFFFFFF) |
                ((hex > 0xFFFFFF ? (hex & 0xFF) : 0xFF) << 24)) &
            0xFFFFFFFF;

  /// Construct a color from the lower 8 bits of four integers.
  ///
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  /// * `a` is the alpha value, with 0 being transparent and 255 being fully
  ///   opaque.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromRgbo], which takes the alpha value as a floating point
  /// value.
  const RgbColor.fromRgba(
      {@required int red, @required int green, @required int blue, int alpha})
      : assert(red != null),
        assert(green != null),
        assert(blue != null),
        value = (((alpha ?? maxAlpha) & 0xFF) << 24) |
            ((red & 0xFF) << 16) |
            ((green & 0xFF) << 8) |
            ((blue & 0xFF) << 0) & 0xFFFFFFFF;

  /// Construct a color from the lower 8 bits of four integers.
  ///
  /// * [red] ranges from 0 to 255.
  /// * [green] ranges from 0 to 255.
  /// * [blue] ranges from 0 to 255.
  /// * [opacity] with 0 being transparent and 1 being fully
  ///   opaque.
  ///
  /// Out of range [red], [green] and [blue] values are brought into range
  /// using modulo 255. [opacity] is brought into range using modulo 1.
  ///
  /// See also [fromRgba], which takes the opacity as an integer value.
  const RgbColor.fromRgbo(
      {@required int red, @required int green, @required int blue, num opacity})
      : assert(red != null),
        assert(green != null),
        assert(blue != null),
        value = (((maxAlpha + ((1 / (opacity ?? Color.maxOpacity)) ~/ 2)) ~/
                        (1 / (opacity ?? Color.maxOpacity)) &
                    0xff) <<
                24) |
            ((red & 0xFF) << 16) |
            ((green & 0xFF) << 8) |
            ((blue & 0xFF) << 0) & 0xFFFFFFFF;

  // -----
  // Manipulation
  // -----

  /// Returns a new instance with [alpha].
  Color withAlpha(int alpha) {
    assert(alpha != null);
    return _copy(alpha: alpha);
  }

  /// Returns a new instance with [opacity].
  @override
  Color withOpacity(num opacity) {
    assert(opacity != null);
    return _copy(opacity: opacity);
  }

  // -----
  // Conversion
  // -----

  /// Using https://en.wikipedia.org/wiki/HSL_and_HSV#RGB_to_HSL_and_HSV to
  /// convert.
  @override
  HslColor toHsl() {
    num rf = red / 255;
    num gf = green / 255;
    num bf = blue / 255;
    num cMax = [rf, gf, bf].reduce(max);
    num cMin = [rf, gf, bf].reduce(min);
    num delta = cMax - cMin;
    num hue;
    num saturation;
    num lightness;

    if (cMax == rf) {
      hue = 60 * ((gf - bf) / delta % 6);
    } else if (cMax == gf) {
      hue = 60 * ((bf - rf) / delta + 2);
    } else {
      hue = 60 * ((rf - gf) / delta + 4);
    }

    if (hue.isNaN || hue.isInfinite) {
      hue = 0;
    }

    lightness = (cMax + cMin) / 2;

    if (delta == 0) {
      saturation = 0;
    } else {
      saturation = delta / (1 - (lightness * 2 - 1).abs());
    }

    return HslColor.fromHslo(
        hue: hue,
        saturation: saturation * 100,
        lightness: lightness * 100,
        opacity: opacity);
  }

  @override
  RgbColor toRgb() => this;

  // -----
  // Util
  // -----

  RgbColor _copy({int red, int green, int blue, int alpha, num opacity}) =>
      opacity == null
          ? RgbColor.fromRgba(
              red: red ?? this.red,
              green: green ?? this.green,
              blue: blue ?? this.blue,
              alpha: alpha ?? this.alpha)
          : RgbColor.fromRgbo(
              red: red ?? this.red,
              green: green ?? this.green,
              blue: blue ?? this.blue,
              opacity: opacity ?? this.opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RgbColor &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
