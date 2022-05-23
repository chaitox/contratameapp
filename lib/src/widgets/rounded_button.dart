import 'package:contratame/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:contratame/src/utils/app_colors.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color backgroundTextColor;
  const RoundedButton(
      {Key key,
      @required this.onPressed,
      @required this.label,
      this.backgroundColor,
      this.backgroundTextColor})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return ElevatedButton(
      child: Text(
        this.label,
        style: TextStyle(
            color: this.backgroundTextColor ?? Colors.white,
            fontFamily: 'sans',
            letterSpacing: 1,
            fontSize: responsive.dp(1.6)),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        elevation: 5,
        primary: this.backgroundColor ?? AppColors.primary,
        // onPrimary: this.backgroundTextColor ?? Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );

    // CupertinoButton(
    //   padding: EdgeInsets.zero,
    //   child: Container(
    //     child: Text(
    //       this.label,
    //       style: TextStyle(
    //           color: Colors.white,
    //           fontFamily: 'sans',
    //           letterSpacing: 1,
    //           fontSize: 18),
    //     ),
    //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    //     decoration: BoxDecoration(
    //       color: this.backgroundColor ?? AppColors.primary,
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black26,
    //           blurRadius: 5,
    //         )
    //       ],
    //       borderRadius: BorderRadius.circular(30),
    //     ),
    //   ),
    //   onPressed: this.onPressed,
    // );
  }
}
