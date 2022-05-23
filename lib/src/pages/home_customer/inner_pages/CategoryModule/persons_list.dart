import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/services/profesional_service.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/widgets/person_card_category.dart';

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  Widget build(BuildContext context) {
    final List arg = ModalRoute.of(context).settings.arguments;

    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: (Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(arg[1]),
            SizedBox(
              width: 10.0,
            ),
            Icon(
              Icons.search,
              color: Colors.black54,
            )
          ],
        )),
      ),
      body: FutureBuilder(
          future: ProfesionalService()
              .getProfessionalByCategoryLocation(arg[0], arg[2], arg[3], 18),
          builder: (BuildContext context,
              AsyncSnapshot<List<Professional>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            /*Navigator.pushNamed(context, 'userProfile',
                            arguments: [category[0], category[1]]);*/
                            Navigator.pushNamed(context, 'userProfile',
                                arguments: snapshot.data[index]);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             UserProfile()));
                          },
                          child: CategoryPersonCard(
                              snapshot.data[index].displayName,
                              snapshot.data[index].profilePicUrl,
                              arg[1],
                              "",
                              snapshot.data[index].qualityScore
                                  .toStringAsFixed(0),
                              // snapshot.data[index].orders[index].grade.toString(),
                              "a " +
                                  snapshot.data[index].distance
                                    .toStringAsFixed(0) +
                                  " km"),
                        );
                      })
                  : Center(
                      child: Text(
                        'No hay profesional disponible',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
