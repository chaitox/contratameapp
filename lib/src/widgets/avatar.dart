import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;
  final String texto;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 2,
      this.texto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: (image == null) ? null : NetworkImage(image),
          child: (image != null) ? null : Text(texto.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
      ),
    );
  }
}
