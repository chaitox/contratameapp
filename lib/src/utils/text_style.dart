import 'package:contratame/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleNew {
  TextStyle greatingText(BuildContext context) {
    final responsive = Responsive.init(context);

    return GoogleFonts.raleway(
        fontSize: responsive.dp(2.5),
        color: Colors.black26,
        fontWeight: FontWeight.bold);
  }

  TextStyle greatingUserText(BuildContext context) {
    final responsive = Responsive.init(context);

    return GoogleFonts.raleway(
        fontSize: responsive.dp(3),
        color: Colors.black,
        fontWeight: FontWeight.bold);
  }

  TextStyle profesionalNameText(BuildContext context) {
    final responsive = Responsive.init(context);

    return GoogleFonts.raleway(
        fontSize: responsive.dp(1.9), fontWeight: FontWeight.bold);
  }

  TextStyle bioTextTitle(BuildContext context) {
    final responsive = Responsive.init(context);

    return GoogleFonts.raleway(
        fontSize: responsive.dp(2.5), fontWeight: FontWeight.bold);
  }

  TextStyle bioTextSubTitle(BuildContext context) {
    final responsive = Responsive.init(context);

    return GoogleFonts.raleway(fontSize: responsive.dp(2.5));
  }
}
