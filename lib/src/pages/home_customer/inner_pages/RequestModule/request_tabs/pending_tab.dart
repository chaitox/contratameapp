import 'package:contratame/src/models/order.dart';
import 'package:contratame/src/models/usuario.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/widgets/request_list.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingTab extends StatefulWidget {
  final Usuario usuario;

  const PendingTab({Key key, @required this.usuario}) : super(key: key);

  @override
  _PendingTabState createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  // final RoundedLoadingButtonController _btnControllerEliminar =
  //     RoundedLoadingButtonController();
  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);
    return FutureBuilder(
        future: orderService.getOrderByCustomerId(widget.usuario.uid, null),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'jobDetails',
                              arguments: {
                                'arg1': snapshot.data[index],
                                'arg2': this.preferences.getBool("isCustomer"),
                              });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             JobDetails()));
                        },
                        child: Dismissible(
                          key: Key('item ${snapshot.data[index]}'),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  Text('Mueve para eliminar',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Eliminar"),
                                  content: const Text(
                                      "¿Estás seguro de que deseas eliminar?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () async {
                                          final deleteOk =
                                              await orderService.deleteOrder(
                                                  snapshot.data[index].id);
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Eliminar")),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: RequestList(
                            this.preferences.getBool("isCustomer")
                                ? snapshot.data[index].professional.displayName
                                : snapshot.data[index].customer.displayName,
                            this.preferences.getBool("isCustomer")
                                ? snapshot
                                    .data[index].professional.profilePicUrl
                                : snapshot.data[index].customer.profilePicUrl,
                            this.preferences.getBool("isCustomer")
                                ? snapshot
                                    .data[index].professional.categories[0].name
                                : "",
                            snapshot.data[index].jobdescription,
                            snapshot.data[index].status,
                            snapshot.data[index].jobStartDate
                                .toString()
                                .substring(0, 10),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(
                      'No hay reservas pendientes',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
