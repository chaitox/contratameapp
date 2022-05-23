import 'package:contratame/src/models/order.dart';
import 'package:contratame/src/models/usuario.dart';
import 'package:contratame/src/pages/home_customer/widgets/request_list.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  final Usuario usuario;

  ChatListScreen({@required this.usuario});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);

    // TODO: IMPLEMENTACION DEL CHAT
    return FutureBuilder(
      future:
          orderService.getOrderByCustomerId(widget.usuario.uid, 'Pendiente'),
      builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print('abrir chat');
                      },
                      child: RequestList(
                        snapshot.data[index].professional.displayName,
                        snapshot.data[index].professional.profilePicUrl,
                        snapshot.data[index].professional.categories[0].name,
                        snapshot.data[index].jobdescription,
                        snapshot.data[index].status,
                        snapshot.data[index].jobStartDate
                            .toString()
                            .substring(0, 10),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No hay reservas pendientes',
                    style: TextStyle(fontSize: 15),
                  ),
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
