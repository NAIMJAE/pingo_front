import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 공통 텍스트 스타일 생성 함수
TextStyle pingTextStyle(double fontSize,
    {fontWeight = FontWeight.normal, mColor = Colors.black}) {
  return GoogleFonts.openSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: mColor,
  );
}

/// 가장 큰 텍스트 (34) - 기본값 bold
TextStyle pingTextH1(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.bold}) =>
    pingTextStyle(34, fontWeight: fontWeight, mColor: mColor);

/// 두 번째 텍스트 (30) - 기본값 bold
TextStyle pingTextH2(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.bold}) =>
    pingTextStyle(30, fontWeight: fontWeight, mColor: mColor);

/// 세 번째 텍스트 (26) - 기본값 bold
TextStyle pingTextH3(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.bold}) =>
    pingTextStyle(26, fontWeight: fontWeight, mColor: mColor);

/// 네 번째 텍스트 (22) - 기본값 bold
TextStyle pingTextH4(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.bold}) =>
    pingTextStyle(22, fontWeight: fontWeight, mColor: mColor);

/// 다섯 번째 텍스트 (18) - 기본값 normal, 매개변수로 bold 가능
TextStyle pingTextH5(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.normal}) =>
    pingTextStyle(18, fontWeight: fontWeight, mColor: mColor);

/// 여섯 번째 텍스트 (14) - 기본값 normal, 매개변수로 bold 가능
TextStyle pingTextH6(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.normal}) =>
    pingTextStyle(14, fontWeight: fontWeight, mColor: mColor);

/// 일곱 번째 텍스트 (12) - 기본값 normal, 매개변수로 bold 가능
TextStyle pingTextH7(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.normal}) =>
    pingTextStyle(12, fontWeight: fontWeight, mColor: mColor);

/// 여덟 번째 텍스트 (10) - 기본값 normal, 매개변수로 bold 가능
TextStyle pingTextH8(
        {Color mColor = Colors.black,
        FontWeight fontWeight = FontWeight.normal}) =>
    pingTextStyle(10, fontWeight: fontWeight, mColor: mColor);
