import 'dart:async';

import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/geo_current_position.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/circle_button%20_loading.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ManageAddress extends StatefulWidget {
  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  TextEditingController _addressController = TextEditingController();

  GeoServices geoServices;
  AuthService authService;
  int _radioValueAddress = 0;
  bool _address = true;
  double lat;
  double long;
  LatLng currentPostion;
  String name;
  String address;
  String country;
  String state;
  String city;
  double latitude;
  double longitude;
  Placemark currentAddress;
  GoogleMapController mapController;
  List<Marker> myMarker = [];

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent[200],
        content: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        margin: EdgeInsets.all(30.0),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            label: 'Aceptar',
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<void> _submitForm() async {
    final responsive = Responsive.init(context);
    if (_radioValueAddress == 0) {
      name = "Casa";
    } else if (_radioValueAddress == 1) {
      name = "Trabajo";
    } else {
      name = "Otro";
    }
    address = _addressController.text;
    country = currentAddress.country;
    state = currentAddress.locality;
    city = currentAddress.locality;
    latitude = currentPostion.latitude;
    longitude = currentPostion.longitude;

    if (!_formKey.currentState.validate()) {
      _btnController.error();
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    _formKey.currentState.save();

    final addressOk = await authService.addAddress(name, address, country,
        state, city, latitude, longitude, authService.usuario.uid);

    setState(() {});
    if (addressOk == true) {
      _btnController.success();
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
        _addressController.clear();
        setState(() {});
      });
    } else {
      _showToast(context, addressOk);
      _btnController.error();
      Timer(Duration(seconds: 1), () {
        _btnController.reset();
      });
    }
  }

  void initState() {
    super.initState();
    this.geoServices = Provider.of<GeoServices>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final usuario = authService.usuario;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Manejo de Dirección",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70.0,
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Row(
              children: <Widget>[
                Text(
                  "Dirección guardada",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                )
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: usuario.streetAddress.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key('item ${usuario.streetAddress[index]}'),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      usuario.streetAddress.removeAt(index);
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
                                      await authService.deleteAddress(
                                          usuario.streetAddress[index].id,
                                          usuario.uid);
                                  Navigator.of(context).pop(true);
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
                  },
                  child: _setAddress(
                      usuario.streetAddress[index].name,
                      usuario.streetAddress[index].address +
                          ", " +
                          usuario.streetAddress[index].city +
                          " - " +
                          usuario.streetAddress[index].country),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () => showAlertDialog(),
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle,
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Agregar",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _setAddress(String place, String location) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                place,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              Icon(
                Icons.edit,
                color: Colors.grey,
              )
            ],
          ),
          SizedBox(
            width: 15.0,
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 20.0,
              ),
              SizedBox(width: 15.0),
              Expanded(
                  child: Text(
                location,
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              )),
            ],
          ),
          // SizedBox(
          //   width: 15.0,
          //   height: 20.0,
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Icon(
          //       Icons.phone_android,
          //       color: Colors.grey,
          //       size: 20.0,
          //     ),
          //     SizedBox(width: 15.0),
          //     Expanded(
          //         child: Text(
          //       phone,
          //       style: TextStyle(color: Colors.grey, fontSize: 12.0),
          //     )),
          //     SizedBox(
          //       width: 20.0,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  showAlertDialog() {
    setState(() {});
    final responsive = Responsive.init(context);
    Widget okButton = CircleButtonLoading(
        onPressed: () => _submitForm(),
        size: 60,
        iconPath: FontAwesomeIcons.save,
        // backgroundColor: Colors.blue,
        btnController: _btnController);
    Widget backButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: AppColors.primary),
      onPressed: () {
        _addressController.clear();
        myMarker = [];
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: 35.0,
      ),
    );
    getCurrentLocation();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text("Agregar dirección"),
              content: Form(
                key: _formKey,
                child: Container(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Mueva el mapa para colocar el marcador en su dirección.",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: responsive.dp(1),
                      ),
                      Container(
                        width: responsive.wp(80),
                        height: responsive.hp(20),
                        child: Center(
                          child: GoogleMap(
                            initialCameraPosition: (CameraPosition(
                              zoom: 5,
                              target: LatLng(-23.442503, -58.443832),
                            )),
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer()))
                              ..add(
                                Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer()),
                              )
                              ..add(
                                Factory<HorizontalDragGestureRecognizer>(
                                    () => HorizontalDragGestureRecognizer()),
                              )
                              ..add(
                                Factory<ScaleGestureRecognizer>(
                                    () => ScaleGestureRecognizer()),
                              ),
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            onMapCreated: _onMapCreated,
                            markers: Set.from(myMarker),
                            onTap: (LatLng tappedPoint) {
                              currentPostion = tappedPoint;
                              print(tappedPoint);
                              setState(() {
                                myMarker = [];
                                myMarker.add(
                                  Marker(
                                      markerId:
                                          MarkerId(tappedPoint.toString()),
                                      position: tappedPoint,
                                      draggable: true,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              200),
                                      onDragEnd: (dragEndPosition) {
                                        currentPostion = dragEndPosition;
                                        print(dragEndPosition);
                                      }),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsive.dp(1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            activeColor: AppColors.primary,
                            value: 0,
                            groupValue: _radioValueAddress,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueAddress = value;

                                switch (_radioValueAddress) {
                                  case 0:
                                    _address = true;

                                    break;
                                  case 1:
                                    _address = false;

                                    break;
                                  case 2:
                                    _address = false;

                                    break;
                                }
                              });
                            },
                          ),
                          Text(
                            "Casa",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          ),
                          Radio(
                            activeColor: AppColors.primary,
                            value: 1,
                            groupValue: _radioValueAddress,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueAddress = value;

                                switch (_radioValueAddress) {
                                  case 0:
                                    _address = true;

                                    break;
                                  case 1:
                                    _address = false;

                                    break;
                                  case 2:
                                    _address = false;

                                    break;
                                }
                              });
                            },
                          ),
                          Text(
                            "Trabajo",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          ),
                          Radio(
                            activeColor: AppColors.primary,
                            value: 2,
                            groupValue: _radioValueAddress,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueAddress = value;

                                switch (_radioValueAddress) {
                                  case 0:
                                    _address = true;

                                    break;
                                  case 1:
                                    _address = false;

                                    break;
                                  case 2:
                                    _address = false;

                                    break;
                                }
                              });
                            },
                          ),
                          Text(
                            "Otro",
                            style: TextStyle(fontFamily: "sans", fontSize: 12),
                          )
                        ],
                      ),
                      TextFormField(
                        controller: _addressController,
                        autovalidateMode: autoValidateMode,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Ingrese una dirección";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: responsive.height * 0.01,
                            bottom: responsive.height * 0.01,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.locationArrow,
                            color: AppColors.primary,
                            size: responsive.height * 0.03,
                          ),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                          labelText: "Dirección",
                          labelStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: responsive.height * 0.022),
                        ),
                        style: TextStyle(
                            fontFamily: "Manrope",
                            fontSize: responsive.height * 0.022),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButton,
                    okButton,
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getCurrentLocation() async {
    var position = await geoServices.determinePosition();
    currentAddress = await geoServices.getAddressFromLatLng();
    // var position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings

    setState(() {
      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: LatLng(lat, long),
            tilt: 30.0,
            zoom: 17.0,
          ),
        ),
      );
      currentPostion = LatLng(lat, long);
    });
  }
}
