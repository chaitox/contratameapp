import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  final Professional professional;

  const AboutTab({Key key, @required this.professional}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(professional.about),
              SizedBox(
                height: 20.0,
              ),
              // Text(
              //   "Services",
              //   style: TextStyle(color: AppColors.primary, fontSize: 16.0),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // Text(
              //   "Tab, Wash Basin and Shink Problem\nBathroom watter Fitter\nBathroom Fittings",
              // )
            ],
          ),
        )
      ],
    );
  }
}
