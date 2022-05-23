import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:contratame/src/utils/responsive.dart';

class RoundedButtonLoading extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color backgroundTextColor;
  final RoundedLoadingButtonController btnController;
  const RoundedButtonLoading(
      {Key key,
      @required this.onPressed,
      @required this.label,
      this.backgroundColor,
      @required this.btnController,
      this.backgroundTextColor})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return RoundedLoadingButton(
      color: this.backgroundColor ?? AppColors.primary,
      errorColor: Colors.red,
      successColor: Colors.green,
      elevation: 5,
      width: responsive.wp(34),
      child: Text(
        this.label,
        style: TextStyle(
            color: this.backgroundTextColor ?? Colors.white,
            fontFamily: 'sans',
            letterSpacing: 1,
            fontSize: responsive.dp(1.9)),
      ),
      onPressed: this.onPressed,
      controller: btnController,
    );
  }
}
