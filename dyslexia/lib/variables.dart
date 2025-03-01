import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App information
const String appTitle = 'Dyslexia';
const int appVersion = 1;
const String appAuthor = 'Flutter Team';
const String appDescription =
    'Mobile and Simulation-based Approach to reduce Dyslexia with children Learning Disabilities';
const String appLicense = 'MIT License';
const String appCopyright =
    'Copyright (c) RP 24-25-133 Team. All rights reserved.';
const String appUrl = 'https://flutter.dev';

// Asset paths
const String appIcon = 'assets/images/app_icon.png';
const String appBackground = 'assets/images/app_background.jpg';

// get converteed color here
// https://jonas-rodehorst.dev/tools/flutter-color-from-hex

// Colors
const Color appPrimaryColor = Color(0xFF9370DB); // Purple
const Color appSecondaryColor = Color(0xFF554997); // Darker purple
const Color appTextColor = Color(0xFF4F4B65);
const Color appBackgroundColor = Color(0xFFF0EFF4);
const Color HeadingColor = Color.fromARGB(255, 0, 0, 0);
const Color appTogglebuttonColor = Color(0xFF4F4B65);
const Color appButtonColor = Color.fromARGB(187, 167, 125, 251); // Purple
const Color cardBackgroundcolor = Color(0xFFE5E5EF);
const Color cardBordercolor = Color(0xFF9370DB);
const Color editbuttonColor = Color(0xFF4F4B65);
const Color menuColor = Color(0xFF554997);

// Font styles using Poppins
final TextStyle headingStyle = GoogleFonts.poppins(
  fontSize: 36,
  fontWeight: FontWeight.bold,
  color: appTextColor,
);
// Body style
final TextStyle bodyStyle = GoogleFonts.poppins(
  fontSize: 18,
  color: appTextColor,
);

// Small font style
final TextStyle smallTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: appTextColor,
);

final TextStyle registerheadingStyle = GoogleFonts.poppins(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: HeadingColor,
);
final TextStyle registerbodyStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: HeadingColor,
);
final TextStyle registerbodyboldStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HeadingColor,
);
final TextStyle cardheadingStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HeadingColor,
);
final TextStyle cardbodyStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: HeadingColor,
);
final TextStyle childcardbodyStyle = GoogleFonts.poppins(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: HeadingColor,
);

final TextStyle editButtontextStyle = GoogleFonts.poppins(
  fontSize: 16,
  color: editbuttonColor,
  fontWeight: FontWeight.w600,
);

final TextStyle menuAppLogoStyle = GoogleFonts.pacifico(
  fontSize: 20,
  color: menuColor,
);
final TextStyle menuAppHeadingStyle = GoogleFonts.poppins(
  fontSize: 26,
  color: menuColor,
);
