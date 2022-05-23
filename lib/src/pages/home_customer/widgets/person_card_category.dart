import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/ChatModule/chat_page.dart';

class CategoryPersonCard extends StatelessWidget {
  final String name, image, profession, price, reviews, distance;

  CategoryPersonCard(this.name, this.image, this.profession, this.price,
      this.reviews, this.distance);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    // TODO: implement build
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
        //     borderRadius: BorderRadius.circular(30.0),
        //     image:
        //         DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        //   ),
        // ),
        title: Container(
          height: 80.0,
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
                  Text(" | $profession.",
                      style: TextStyle(
                          fontSize: responsive.dp(1.3), color: Colors.grey)),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                price,
                style:
                    TextStyle(color: Colors.grey, fontSize: responsive.dp(1.3)),
              )
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    reviews,
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 14.0,
                  )
                ],
              ),
            ),
            Text(
              distance,
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
