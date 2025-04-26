import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
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
      
      BUTTONS

      -------------------------------------------------------------------------------------------------
      */ 

    );
  }
}
