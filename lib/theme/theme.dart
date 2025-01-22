import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 공통 텍스트 스타일 생성 함수
TextStyle pingTextStyle(double fontSize,
    {FontWeight fontWeight = FontWeight.normal, required Color mColor}) {
  return TextStyle(
    fontFamily: 'GamTan',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: mColor,
  );
}

// TEXT Theme Setting
TextTheme textTheme({Color mColor = Colors.black}) {
  return TextTheme(
    displayLarge:
        pingTextStyle(32, fontWeight: FontWeight.bold, mColor: mColor),
    displayMedium:
        pingTextStyle(28, fontWeight: FontWeight.bold, mColor: mColor),
    displaySmall:
        pingTextStyle(24, fontWeight: FontWeight.bold, mColor: mColor),
    headlineLarge:
        pingTextStyle(20, fontWeight: FontWeight.normal, mColor: mColor),
    headlineMedium:
        pingTextStyle(16, fontWeight: FontWeight.normal, mColor: mColor),
    headlineSmall:
        pingTextStyle(14, fontWeight: FontWeight.normal, mColor: mColor),
    bodyLarge: pingTextStyle(12, fontWeight: FontWeight.normal, mColor: mColor),
    bodyMedium:
        pingTextStyle(10, fontWeight: FontWeight.normal, mColor: mColor),
    bodySmall: pingTextStyle(8, fontWeight: FontWeight.normal, mColor: mColor),
    titleLarge: pingTextStyle(12, fontWeight: FontWeight.bold, mColor: mColor),
    titleMedium: pingTextStyle(10, fontWeight: FontWeight.bold, mColor: mColor),
    titleSmall: pingTextStyle(8, fontWeight: FontWeight.bold, mColor: mColor),
  );
}

// AppBar Theme Setting
AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: false,
    color: Colors.white,
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: GoogleFonts.dongle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
  );
}

// Bottom NavigationBar Theme Setting
BottomNavigationBarThemeData bottomNavigationBarTheme() {
  return const BottomNavigationBarThemeData(
    selectedItemColor: Color(
        0xFF694F8E), // 선택된 아이템 색상 0xFF009990 0xFF15B392 0xFF73EC8B 0xFF48CFCB 0xFF9DDE8B 0xFF64CCC5
    unselectedItemColor: Color(0xFFB7B7B7), // 선택 안된 아이템 색상
    showUnselectedLabels: true, // 선택 안된 라벨 표시 여부 설정
  );
}

// ThemeData Setting
ThemeData mTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red), // 수동 세팅
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
  );
}
