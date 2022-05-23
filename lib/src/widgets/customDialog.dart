import 'package:contratame/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, assetImage;
  final Image image;
  final double padding, avatarRadius;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
    @required this.assetImage,
    @required this.padding,
    @required this.avatarRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.center,
                child: RoundedButton(
                  label: buttonText,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // child: FlatButton(
                //   onPressed: () {
                //     Navigator.of(context).pop(); // To close the dialog
                //   },
                //   child: Text(buttonText),
                // ),
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset(assetImage)),
          ),
          // child: CircleAvatar(
          //   backgroundColor: Colors.white,
          //   backgroundImage: AssetImage(assetImage),
          //   // backgroundColor: Colors.blueAccent,
          //   radius: avatarRadius,
          // ),
        ),
      ],
    );
  }
}

// class Consts {
//   _();

//   static const double padding = 20.0;
//   static const double avatarRadius = 45.0;
// }
