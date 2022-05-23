// import 'dart:async';

// import 'package:contratame/src/models/order.dart';

// class OrderBlock{
//   static final OrderBlock _singleton = OrderBloc._internal();

// OrderBlock._internal(){
//   getOrderById(1);
// }

// factory OrderBlock(){
//   return _singleton;
// }
// /**
//  * 2 opciones
//  * recibir solo order 
//  * o LIst<Order>
//  */
// final _orderController = StreamController<List<Order>>.broadcast();

// Stream<List<Order>> get orderStream => _orderController.stream;


// }