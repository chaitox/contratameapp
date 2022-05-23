import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/services/chat_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/CategoryModule/profile_tabs/about_tab.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/CategoryModule/profile_tabs/reviews_tab.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  _UserProfileState() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Professional professional = ModalRoute.of(context).settings.arguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          Icon(
            Icons.share,
            color: Colors.black54,
          ),
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            children: <Widget>[
              _topStack(
                  professional.displayName,
                  professional.profilePicUrl,
                  professional.categories[0].name,
                  professional.phoneNumber,
                  professional.qualityScore.toStringAsFixed(0),
                  professional.distance.toStringAsFixed(0),
                  professional),
              //_tabView(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)]),
                child: new TabBar(
                  indicatorColor: AppColors.primary,
                  labelColor: Colors.white,
                  controller: tabController,
                  tabs: [
                    new Tab(
                      child: Text(
                        'Acerca',
                        style:
                            TextStyle(fontSize: 16.0, color: AppColors.primary),
                      ),
                    ),
                    new Tab(
                      child: Text(
                        'Comentarios',
                        style:
                            TextStyle(fontSize: 16.0, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height - 350,
                width: MediaQuery.of(context).size.width,
                child: new TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    AboutTab(
                      professional: professional,
                    ),
                    ReviewsTab(
                      professional: professional,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _topStack(String name, image, profession, phoneNumber, rateScore, distance,
      Professional professional) {
    return Stack(
      children: <Widget>[
        Container(
          height: 120.0,
          color: AppColors.primary,
        ),
        Positioned(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60.0,
              ),
              Container(
                  margin: EdgeInsets.only(left: 32, right: 32.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "| $profession",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 32, right: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  phoneNumber,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                                Text(
                                  "Télefono Celular",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.0),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  distance + " km",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                                Text(
                                  "de distancia de ti",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'bookPage',
                                    arguments: professional);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             BookPage()));
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle,
                                      size: 15.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      "Reserva ahora",
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final chatService = Provider.of<ChatService>(
                                    context,
                                    listen: false);
                                // chatService.usuarioPara = usuario;
                                Navigator.pushNamed(context, 'chat');
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (BuildContext context) =>
                                //           ChatPage("Alez john", "Beautician",
                                //               "assets/profile/hatMam.png"),
                                //     ));
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 1)
                                  ],
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.message,
                                      size: 15.0,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      "Mensaje",
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Avatar(
              image: image,
              texto: professional.displayName,
              radius: 50,
              borderColor: Colors.blue,
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 10.0),
            //   height: 100,
            //   width: 100,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     image: DecorationImage(
            //         image: NetworkImage(image), fit: BoxFit.cover),
            //   ),
            // ),
          ],
        ),
        Positioned(
          right: 50,
          top: 70,
          child: Row(
            children: <Widget>[
              Text(
                rateScore,
                style: TextStyle(color: Colors.green, fontSize: 12.0),
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 18.0,
              ),
              Text(
                "(98)",
                style: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
