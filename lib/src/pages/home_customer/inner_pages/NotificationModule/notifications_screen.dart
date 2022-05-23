import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/widgets/notification_list.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        GestureDetector(
          onTap: () => {},
          child: NotificationList(),
        ),
        GestureDetector(
          onTap: () => () {},
          child: NotificationList(),
        ),
        GestureDetector(
          onTap: () => () {},
          child: NotificationList(),
        ),
      ],
    );
  }
}
