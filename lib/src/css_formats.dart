import 'package:color_wand/src/color.dart';
import 'package:color_wand/src/rgb_color.dart';
import 'package:meta/meta.dart';

abstract class CssColorFormat {
  String format(Color color);
}

/// Don´t use this directly. Use [RgbFormat], [RgbaFormat] or write your own
/// child implementation instead.
class PrefixRgbFormat implements CssColorFormat {
  final OpacityMode opacityMode;
  final PercentOrAlpha rgbStyle;
  final PercentOrFractional opacityStyle;
  final String prefix;

  PrefixRgbFormat(
      {@required String prefix,
      OpacityMode opacityMode,
      PercentOrAlpha rgbStyle,
      PercentOrFractional opacityStyle})
      : this.prefix = prefix,
        this.opacityMode = opacityMode ?? OpacityMode.whenTransparent,
        this.rgbStyle = rgbStyle ?? PercentOrAlpha.alpha,
        this.opacityStyle = opacityStyle ?? PercentOrFractional.percent;

  String format(Color color) {
    final rgbColor = color.toRgb();
    final stringBuffer = StringBuffer();

    String rgbPart(String red, String green, String blue) =>
        '$prefix($red, $green, $blue';

    if (rgbStyle == PercentOrAlpha.alpha) {
      stringBuffer.write(rgbPart(rgbColor.red.toString(),
          rgbColor.green.toString(), rgbColor.blue.toString()));
    } else {
      final redAsPercent = _fractionalAsPercent(rgbColor.red / 255);
      final greenAsPercent = _fractionalAsPercent(rgbColor.green / 255);
      final blueAsPercent = _fractionalAsPercent(rgbColor.blue / 255);
      stringBuffer.write(rgbPart(redAsPercent, greenAsPercent, blueAsPercent));
    }
    if (_shouldIncludeOpacity(opacityMode, color.isTransparent)) {
      stringBuffer.write(', ${_formatOpacity(opacityStyle, color.opacity)}');
    }
    stringBuffer.write(')');
    return stringBuffer.toString();
  }
}

class RgbFormat implements CssColorFormat {
  final PrefixRgbFormat _format;

  /// Formats a color in the `rgb(red, green, blue, opacity)` format,
  /// where opacity gets included according to [opacityMode].
  ///
  /// Formats the red, green and blue values according to [rgbStyle].
  /// Formats the opacity value according to [opacityStyle].
  RgbFormat(
      {OpacityMode opacityMode,
      PercentOrAlpha rgbStyle,
      PercentOrFractional opacityStyle})
      : _format = PrefixRgbFormat(
            opacityMode: opacityMode,
            rgbStyle: rgbStyle,
            opacityStyle: opacityStyle,
            prefix: 'rgb');

  @override
  String format(Color color) => _format.format(color);
}

class RgbaFormat implements CssColorFormat {
  final PrefixRgbFormat _format;

  /// Formats a color in the `rgba(red, green, blue, opacity)` format,
  /// where opacity gets included according to [opacityMode].
  ///
  /// Formats the red, green and blue values according to [rgbStyle].
  /// Formats the opacity value according to [opacityStyle].
  RgbaFormat(
      {OpacityMode opacityMode,
      PercentOrAlpha rgbStyle,
      PercentOrFractional opacityStyle})
      : _format = PrefixRgbFormat(
            opacityMode: opacityMode,
            rgbStyle: rgbStyle,
            opacityStyle: opacityStyle,
            prefix: 'rgba');

  @override
  String format(Color color) => _format.format(color);
}

/// Don´t use this directly. Use [HslFormat], [HslaFormat] or write your own
/// child implementation instead.
class PrefixHslFormat implements CssColorFormat {
  final OpacityMode opacityMode;
  final DegreeOrDecimal hueStyle;
  final PercentOrFractional opacityStyle;
  final String prefix;

  PrefixHslFormat(
      {@required String prefix,
      OpacityMode opacityMode,
      DegreeOrDecimal hueStyle,
      PercentOrFractional opacityStyle})
      : this.prefix = prefix,
        this.opacityMode = opacityMode ?? OpacityMode.whenTransparent,
        this.hueStyle = hueStyle ?? DegreeOrDecimal.decimal,
        this.opacityStyle = opacityStyle ?? PercentOrFractional.percent;

  String format(Color color) {
    final hslColor = color.toHsl();
    final stringBuffer = StringBuffer();

    final hue = _formatHue(hueStyle, hslColor.hue);
    final saturation = '${_decimalAsPercent(hslColor.saturation)}';
    final lightness = '${_decimalAsPercent(hslColor.lightness)}';

    stringBuffer.write('$prefix($hue, $saturation, $lightness');
    if (_shouldIncludeOpacity(opacityMode, color.isTransparent)) {
      stringBuffer.write(', ${_formatOpacity(opacityStyle, color.opacity)}');
    }
    stringBuffer.write(')');

    return stringBuffer.toString();
  }
}

class HslFormat implements CssColorFormat {
  final PrefixHslFormat _format;

  /// Formats a color in the `hsl(hue, saturation, lightness, opacity)` format,
  /// where opacity gets included according to [opacityMode].
  ///
  /// Formats the red, green and blue values according to [rgbStyle].
  /// Formats the opacity value according to [opacityStyle].
  HslFormat(
      {OpacityMode opacityMode,
      DegreeOrDecimal hueStyle,
      PercentOrFractional opacityStyle})
      : _format = PrefixHslFormat(
            opacityMode: opacityMode,
            hueStyle: hueStyle,
            opacityStyle: opacityStyle,
            prefix: 'hsl');

  @override
  String format(Color color) => _format.format(color);
}

class HslaFormat implements CssColorFormat {
  final PrefixHslFormat _format;

  /// Formats a color in the `hsla(hue, saturation, lightness, opacity)` format,
  /// where opacity gets included according to [opacityMode].
  ///
  /// Formats the red, green and blue values according to [rgbStyle].
  /// Formats the opacity value according to [opacityStyle].
  HslaFormat(
      {OpacityMode opacityMode,
      DegreeOrDecimal hueStyle,
      PercentOrFractional opacityStyle})
      : _format = PrefixHslFormat(
            opacityMode: opacityMode,
            hueStyle: hueStyle,
            opacityStyle: opacityStyle,
            prefix: 'hsla');

  @override
  String format(Color color) => _format.format(color);
}

class HexFormat implements CssColorFormat {
  final bool isUpperCase;
  final OpacityMode opacityMode;

  /// Formats a color in the `#rrggbbaa` format,
  /// where opacity gets included according to [opacityMode].
  ///
  /// Makes the hex string uppercase according to [isUpperCase].
  HexFormat({bool isUpperCase, OpacityMode opacityMode})
      : this.isUpperCase = isUpperCase ?? true,
        this.opacityMode = opacityMode ?? OpacityMode.whenTransparent;

  @override
  String format(Color color) {
    final rgbColor = color.toRgb();
    final rgbHex = (rgbColor.value & 0xFFFFFF).toRadixString(16);

    final stringBuffer = StringBuffer();
    stringBuffer.write("#$rgbHex");
    if (_shouldIncludeOpacity(opacityMode, rgbColor.isTransparent)) {
      final alphaHex = rgbColor.alpha == RgbColor.minAlpha
          ? "00"
          : rgbColor.alpha.toRadixString(16);
      stringBuffer.write(alphaHex);
    }

    final hex = stringBuffer.toString();

    return isUpperCase ? hex.toUpperCase() : hex.toLowerCase();
  }
}

// -----
// Utils
// -----

String _formatOpacity(PercentOrFractional style, num value) =>
    style == PercentOrFractional.fractional
        ? value.toStringAsFixed(2)
        : _fractionalAsPercent(value);

String _decimalAsPercent(num decimal) {
  final asString =
      (decimal % 1) == 0 ? decimal.toInt() : decimal.toStringAsFixed(2);
  return '$asString%';
}

String _fractionalAsPercent(num fractional) =>
    _decimalAsPercent(fractional * 100);

String _formatHue(DegreeOrDecimal style, num value) =>
    style == DegreeOrDecimal.degree ? '${value}deg' : '${value}';

bool _shouldIncludeOpacity(OpacityMode opacityMode, bool isTranslucent) =>
    opacityMode == OpacityMode.always ||
    opacityMode == OpacityMode.whenTransparent && isTranslucent;

enum PercentOrAlpha { percent, alpha }

enum PercentOrFractional { percent, fractional }

enum DegreeOrDecimal { degree, decimal }

/// Indicates when the opacity will be included in a CSS formatted color.
enum OpacityMode { always, never, whenTransparent }
