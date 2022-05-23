import 'package:animate_do/animate_do.dart';
import 'package:contratame/src/models/category_model.dart';
import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/models/usuario.dart';
import 'package:contratame/src/services/category_service.dart';
import 'package:contratame/src/services/profesional_service.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/utils/text_style.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  final Position currentPostion;

  const Home({Key key, this.currentPostion}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([_header(usuario), _category()])),
        _topProfesionales()
      ],
    );
  }

  Widget _header(Usuario usuario) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola,',
            style: TextStyleNew().greatingText(context),
          ),
          Text(
            '${usuario.displayName}',
            style: TextStyleNew().greatingUserText(context),
          )
        ],
      ),
    );
  }

  Widget _category() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            children: [
              Text(
                'Categorias',
                style: TextStyleNew().profesionalNameText(context),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: CategoryService().getAllCategory(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Categories>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black38)],
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.only(right: 15, left: 15),
                        margin: EdgeInsets.all(5),
                        width: 150,
                        height: 150,
                        child: _serviceCard(category: snapshot.data[index]));
                  },
                );
              } else {
                return Shimmer.fromColors(
                    period: Duration(milliseconds: 5000),
                    child: Text('data'),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[300]);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _serviceCard({Categories category}) {
    return GestureDetector(
        onTap: () => {
              Navigator.pushNamed(context, 'profesional', arguments: [
                category.id,
                category.name,
                this.widget.currentPostion.latitude,
                this.widget.currentPostion.longitude
              ]),
              // print(category.id),
              // Navigator.pushNamed(context, 'profesional',
              //     arguments: category.id),
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElasticIn(
              delay: Duration(milliseconds: 550),
              child: Container(
                  height: 110,
                  child: Image(image: NetworkImage(category.imgPath))),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '${category.name}',
              style: TextStyleNew().profesionalNameText(context),
            )
          ],
        ));
  }

  Widget _topProfesionales() {
    return SliverList(
        delegate: SliverChildListDelegate([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top de profesionales',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      _traerTopProfesionales()
    ]));
  }

  Widget _traerTopProfesionales() {
    final responsive = Responsive.init(context);
    return Container(
        // margin: EdgeInsets.all(10),
        height: responsive.hp(50),
        width: responsive.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black38)]),
        child: this.widget.currentPostion != null
            ? FutureBuilder(
                future: ProfesionalService().getTopProfesional(
                  this.widget.currentPostion.latitude,
                  this.widget.currentPostion.longitude,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Professional>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      // shrinkWrap: true,
                      // physics: ScrollPhysics(),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'userProfile',
                                arguments: snapshot.data[index]);
                          },
                          child: ListTile(
                            leading: Avatar(
                              image: snapshot.data[index].profilePicUrl,
                              texto: snapshot.data[index].displayName,
                              radius: 26,
                              borderColor: Colors.blue,
                            ),
                            //Container(
                            //   height: responsive.hp(12),
                            //   width: responsive.wp(12),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(30.0),
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //               snapshot.data[index].profilePicUrl),
                            //           fit: BoxFit.cover)),
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
                                        snapshot.data[index].displayName,
                                        style: TextStyle(
                                            fontSize: responsive.dp(1.8)),
                                      ),
                                      Text(
                                        " | ${snapshot.data[index].categories[0].name}",
                                        style: TextStyle(
                                            fontSize: responsive.dp(1.3),
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  // Text(
                                  //   "2500",
                                  //   style: TextStyle(
                                  //       color: Colors.grey,
                                  //       fontSize: responsive.dp(1.3)),
                                  // )
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 100.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].qualityScore
                                            .toStringAsFixed(0),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0),
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
                                  "a " +
                                      snapshot.data[index].distance
                                          .toStringAsFixed(0) +
                                      " km",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            : null);
  }
}
