import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/widgets/reviews_list.dart';

class ReviewsTab extends StatelessWidget {
  final Professional professional;

  const ReviewsTab({Key key, @required this.professional}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      itemCount: professional.orders.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () => {},
            child: professional.orders[index].jobComments.isNotEmpty
                ? ReviewsList(
                    professional.orders[index].customer.displayName,
                    professional.orders[index].customer.profilePicUrl,
                    professional.orders[index].jobComments,
                    professional.orders[index].grade.toStringAsFixed(0),
                    professional.orders[index].jobEndDate
                        .toString()
                        .substring(0, 16),
                  )
                : Container(
                    margin: EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Sin comentarios...",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1, color: AppColors.primary);
      },
    );

    // ListView(
    //   children: <Widget>[
    //     GestureDetector(
    //       onTap: () => {},
    //       child: ReviewsList(
    //           "Ramesh Giri",
    //           "assets/profile/hatMam.png",
    //           "Beautician Yes, How can i help youYes, How can i help you",
    //           "4.0",
    //           "21st jan, 18"),
    //     ),
    //     GestureDetector(
    //       onTap: () => () {},
    //       child: ReviewsList(
    //           "Ramesh Giri",
    //           "assets/profile/hatMam.png",
    //           "Beautician Yes, How can i help youYes, How can i help you",
    //           "4.0",
    //           "21st jan, 18"),
    //     ),
    //     GestureDetector(
    //       onTap: () => () {},
    //       child: ReviewsList(
    //           "Ramesh Giri",
    //           "assets/profile/hatMam.png",
    //           "Beautician Yes, How can i help youYes, How can i help you",
    //           "4.0",
    //           "21st jan, 18"),
    //     ),
    //   ],
    // );
  }
}
