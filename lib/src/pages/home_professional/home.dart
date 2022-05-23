import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:contratame/src/models/category_model.dart';
import 'package:contratame/src/models/order.dart';
import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/models/usuario.dart';
import 'package:contratame/src/pages/home_professional/widgets/AppointmentFrontCard.dart';
import 'package:contratame/src/services/category_service.dart';
import 'package:contratame/src/services/chat_service.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:contratame/src/services/profesional_service.dart';
import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/utils/text_style.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Position currentPostion;

  const Home({Key key, this.currentPostion}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
      this.chatService = Provider.of<ChatService>(context, listen: false);
      this.socketService = Provider.of<SocketService>(context, listen: false);
      this.authService = Provider.of<AuthService>(context, listen: false);
    });
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final orderService = Provider.of<OrderService>(context);

    return FutureBuilder(
        future: orderService.getOrderByCustomerId(
            authService.usuario.uid, "Pendiente"),
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
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          margin: const EdgeInsets.only(
                              top: 10, left: 10.0, right: 10.0, bottom: 10.0),
                          child: AppointmentFrontCard(
                              btnController: _btnController,
                              imgLink:
                                  snapshot.data[index].customer.profilePicUrl,
                              onAccep: () async {
                                final orderOk = await orderService.updateOrder(
                                    snapshot.data[index].id,
                                    null,
                                    null,
                                    null,
                                    null,
                                    "Aceptado",
                                    null,
                                    null);
                                if (orderOk) {
                                  this.socketService.emit('mensaje-personal', {
                                    'de': this.authService.usuario.uid,
                                    'para': snapshot.data[index].customer.uid,
                                    'mensaje': "Reserva aceptada"
                                  });
                                }

                                setState(() {});
                              },
                              onDecline: () async {
                                final orderOk = await orderService.updateOrder(
                                    snapshot.data[index].id,
                                    null,
                                    null,
                                    null,
                                    null,
                                    "Rechazado",
                                    null,
                                    null);
                                if (orderOk) {
                                  this.socketService.emit('mensaje-personal', {
                                    'de': this.authService.usuario.uid,
                                    'para': snapshot.data[index].customer.uid,
                                    'mensaje': "Reserva rechazada"
                                  });
                                }
                                setState(() {});
                              },
                              customerName:
                                  snapshot.data[index].customer.displayName,
                              jobdescription:
                                  snapshot.data[index].jobdescription,
                              onInfoTapped: () {},
                              appointmentDate: snapshot.data[index].jobStartDate
                                  .toString()
                                  .substring(0, 16),
                              onRedCloseButtonTapped: () {}),
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
