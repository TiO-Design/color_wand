import 'package:color_wand/src/color.dart';
import 'package:color_wand/src/hsl_color.dart';
import 'package:color_wand/src/rgb_color.dart';
import 'package:test/test.dart';

void main() {
  group("Should construct a color", () {
    test("when using the Color.hex factory.", () {
      final color = Color.hex(0x12345678);
      expect(color, TypeMatcher<RgbColor>());
      expect(color.toRgb().value, 0x78123456);
    });
    test("when using the Color.rgb factory.", () {
      final color = Color.rgb(red: 120, green: 121, blue: 122);
      final rgbColor = color.toRgb();
      expect(color, TypeMatcher<RgbColor>());
      expect(rgbColor.red, 120);
      expect(rgbColor.green, 121);
      expect(rgbColor.blue, 122);
    });
    test("when using the Color.rgba factory.", () {
      final color = Color.rgba(red: 120, green: 121, blue: 122, alpha: 123);
      final rgbColor = color.toRgb();
      expect(color, TypeMatcher<RgbColor>());
      expect(rgbColor.red, 120);
      expect(rgbColor.green, 121);
      expect(rgbColor.blue, 122);
      expect(rgbColor.alpha, 123);
    });
    test("when using the Color.rgbo factory.", () {
      final color = Color.rgbo(red: 120, green: 121, blue: 122, opacity: 0.5);
      final rgbColor = color.toRgb();
      expect(color, TypeMatcher<RgbColor>());
      expect(rgbColor.red, 120);
      expect(rgbColor.green, 121);
      expect(rgbColor.blue, 122);
      expect(rgbColor.opacity, 0.5);
    });
    test("when using the Color.hsl factory.", () {
      final color = Color.hsl(hue: 10, saturation: 11, lightness: 12);
      final hslColor = color.toHsl();
      expect(color, TypeMatcher<HslColor>());
      expect(hslColor.hue, 10);
      expect(hslColor.saturation, 11);
      expect(hslColor.lightness, 12);
    });
    test("when using the Color.hslo factory.", () {
      final color =
          Color.hslo(hue: 10, saturation: 11, lightness: 12, opacity: 0.5);
      final hslColor = color.toHsl();
      expect(color, TypeMatcher<HslColor>());
      expect(hslColor.hue, 10);
      expect(hslColor.saturation, 11);
      expect(hslColor.lightness, 12);
      expect(hslColor.opacity, 0.5);
    });
    test("when using the parseHex function with 8 bytes supplied.", () {
      final color = Color.parseHex('#12345678').toRgb();
      expect(color.value, 0x78123456);
    });
    test("when using the parseHex function with only 6 bytes supplied.", () {
      final color = Color.parseHex('#345678').toRgb();
      expect(color.value, 0xFF345678);
    });
    test("when using the parseHex function withouth a hash prefix.", () {
      final color = Color.parseHex('12345678').toRgb();
      expect(color.value, 0x78123456);
    });
    test(
        "with the value brought into range when using the parseHex function with a hex longer than 8 bytes supplied.",
        () {
      final color = Color.parseHex('#9A34567812').toRgb();
      expect(color.value, 0x12345678);
    });
  });

  group("Should throw an error when constructing a color", () {
    test("using the parseHex function with an invalid hext string", () {
      final createInvalidColor = () => Color.parseHex('invalid');
      expect(createInvalidColor, throwsException);
    });
  });

  group("Should return the correct value when getting the", () {
    test("isOpaque value of a transparent Color.", () {
      final color =
          Color.hslo(hue: 10, saturation: 11, lightness: 12, opacity: 0.5);
      expect(color.isOpaque, false);
    });
    test("isOpaque value of an opaque Color.", () {
      final color =
          Color.hslo(hue: 10, saturation: 11, lightness: 12, opacity: 1);
      expect(color.isOpaque, true);
    });
    test("isTransparent value of a transparent Color.", () {
      final color =
          Color.hslo(hue: 10, saturation: 11, lightness: 12, opacity: 0.5);
      expect(color.isTransparent, true);
    });
    test("isTransparent value of an opaque Color.", () {
      final color =
          Color.hslo(hue: 10, saturation: 11, lightness: 12, opacity: 1);
      expect(color.isTransparent, false);
    });
  });

  group("Should compare different instances", () {
    test("of the same color in different color spaces correctly", () {
      final instance1 = HslColor.fromHslo(
          hue: 100, saturation: 80, lightness: 50, opacity: 0.5);
      final instance2 = RgbColor.fromHex(0x5de61980);

      expect(instance1 == instance2, true);
    });
    test("of different colors in different color spaces correctly", () {
      final instance1 = HslColor.fromHslo(
          hue: 100, saturation: 20, lightness: 50, opacity: 0.5);
      final instance2 = RgbColor.fromHex(0x5de41980);

      expect(instance1 == instance2, false);
    });
  });

  group("Should calculate the relative luminance correctly when", () {
    test("using the isDark getter on a dark color.", () {
      final darkColor = Color.hex(0x000000);
      final isDark = darkColor.isDark;
      expect(isDark, true);
    });
    test("using the isDark getter on a bright color.", () {
      final brightColor = Color.hex(0xFFFFFF);
      final isDark = brightColor.isDark;
      expect(isDark, false);
    });
    test("using the isBright getter on a dark color.", () {
      final darkColor = Color.hex(0x000000);
      final isBright = darkColor.isBright;
      expect(isBright, false);
    });
    test("using the isBright getter on a bright color.", () {
      final brightColor = Color.hex(0xFFFFFF);
      final isBright = brightColor.isBright;
      expect(isBright, true);
    });
  });
}
