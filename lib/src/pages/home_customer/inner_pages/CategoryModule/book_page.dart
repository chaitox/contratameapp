import 'dart:async';
import 'dart:io';

import 'package:contratame/src/models/professional.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:contratame/src/widgets/circle_button%20_loading.dart';
import 'package:contratame/src/widgets/customDialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:image_picker/image_picker.dart';

// For changing the language
// import 'package:flutter_localizations/flutter_localizations.dart';
class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() {
    return new _BookPageState();
  }
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  AuthService authService;
  OrderService orderService;
  final ImagePicker _picker = ImagePicker();
  String customer = "";
  String professional = "";
  String jobLocation = "";
  String jobdescription = "";
  String jobStartDate;
  var _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController _jobStartDateController = TextEditingController();
  TextEditingController _jobLocationController = TextEditingController();
  TextEditingController _jobdescriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.orderService = Provider.of<OrderService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitForm(RoundedLoadingButtonController controller) async {
    final responsive = Responsive.init(context);
    jobLocation = _jobLocationController.text;
    jobdescription = _jobdescriptionController.text;
    //DateFormat("yyyy-MM-dd hh:mm a")
    // jobStartDate = new DateFormat("MM/dd/yyyy HH:mm:ss")
    //     .parse(_jobStartDateController.text);
    // jobStartDate = DateTime.parse(_jobStartDateController.text);
    jobStartDate = _jobStartDateController.text;

    if (!_formKey.currentState.validate()) {
      controller.error();
      Timer(Duration(seconds: 2), () {
        controller.reset();
      });
      return;
    }
    _formKey.currentState.save();
    final orderOk = await orderService.addOrder(customer, professional,
        jobdescription, jobLocation, jobStartDate, _image.path);
    if (orderOk == true) {
      controller.success();
      // mostrarAlerta(context, 'Registro incorrecto', registroOk);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Reserva",
          avatarRadius: responsive.dp(5),
          padding: responsive.dp(1),
          description: "Se realizo la reserva correctamente.",
          buttonText: "Aceptar",
          assetImage: 'assets/customDialog/icon_success.png',
        ),
      );
      Timer(Duration(seconds: 2), () {
        controller.reset();
      });
    } else {
      controller.error();
      // mostrarAlerta(context, 'Registro incorrecto', registroOk);
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Guardado incorrecto",
          avatarRadius: responsive.dp(5),
          padding: responsive.dp(1),
          description: orderOk,
          buttonText: "Aceptar",
          assetImage: 'assets/customDialog/icon_error.png',
        ),
      );
      Timer(Duration(seconds: 2), () {
        controller.reset();
      });
    }
  }

  int _radioValueAddress;
  bool _address = true;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final initialValue = DateTime.now();

  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Professional arg = ModalRoute.of(context).settings.arguments;
    // TODO: Guardar reserva
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Reservar ahora",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          CircleButtonLoading(
              onPressed: () {
                customer = authService.usuario.uid;
                professional = arg.id;
                _submitForm(_btnController);
              },
              size: 40,
              iconPath: FontAwesomeIcons.check,
              // backgroundColor: Colors.blue,
              btnController: _btnController),
          SizedBox(width: 10.0)
          // Icon(
          //   Icons.check,
          //   color: AppColors.primary,
          // ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              _topStack(arg),
              Container(
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                              firstDate: DateTime.now(),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            activeColor: AppColors.primary,
                            value: 0,
                            groupValue: _radioValueAddress,
                            onChanged: _handleRadioChangeAddress,
                          ),
                          Text(
                            "Casa",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          ),
                          Radio(
                            activeColor: AppColors.primary,
                            value: 1,
                            groupValue: _radioValueAddress,
                            onChanged: _handleRadioChangeAddress,
                          ),
                          Text(
                            "Trabajo",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          ),
                          Radio(
                            activeColor: AppColors.primary,
                            value: 2,
                            groupValue: _radioValueAddress,
                            onChanged: _handleRadioChangeAddress,
                          ),
                          Text(
                            "Otro",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          )
                        ],
                      ),
                      TextFormField(
                        onChanged: (String value) {
                          setState(() {
                            this.jobLocation = value;
                          });
                        },
                        autovalidateMode: autoValidateMode,
                        decoration: InputDecoration(
                            labelText: "Ingresa la dirección completa",
                            prefixIcon: Icon(
                              FontAwesomeIcons.mapMarkedAlt,
                              color: AppColors.primary,
                              size: 24,
                            )),
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 14),
                        controller: _jobLocationController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Ingrese la dirección";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText:
                              "Ingrese una descripción del trabajo a solicitar: ",
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            fontFamily: "Sans",
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: "Sans",
                        ),
                        maxLines: 3,
                        controller: _jobdescriptionController,
                        autovalidateMode: autoValidateMode,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Ingrese la descripción";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo_size_select_actual),
                              onPressed: _seleccionarFoto,
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _tomarFoto,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(child: _previewImages()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

// elegir o tomar una foto y guardarla en la variable foto de tipo File
  _procesarImagen(ImageSource origen) async {
    XFile image = await _picker.pickImage(source: origen, imageQuality: 80);

    // if (foto != null) {
    //   //limpieza
    //   // foto =
    //   //     null; // borro el url de la foto anterior para que fotoUrl sea null y pueda mostrar una nueva foto.
    // }

    setState(() {
      _image = File(image.path);
    });
  }

  Widget _previewImages() {
    if (_image != null) {
      return Container(
        child: Image.file(
          File(_image.path),
          height: 300.0,
        ),
      );
    } else if (_image != null) {
      return Text(
        'Pick image error:',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Aún no has elegido una imagen.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _handleRadioChangeAddress(int value) {
    final usuario = authService.usuario;
    String addressCasa = "";
    String addressTrabajo = "";
    String addressOtro = "";
    usuario.streetAddress.forEach((element) {
      if (element.name == "Casa") {
        addressCasa = element.address + ", " + element.city;
      } else if (element.name == "Trabajo") {
        addressTrabajo = element.address + ", " + element.city;
        ;
      } else {
        addressOtro = element.address + ", " + element.city;
        ;
      }
    });
    setState(() {
      _radioValueAddress = value;

      switch (_radioValueAddress) {
        case 0:
          _address = true;

          _jobLocationController.text = addressCasa;

          break;
        case 1:
          _address = false;
          _jobLocationController.text = addressTrabajo;

          break;
        case 2:
          _address = false;
          _jobLocationController.text = addressOtro;

          break;
      }
    });
  }
}

_topStack(Professional professional) {
  String category;
  professional.categories.forEach((element) {
    category = element.name;
  });
  return Stack(
    children: <Widget>[
      Container(
        height: 120.0,
        color: AppColors.primary,
      ),
      Positioned(
        top: 10,
        left: 20,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Avatar(
                    image: professional.profilePicUrl,
                    texto: professional.displayName,
                    radius: 40,
                    borderColor: Colors.blue,
                  ),
                  // Container(
                  //   height: 60.0,
                  //   width: 60,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(30.0),
                  //     image: DecorationImage(
                  //         image: NetworkImage(professional.profilePicUrl)),
                  //   ),
                  // ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            professional.displayName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          Text(
                            " | " + category,
                            style: TextStyle(
                                color: Colors.white70, fontSize: 16.0),
                          )
                        ],
                      ),
                      Text(
                        professional.phoneNumber,
                        style: TextStyle(color: Colors.white70, fontSize: 14.0),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}


// ListTile(
                        //   leading: Icon(
                        //     FontAwesomeIcons.calendarCheck,
                        //     size: 20,
                        //     color: AppColors.primary,
                        //   ),
                        //   title: DateTimeField(
                        //     controller: _jobStartDateController,
                        //     decoration: InputDecoration(
                        //         hintText:
                        //             'Selecciona la fecha y hora de la reserva'),
                        //     format: format,
                        //     onShowPicker: (context, currentValue) async {
                        //       final date = await showDatePicker(
                        //           context: context,
                        //           firstDate: DateTime(1900),
                        //           initialDate: currentValue ?? DateTime.now(),
                        //           lastDate: DateTime(2100));
                        //       if (date != null) {
                        //         final time = await showTimePicker(
                        //           context: context,
                        //           initialTime: TimeOfDay.fromDateTime(
                        //               currentValue ?? DateTime.now()),
                        //         );
                        //         return DateTimeField.combine(date, time);
                        //       } else {
                        //         return currentValue;
                        //       }
                        //     },

                        //     // autovalidateMode: autoValidateMode,
                        //     validator: (date) => date == null
                        //         ? 'Selecciona la fecha y hora de la reserva'
                        //         : null,
                        //     // initialValue: initialValue,
                        //     onChanged: (date) => setState(() {
                        //       value = date;
                        //     }),
                        //     onSaved: (date) => setState(() {
                        //       value = date;
                        //     }),
                        //     resetIcon:
                        //         showResetIcon ? Icon(Icons.delete) : null,
                        //     readOnly: readOnly,
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     await showDatePicker(
                        //         context: context,
                        //         locale: Locale('es'),
                        //         firstDate: DateTime.now(),
                        //         initialDate: DateTime.now(),
                        //         lastDate: DateTime(2100));

                        //     final time = await showTimePicker(
                        //         context: context,
                        //         initialTime:
                        //             TimeOfDay.fromDateTime(DateTime.now()));
                        //     final dropDate =
                        //         DateTimeField.combine(DateTime.now(), time);

                        //     // print(DateFormat("MM/dd/yyyy HH:mm:ss")
                        //     //     .format(dropDate));
                        //     setState(() {
                        //       _jobStartDateController.value = TextEditingValue(
                        //           text: DateFormat("MM/dd/yyyy HH:mm")
                        //               .format(dropDate));
                        //     });
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     padding: EdgeInsets.symmetric(horizontal: 10),
                        //     alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(8),
                        //             bottomLeft: Radius.circular(8),
                        //             topRight: Radius.circular(8),
                        //             bottomRight: Radius.circular(8)),
                        //         border: Border.all(
                        //             width: 1, color: AppColors.primary)),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             Icon(FontAwesomeIcons.calendarCheck,
                        //                 size: 20, color: AppColors.primary),
                        //             SizedBox(
                        //               width: 15,
                        //             ),
                        //             Text(
                        //               _jobStartDateController.text.isEmpty
                        //                   ? "Selecciona la fecha y hora de la reserva"
                        //                   : "${_jobStartDateController.text}",
                        //               style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w400,
                        //                   color: Colors.black.withOpacity(.6)),
                        //             ),
                        //           ],
                        //         ),
                        //         _jobStartDateController.text.isNotEmpty
                        //             ? GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     _jobStartDateController.clear();
                        //                   });
                        //                 },
                        //                 child: Icon(Icons.close))
                        //             : Text("")
                        //       ],
                        //     ),
                        //   ),
                        // ),
