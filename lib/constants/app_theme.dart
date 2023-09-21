/// Creating custom color palettes is part of creating a custom app. The idea is to create
/// your class of custom colors, in this case `CompanyColors` and then create a `ThemeData`
/// object with those colors you just defined.
///
/// Resource:
/// A good resource would be this website: http://mcg.mbitson.com/
/// You simply need to put in the colour you wish to use, and it will generate all shades
/// for you. Your primary colour will be the `500` value.
///
/// Colour Creation:
/// In order to create the custom colours you need to create a `Map<int, Color>` object
/// which will have all the shade values. `const Color(0xFF...)` will be how you create
/// the colours. The six character hex code is what follows. If you wanted the colour
/// #114488 or #D39090 as primary colours in your theme, then you would have
/// `const Color(0x114488)` and `const Color(0xD39090)`, respectively.
///
/// Usage:
/// In order to use this newly created theme or even the colours in it, you would just
/// `import` this file in your project, anywhere you needed it.
/// `import 'path/to/theme.dart';`
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';

class AppThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      shadowColor: AppColors.grey200,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.subtitle1!.apply(color: _darkFillColor),
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: AppColors.blue100,
    primaryContainer: AppColors.blue50,
    onPrimary: AppColors.white,
    secondary: AppColors.green100,
    secondaryContainer: AppColors.green50,
    background: AppColors.white,
    onBackground: AppColors.blue200,
    tertiary: AppColors.orange100,
    tertiaryContainer: AppColors.orange50,
    surface: AppColors.grey50,
    error: AppColors.red100,
    onError: _lightFillColor,
    errorContainer: AppColors.grey100,
    onErrorContainer: AppColors.grey50,
    onSecondary: AppColors.blue200,
    onSurface: AppColors.blue200,
    surfaceTint: AppColors.grey300,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF),
    // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;


  static final TextTheme _textTheme = TextTheme(
    //app bar titles
    titleLarge: TextStyle(fontSize: 20, fontWeight: _bold),
    // step slider titles, task titles , sub task title 
    titleMedium: TextStyle(fontSize: 19, fontWeight: _medium),
    // "steps" / "Description" / "In Progress" in home / task title in task list with less font weight
    titleSmall: TextStyle(fontSize: 18, fontWeight: _semiBold), 
    // description in task page
    bodyLarge: TextStyle(fontSize:18, fontWeight: _regular),
    //description in home, in progress tasks in home, deadline in task page, modal bottom sheet dialog
    bodyMedium: TextStyle(fontSize: 17),
    // no of tasks in step slider and tasklist / button text
    bodySmall: TextStyle(fontSize: 16,),
    labelMedium: TextStyle(fontSize: 17),
    labelSmall: TextStyle(fontSize: 14),
  ).apply(
    displayColor:  lightColorScheme.onSurface, 
    bodyColor: lightColorScheme.onSurface, 
  );
}


