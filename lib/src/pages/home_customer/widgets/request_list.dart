import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  final String name, image, profession, description, status, time;

  RequestList(this.name, this.image, this.profession, this.description,
      this.status, this.time);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final responsive = Responsive.init(context);
    return Card(
      child: ListTile(
        leading: Avatar(
          image: image,
          texto: name,
          radius: 26,
          borderColor: Colors.blue,
        ),

        // Container(
        //   height: responsive.hp(12),
        //   width: responsive.wp(12),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30.0),
        //       image: DecorationImage(
        //           image: NetworkImage(image), fit: BoxFit.cover)),
        // ),
        title: Container(
          height: responsive.hp(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontSize: responsive.dp(1.8)),
                  ),
                  Text(
                    " | $profession.",
                    style: TextStyle(
                        fontSize: responsive.dp(1.3), color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.hp(1),
              ),
              Text(
                description,
                style:
                    TextStyle(color: Colors.grey, fontSize: responsive.dp(1.3)),
              )
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              status,
              style: TextStyle(
                color: Colors.black,
                fontSize: responsive.dp(1.3),
              ),
            ),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey,
                fontSize: responsive.dp(1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
