import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.neutral6,
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        headlineLarge: AppTypography.title1,
        headlineMedium: AppTypography.title2,
        headlineSmall: AppTypography.title3,
        bodyLarge: AppTypography.body1,
        bodyMedium: AppTypography.body2,
        bodySmall: AppTypography.body3,
        labelLarge: AppTypography.caption1,
        labelMedium: AppTypography.caption2,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: AppTypography.title2,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.neutral3,
        ),
      ),

      /* 
      -------------------------------------------------------------------------------------------------
      INPUTS
      -------------------------------------------------------------------------------------------------
      */ 
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: AppColors.neutral6,
        errorStyle: AppTypography.body3.copyWith(
          color: AppColors.semanticRed,
        ),
        labelStyle: AppTypography.caption1.copyWith(
          color: AppColors.neutral2,
        ),
        floatingLabelStyle: AppTypography.caption1.copyWith(
          color: AppColors.neutral2,
        ),
        hintStyle: AppTypography.body3.copyWith(
          color: AppColors.neutral4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.neutral4,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.neutral4,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.neutral3,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.semanticRed,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.semanticRed,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),

      /* 
      -------------------------------------------------------------------------------------------------
      DIALOGS & BUTTONS
      -------------------------------------------------------------------------------------------------
      */ 
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary1,
          foregroundColor: Colors.white,
          textStyle: AppTypography.body2.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary1,
          side: BorderSide(color: AppColors.primary1),
          textStyle: AppTypography.body2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}