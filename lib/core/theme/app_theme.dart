import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color primaryViolet = Color(0xFF7C4DFF);
  static const Color primaryDeep = Color(0xFF6C63FF);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentGold = Color(0xFFFFD740);

  // Dark palette
  static const Color darkBg = Color(0xFF0A0A12);
  static const Color darkSurface = Color(0xFF12121F);
  static const Color darkCard = Color(0xFF1A1A2E);
  static const Color darkCardAlt = Color(0xFF1E1E30);
  static const Color darkBorder = Color(0xFF2A2A40);
  static const Color darkTextPrimary = Color(0xFFF0F0FF);
  static const Color darkTextSecondary = Color(0xFF9090B0);
  static const Color darkTextMuted = Color(0xFF5A5A80);

  // Light palette
  static const Color lightBg = Color(0xFFF5F5FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFEEEEFF);
  static const Color lightBorder = Color(0xFFDDDDFF);
  static const Color lightTextPrimary = Color(0xFF0A0A20);
  static const Color lightTextSecondary = Color(0xFF4A4A70);

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: primary, fontWeight: FontWeight.w700, letterSpacing: -1.5,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.5,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: primary, fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: primary, fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: primary, fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: primary, fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: primary, fontWeight: FontWeight.w500,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: secondary, fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: primary),
      bodyMedium: base.bodyMedium?.copyWith(color: secondary),
      bodySmall: base.bodySmall?.copyWith(color: secondary),
      labelLarge: base.labelLarge?.copyWith(
        color: primary, fontWeight: FontWeight.w600, letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primaryViolet,
      secondary: accentCyan,
      tertiary: accentPink,
      background: darkBg,
      surface: darkSurface,
      surfaceVariant: darkCard,
      onPrimary: Colors.white,
      onSecondary: darkBg,
      onBackground: darkTextPrimary,
      onSurface: darkTextPrimary,
      outline: darkBorder,
      error: const Color(0xFFFF5252),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      dividerColor: darkBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: primaryViolet.withOpacity(0.15),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryViolet, size: 24);
          }
          return IconThemeData(color: darkTextMuted, size: 24);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: darkBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryViolet, width: 1.5),
        ),
        hintStyle: TextStyle(color: darkTextMuted),
        labelStyle: TextStyle(color: darkTextSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCardAlt,
        selectedColor: primaryViolet.withOpacity(0.2),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        side: BorderSide(color: darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryViolet,
        inactiveTrackColor: darkBorder,
        thumbColor: primaryViolet,
        overlayColor: primaryViolet.withOpacity(0.15),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryViolet,
        linearTrackColor: darkBorder,
      ),
      iconTheme: const IconThemeData(color: darkTextSecondary, size: 22),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: darkTextSecondary,
        textColor: darkTextPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 16,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCardAlt,
        contentTextStyle: GoogleFonts.inter(color: darkTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// AMOLED theme: true black background for OLED power savings
  static ThemeData get amoledTheme {
    const amoledBg = Color(0xFF000000);
    const amoledSurface = Color(0xFF080808);
    const amoledCard = Color(0xFF0F0F0F);

    final base = darkTheme;
    return base.copyWith(
      scaffoldBackgroundColor: amoledBg,
      colorScheme: base.colorScheme.copyWith(
        background: amoledBg,
        surface: amoledSurface,
        surfaceVariant: amoledCard,
      ),
      cardColor: amoledCard,
      cardTheme: base.cardTheme.copyWith(color: amoledCard),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: amoledSurface,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: amoledSurface,
      ),
      dialogTheme: base.dialogTheme.copyWith(backgroundColor: amoledCard),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: primaryViolet,
      secondary: primaryDeep,
      tertiary: accentPink,
      background: lightBg,
      surface: lightSurface,
      surfaceVariant: lightCard,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightTextPrimary,
      onSurface: lightTextPrimary,
      outline: lightBorder,
      error: const Color(0xFFD32F2F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),
      scaffoldBackgroundColor: lightBg,
      cardColor: lightSurface,
      dividerColor: lightBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBg,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: primaryViolet.withOpacity(0.12),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryViolet, size: 24);
          }
          return const IconThemeData(color: Color(0xFF9090A0), size: 24);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryViolet, width: 1.5),
        ),
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryViolet,
        inactiveTrackColor: lightBorder,
        thumbColor: primaryViolet,
        overlayColor: primaryViolet.withOpacity(0.12),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
    );
  }
}
