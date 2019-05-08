import 'dart:math';

import 'package:color_wand/src/color.dart';
import 'package:color_wand/src/rgb_color.dart';
import 'package:meta/meta.dart';

class HslColor extends Color {
  static const minHue = 0;
  static const minSaturation = 0;
  static const minLightness = 0;

  static const maxHue = 360;
  static const maxSaturation = 100;
  static const maxLightness = 100;

  /// Fractional representing the [opacity] of a color
  /// typically ranging between 0 and 1 inclusive.
  @override
  final num opacity;

  /// Number in degrees representing the [hue] of a color typically ranging in
  /// value between 0 and 360 (inclusive).
  final num hue;

  /// Percentage between 0 and 100 (inclusive) representing the [saturation]
  /// of a color.
  final num saturation;

  /// Percentage representing the [lightness] of a color.
  final num lightness;

  // -----
  // Constructors
  // -----

  /// Creates a [HslColor] using a vector describing its [hue], [saturation],
  /// [lightness] and [opacity].
  ///
  /// The [hue] is a number in degrees, typically ranging in value
  /// between 0 and 360. Out of range values are brought into range using
  /// modulo 360.
  ///
  /// The [saturation] is a percentage typically between 0 and 100 (inclusive).
  /// Out of range values are brought into range using modulo 100.
  ///
  /// The [lightness] is a percentage typically between 0 and 100 (inclusive).
  /// Out of range values are brought into range using modulo 100.
  ///
  /// The [opacity] is a fractional typically between 0 and 1 (inclusive) and
  /// defaults to 1.
  /// Out of range values are brought into range using modulo 1.
  const HslColor.fromHslo(
      {@required num hue,
      @required num saturation,
      @required num lightness,
      num opacity})
      : assert(hue != null),
        assert(saturation != null),
        assert(lightness != null),
        this.hue = hue != maxHue ? hue % maxHue : hue,
        this.saturation = saturation != maxSaturation
            ? ((((saturation * 100) + (lightness >= 0 ? 0.5 : -0.5)) ~/ 1) /
                    100) %
                maxSaturation
            : saturation,
        this.lightness = lightness != maxLightness
            ? ((((lightness * 100) + (lightness >= 0 ? 0.5 : -0.5)) ~/ 1) /
                    100) %
                maxLightness
            : lightness,
        this.opacity = (opacity ?? Color.maxOpacity) != Color.maxOpacity
            ? opacity % Color.maxOpacity
            : Color.maxOpacity;

  // -----
  // Manipulation
  // -----

  /// Returns a new instance with [opacity].
  @override
  Color withOpacity(num opacity) {
    assert(opacity != null);
    return _copy(opacity: opacity);
  }

  /// Returns a new instance with [lightness].
  HslColor withLightness(num lightness) {
    assert(lightness != null);
    return _copy(lightness: lightness);
  }

  /// Returns a new instance that got lightened by [steps].
  HslColor lightenBySteps(num steps) {
    assert(steps != null);
    return _copy(lightness: this.lightness + steps);
  }

  /// Returns a new instance that got lightened by [fraction] of the previous
  /// lightness.
  HslColor lightenByFraction(num fraction) {
    assert(fraction != null);
    return _copy(lightness: this.lightness + this.lightness * fraction);
  }

  /// Returns a new instance that got darkened by [steps].
  HslColor darkenBySteps(num steps) {
    assert(steps != null);
    return _copy(lightness: this.lightness - steps);
  }

  /// Returns a new instance that got darkened by [fraction] of the previous
  /// lightness.
  HslColor darkenByFraction(num fraction) {
    assert(fraction != null);
    return _copy(lightness: this.lightness - this.lightness * fraction);
  }

  // -----
  // Conversion
  // -----

  @override
  HslColor toHsl() => this;

  /// Using https://en.wikipedia.org/wiki/HSL_and_HSV#Alternative_HSL_to_RGB
  /// to convert.
  @override
  RgbColor toRgb() {
    final saturationFractional = saturation / 100;
    final lightnessFractional = lightness / 100;
    int f(int n) {
      final a = saturationFractional *
          min(lightnessFractional, 1 - lightnessFractional);
      final k = (n + hue / 30) % 12;
      return ((lightnessFractional - a * max(min(min(k - 3, 9 - k), 1), -1)) *
              RgbColor.maxAlpha)
          .round();
    }

    return RgbColor.fromRgbo(
        red: f(0), green: f(8), blue: f(4), opacity: opacity);
  }

  // -----
  // Util
  // -----

  HslColor _copy({num hue, num saturation, num lightness, num opacity}) =>
      HslColor.fromHslo(
          hue: hue ?? this.hue,
          saturation: saturation ?? this.saturation,
          lightness: lightness ?? this.lightness,
          opacity: opacity ?? this.opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HslColor &&
          runtimeType == other.runtimeType &&
          opacity == other.opacity &&
          hue == other.hue &&
          saturation == other.saturation &&
          lightness == other.lightness;

  @override
  int get hashCode =>
      opacity.hashCode ^
      hue.hashCode ^
      saturation.hashCode ^
      lightness.hashCode;
}
