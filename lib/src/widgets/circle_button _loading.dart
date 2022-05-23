import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:contratame/src/utils/responsive.dart';

class CircleButtonLoading extends StatelessWidget {
  final IconData iconPath;
  final double size;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final RoundedLoadingButtonController btnController;

  const CircleButtonLoading({
    Key key,
    this.size = 50,
    this.backgroundColor,
    @required this.onPressed,
    @required this.iconPath,
    @required this.btnController,
  })  : assert(iconPath != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return RoundedLoadingButton(
      color: this.backgroundColor ?? AppColors.primary,
      errorColor: Colors.red,
      successColor: Colors.green,
      elevation: 5,
      valueColor: Colors.white,
      width: this.size,
      height: this.size,
      controller: btnController,
      onPressed: this.onPressed,
      child: Container(
        width: this.size,
        height: this.size,
        padding: EdgeInsets.all(5),
        child: Icon(
          iconPath,
          //color: Colors.white,
        ),
        decoration: BoxDecoration(
          color: this.backgroundColor ?? AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
