import 'dart:async';

import 'package:contratame/src/models/order.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/ChatModule/chat_page.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/chat_service.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:contratame/src/widgets/circle_button%20_loading.dart';
import 'package:contratame/src/widgets/customDialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class JobDetails extends StatefulWidget {
  @override
  _JobDetailsState createState() {
    return new _JobDetailsState();
  }
}

class _JobDetailsState extends State<JobDetails> {
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  int _currentStep = 0;
  OrderService orderService;
  String jobStartDate;
  String jobComments;
  double grade;
  String orderid;
  bool _isCustomer = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController _jobStartDateController = TextEditingController();
  TextEditingController _jobCommentsController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final initialValue = DateTime.now();

  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();

  Future<void> _submitForm() async {
    final responsive = Responsive.init(context);

    jobStartDate = _jobStartDateController.text;
    jobComments = _jobCommentsController.text;

    if (!_formKey.currentState.validate()) {
      _btnController.error();
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    _formKey.currentState.save();

    final orderOk = await orderService.updateOrder(
        orderid, null, null, jobStartDate, null, null, grade, jobComments);
    setState(() {});
    if (orderOk == true) {
      _btnController.success();
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pop(context);
        _jobStartDateController.clear();
      });
    } else {
      _btnController.error();
      Timer(Duration(seconds: 1), () {
        _btnController.reset();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    this.orderService = Provider.of<OrderService>(context, listen: false);
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    /**
     * block.order();
     * stream(
     * stream = bloc.stream
     * )
     */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;

    final Order order = arg['arg1'];
    _isCustomer = arg['arg2'];
    List<String> status = ['Pendiente', 'Aceptado', 'Procesando', 'Completado'];
    orderid = order.id;
    // switch (order.status.toString()) {
    //   case 'Pendiente':
    //     _currentStep = 0;
    //     break;
    //   case 'Aceptado':
    //     _currentStep = 1;
    //     break;
    //   case 'Rechazado':
    //     _currentStep = 1;
    //     break;
    //   case 'Procesando':
    //     _currentStep = 2;
    //     break;
    //   case 'Completado':
    //     _currentStep = 3;
    //     break;
    //   default:
    //     _currentStep = 0;
    // }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(order.jobdescription),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            color: Colors.white,
            child: _buildImageTopRow(order),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            color: Colors.white,
            child: Center(child: _buildDetailColumn(order)),
          ),
          _midButtons(order),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _showImageDialog(context, order.jobPicUrl),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.0, top: 8.0, right: 16.0, bottom: 16.0),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image(
                                    height: 200,
                                    image: NetworkImage(order.jobPicUrl),
                                    fit: BoxFit.cover)),
                            Positioned(
                              bottom: 20.0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                color: Colors.black.withOpacity(0.7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Foto del trabajo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //  Container(
                  //   height: 200,
                  //   child: Image(
                  //     image: NetworkImage(arg.jobPicUrl),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Estado del trabajo",
                  style: TextStyle(color: Colors.grey),
                ),
                _isCustomer
                    ? Stepper(
                        controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) =>
                            Container(),
                        steps: _processSteps(),
                        currentStep: this._currentStep,
                        onStepTapped: (step) {
                          setState(() {
                            this._currentStep = step;
                          });
                        },
                        // onStepContinue: () async {
                        //   setState(() {
                        //     if (_currentStep < _processSteps().length - 1) {
                        //       _currentStep++;
                        //     } else {
                        //       print("Completed");
                        //     }
                        //   });
                        // },
                        // onStepCancel: () {
                        //   setState(() {
                        //     if (_currentStep > 0) {
                        //       _currentStep--;
                        //     } else {
                        //       _currentStep = 0;
                        //     }
                        //   });
                        // },
                      )
                    : Stepper(
                        onStepContinue: () async {
                          setState(() {
                            if (_currentStep < _processSteps().length - 1) {
                              _currentStep++;
                            } else {
                              print("Completed");
                            }
                          });

                          final orderOk = await orderService.updateOrder(
                              orderid,
                              null,
                              null,
                              null,
                              null,
                              status[_currentStep],
                              null,
                              null);
                          if (orderOk) {
                            this.socketService.emit('mensaje-personal', {
                              'de': this.authService.usuario.uid,
                              'para': order.customer.uid,
                              'mensaje': "Trabajo ${status[_currentStep]}"
                            });
                          }
                        },
                        onStepCancel: () async {
                          setState(() {
                            if (_currentStep > 0) {
                              _currentStep--;
                            } else {
                              _currentStep = 0;
                            }
                          });
                          await orderService.updateOrder(orderid, null, null,
                              null, null, status[_currentStep], null, null);
                        },
                        steps: _processSteps(),
                        currentStep: this._currentStep,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildImageTopRow(Order order) {
    String category;
    order.professional.categories.forEach((element) {
      category = element.name;
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Avatar(
              image: _isCustomer
                  ? order.professional.profilePicUrl
                  : order.customer.profilePicUrl,
              texto: _isCustomer
                  ? order.professional.displayName
                  : order.customer.displayName,
              radius: 38,
              borderColor: Colors.blue,
            ),
            // Container(
            //   height: 75,
            //   width: 75.0,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(37.5),
            //       image: DecorationImage(
            //           image: NetworkImage(order.professional.profilePicUrl),
            //           fit: BoxFit.cover)),
            // ),
            SizedBox(
              width: 20.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  _isCustomer
                      ? order.professional.displayName
                      : order.customer.displayName,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  _isCustomer ? " | " + category : "",
                  style: TextStyle(color: Colors.grey, fontSize: 10.0),
                )
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChatPage(
                      "Alez john", "Beautician", "assets/profile/hatMam.png"),
                ));
          },
          child: Icon(
            Icons.message,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  _buildDetailColumn(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tarea",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            Text(
              order.jobdescription,
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Reserva para",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            Text(
              order.jobStartDate.toString().substring(0, 16),
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Dirección",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            Container(
              width: 180.0,
              child: Text(
                order.jobLocation,
                style: TextStyle(color: Colors.black, fontSize: 12.0),
              ),
            )
          ],
        )
      ],
    );
  }

  _midButtons(Order order) {
    final responsive = Responsive.init(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 20.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
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
                                      await orderService.deleteOrder(orderid);
                                  if (deleteOk == true) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialog(
                                        title: "Eliminar",
                                        avatarRadius: responsive.dp(5),
                                        padding: responsive.dp(1),
                                        description:
                                            "Se elimino correctamente.",
                                        buttonText: "Aceptar",
                                        assetImage:
                                            'assets/customDialog/icon_success.png',
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialog(
                                        title: "Error",
                                        avatarRadius: responsive.dp(5),
                                        padding: responsive.dp(1),
                                        description: "Error al eliminar",
                                        buttonText: "Aceptar",
                                        assetImage:
                                            'assets/customDialog/icon_error.png',
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Eliminar")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancelar"),
                            ),
                          ],
                        );
                      },
                    );
                    // final deleteOk = await orderService.deleteOrder(orderid);
                    // if (deleteOk == true) {
                    //   Navigator.pop(context);
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) => CustomDialog(
                    //       title: "Cancelar",
                    //       avatarRadius: responsive.dp(5),
                    //       padding: responsive.dp(1),
                    //       description: "Se cancelo la reserva correctamente.",
                    //       buttonText: "Aceptar",
                    //       assetImage: 'assets/customDialog/icon_success.png',
                    //     ),
                    //   );
                    // } else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) => CustomDialog(
                    //       title: "Cancelar",
                    //       avatarRadius: responsive.dp(5),
                    //       padding: responsive.dp(1),
                    //       description:
                    //           "Error en cancelar la reserva correctamente.",
                    //       buttonText: "Aceptar",
                    //       assetImage: 'assets/customDialog/icon_error.png',
                    //     ),
                    //   );
                    // }
                  },
                  child: Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => showAlertDialog(order),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  order.status != "Completado"
                      ? Icon(
                          Icons.refresh,
                          color: Colors.grey,
                          size: 20.0,
                        )
                      : Icon(
                          Icons.comment,
                          color: Colors.grey,
                          size: 20.0,
                        ),
                  SizedBox(
                    width: 15.0,
                  ),
                  order.status != "Completado"
                      ? Text(
                          "Reprogramar",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Text(
                          "Comentar",
                          style: TextStyle(color: Colors.grey),
                        )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 20.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                GestureDetector(
                  child: Text(
                    "Ver perfil",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'userProfile',
                        arguments: order.professional);
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  List<Step> _processSteps() {
    final Map arg = ModalRoute.of(context).settings.arguments;

    final Order order = arg['arg1'];
    final bool isCustomer = arg['arg2'];
    List<Step> _steps = [
      Step(
        title: Text("Reserva pendiente"),
        content: Text(
          "Reserva pendiente " + order.createdAt.toString().substring(0, 16),
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: order.status == "Rechazado"
            ? Text("Reserva rechazada", style: TextStyle(color: Colors.red))
            : Text("Reserva aceptada"),
        content: order.status == "Rechazado"
            ? Text(
                "Reserva rechazado el " +
                    order.updatedAt.toString().substring(0, 16),
                style: TextStyle(color: Colors.red, fontSize: 10.0))
            : Text(
                "Reserva aceptado el " +
                    order.updatedAt.toString().substring(0, 16),
                style: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text("Trabajo en proceso"),
        content: Text(
          "Trabajo en proceso " + order.updatedAt.toString().substring(0, 16),
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text("Trabajo terminado"),
        content: Text(
          "Trabajo terminado el " + order.updatedAt.toString().substring(0, 16),
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
        isActive: _currentStep >= 3,
      ),
    ];

    return _steps;
  }

  showAlertDialog(Order order) {
    final responsive = Responsive.init(context);
    Widget okButton = CircleButtonLoading(
        onPressed: () {
          _submitForm();
        },
        size: 60,
        iconPath: FontAwesomeIcons.save,
        // backgroundColor: Colors.blue,
        btnController: _btnController);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: order.status != "Completado"
                  ? Text("Reprogramar reserva")
                  : Text("Comentar trabajo"),
              content: Form(
                key: _formKey,
                child: Container(
                    width: responsive.wp(90),
                    constraints: BoxConstraints(maxHeight: 200),
                    child: order.status != "Completado"
                        ? Column(
                            children: [
                              DateTimeField(
                                format: format,
                                autocorrect: true,
                                autovalidateMode: autoValidateMode,
                                controller: _jobStartDateController,
                                readOnly: true,
                                validator: (date) => date == null
                                    ? 'Selecciona la fecha y hora de la reserva'
                                    : null,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(fontSize: 12),
                                    labelText:
                                        "Selecciona la fecha y hora de la reserva",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.solidCalendarCheck,
                                      color: AppColors.primary,
                                      size: 24,
                                    )),
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: value,
                                      initialDate: currentValue ?? value,
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? value),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                },
                              )
                            ],
                          )
                        : Column(
                            children: [
                              RatingBar.builder(
                                unratedColor: AppColors.gray,
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  grade = rating;
                                },
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText:
                                        "Ingrese un comentario del trabajo recibido: ",
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(
                                      fontFamily: "Sans",
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: "Sans",
                                  ),
                                  maxLines: 3,
                                  controller: _jobCommentsController,
                                  autovalidateMode: autoValidateMode,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Ingrese un comentario";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
              ),
              actions: [
                okButton,
              ],
            );
          },
        );
      },
    );
  }

  _showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
