import 'dart:async';

import 'package:contratame/src/models/category_model.dart';
import 'package:contratame/src/pages/login/wigdets/input_text_login.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/category_service.dart';
import 'package:contratame/src/services/geo_current_position.dart';
import 'package:contratame/src/services/profesional_service.dart';
import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/extras.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/customDialog.dart';
import 'package:contratame/src/widgets/rounded_button_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFormType {
  static final int pageOne = 0;
  static final int pageTwo = 1;
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<InputTextLogin2State> _firstNameKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _lastNameKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _phoneNumberKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _emailKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _passwordKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _vpasswordKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _addressKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _aboutKey = GlobalKey();
  GlobalKey<FormState> _formKeyPageOne = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyPageTwo = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  PageController _pageController =
      PageController(initialPage: RegisterFormType.pageOne);
  SharedPreferences _sharedPreferencesInstance;

  SocketService socketService;
  AuthService authService;
  CategoryService categoryService;
  GeoServices geoServices;
  ProfesionalService profesionalService;

  double lat;
  double long;
  LatLng currentPostion;
  Placemark currentAddress;
  GoogleMapController mapController;
  List<Marker> myMarker = [];
  Future _future;
  bool _isCustomer = true;
  bool _address = true;
  int _radioValueIsCustomer = 0;
  int _radioValueAddress = 0;
  //String _chosenValue;
  Categories selectedCategory;

  @override
  void initState() {
    super.initState();
    this.geoServices = Provider.of<GeoServices>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.categoryService = Provider.of<CategoryService>(context, listen: false);
    this.profesionalService =
        Provider.of<ProfesionalService>(context, listen: false);
    _future = categoryService.getAllCategory();
  }

  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String password;
  String vpassword;
  String name;
  String address;
  String country;
  String state;
  String city;
  String category;
  String about;
  double latitude;
  double longitude;

  bool _agree = false;
  bool firstNameOk;
  bool lastNameOk;
  bool phoneNumberOk;
  bool emailOk;
  bool passwordOk;
  bool vpasswordOk;
  bool addressOk;
  bool categoryOk;
  bool aboutOk;

  _submit(RoundedLoadingButtonController controller) async {
    final responsive = Responsive.init(context);

    country = currentAddress.country;
    state = currentAddress.locality;
    city = currentAddress.locality;
    latitude = currentPostion.latitude;
    longitude = currentPostion.longitude;


    final registroOk = await authService.register(
        firstName.trim(),
        lastName.trim(),
        phoneNumber.trim(),
        email.trim(),
        password.trim(),
        name,
        address.trim(),
        country,
        state,
        city,
        latitude,
        longitude,
        about,
        category,
        _isCustomer);
    try {
      if (registroOk) {
        _sharedPreferencesInstance = await SharedPreferences.getInstance();
        socketService.connect();
        if (_isCustomer) {
          _sharedPreferencesInstance.setBool("isCustomer", true);
          Navigator.pushReplacementNamed(context, '/');
        } else {
          _sharedPreferencesInstance.setBool("isCustomer", false);
          Navigator.pushReplacementNamed(context, 'homeProfessional');
        }
      } else {
        controller.error();
        // mostrarAlerta(context, 'Registro incorrecto', registroOk);
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "Registro incorrecto",
            avatarRadius: responsive.dp(5),
            padding: responsive.dp(1),
            description: registroOk,
            buttonText: "Aceptar",
            assetImage: 'assets/customDialog/icon_error.png',
          ),
        );
        Timer(Duration(seconds: 2), () {
          controller.reset();
        });
      }
    } catch (e) {
      controller.error();
      // mostrarAlerta(context, 'Registro incorrecto', registroOk);
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Registro incorrecto",
          avatarRadius: responsive.dp(5),
          padding: responsive.dp(1),
          description: registroOk,
          buttonText: "Aceptar",
          assetImage: 'assets/customDialog/icon_error.png',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
            top: 10, left: 10.0, right: 10.0, bottom: 10.0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                padding:
                    const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: <Widget>[
                    pageOne(),
                    pageTwo(),
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                height: 100,
                child: Image.asset(
                  "assets/common/top.png",
                  fit: BoxFit.contain,
                )),
          ],
        ),
      ),
    );
  }

  Widget pageOne() {
    final responsive = Responsive.init(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKeyPageOne,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Nueva cuenta",
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: responsive.dp(2.5),
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Cree una cuenta para buscar en línea servicios para su hogar y/o ofrezca sus servicios como profesional.",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: responsive.dp(1),
            ),
            // Center(
            //   child: AvatarButton(
            //     imageSize: responsive.wp(20),
            //   ),
            // ),
            InputTextLogin2(
              key: _firstNameKey,
              icon: FontAwesomeIcons.user,
              placeholder: "Nombre",
              validator: (text) {
                return text.trim().length > 0;
              },
            ),

            InputTextLogin2(
              key: _lastNameKey,
              icon: FontAwesomeIcons.user,
              placeholder: "Apellido",
              validator: (text) {
                return text.trim().length > 0;
              },
            ),

            InputTextLogin2(
              key: _phoneNumberKey,
              icon: FontAwesomeIcons.mobileAlt,
              placeholder: "Número de teléfono",
              validator: (text) {
                return text.trim().length > 8;
              },
            ),

            InputTextLogin2(
              key: _emailKey,
              icon: FontAwesomeIcons.envelope,
              placeholder: "Dirección de correo electrónico",
              keyboardType: TextInputType.emailAddress,
              validator: (text) => Extras.isValidEmail(text),
            ),

            InputTextLogin2(
              key: _passwordKey,
              icon: FontAwesomeIcons.key,
              placeholder: "Contraseña",
              isPassword: true,
              validator: (text) {
                _vpasswordKey.currentState?.checkValidation();
                return text.trim().length >= 6;
              },
            ),

            InputTextLogin2(
              key: _vpasswordKey,
              isPassword: true,
              icon: FontAwesomeIcons.key,
              placeholder: "Confirmar Contraseña",
              validator: (text) {
                return text.trim().length >= 6 &&
                    _vpasswordKey.currentState.value ==
                        _passwordKey.currentState.value;
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  activeColor: AppColors.primary,
                  value: 0,
                  groupValue: _radioValueIsCustomer,
                  onChanged: _handleRadioChangeIsCustomer,
                ),
                Text(
                  "Cliente",
                  style: TextStyle(fontFamily: "sans", fontSize: 12),
                ),
                Radio(
                  activeColor: AppColors.primary,
                  value: 1,
                  groupValue: _radioValueIsCustomer,
                  onChanged: _handleRadioChangeIsCustomer,
                ),
                Text("Profesional",
                    style: TextStyle(fontFamily: "sans", fontSize: 12))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 45.0,
                  ),
                ),

                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.primary),
                  onPressed: () {
                    firstNameOk = _firstNameKey.currentState.isOk;
                    lastNameOk = _lastNameKey.currentState.isOk;
                    phoneNumberOk = _phoneNumberKey.currentState.isOk;
                    emailOk = _emailKey.currentState.isOk;
                    passwordOk = _passwordKey.currentState.isOk;
                    vpasswordOk = _vpasswordKey.currentState.isOk;

                    firstName = _firstNameKey.currentState.value;
                    lastName = _lastNameKey.currentState.value;
                    phoneNumber = _phoneNumberKey.currentState.value;
                    email = _emailKey.currentState.value;
                    password = _passwordKey.currentState.value;
                    vpassword = _vpasswordKey.currentState.value;

                    if (firstNameOk &&
                        lastNameOk &&
                        phoneNumberOk &&
                        emailOk &&
                        passwordOk &&
                        vpasswordOk) {
                      _formKeyPageOne.currentState.save();
                      getCurrentLocation();
                      // if (!_formKeyPageOne.currentState.validate()) {
                      //   return;
                      // }
                      if (_isCustomer) {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          title: "Error",
                          avatarRadius: responsive.dp(5),
                          padding: responsive.dp(1),
                          description: 'Los campos son oglitorios',
                          buttonText: "Aceptar",
                          assetImage: 'assets/customDialog/icon_info.png',
                        ),
                      );
                      // mostrarAlerta(
                      //     context, 'Error', 'Los campos son oglitorios');
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 45.0,
                  ),
                ),
                // RoundedButtonLoading(
                //     btnController: _btnController,
                //     label: "Regístrese",
                //     onPressed: () => _submit(_btnController)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pageTwo() {
    final responsive = Responsive.init(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKeyPageTwo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Agrega tu dirección",
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: responsive.dp(2.0),
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.bold),
            ),

            Text(
              "Mueva el mapa para colocar el marcador en su dirección.",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: responsive.dp(1),
            ),
            // currentPostion == null
            //     ? Container(child: Center(child: CircularProgressIndicator()))
            //     :

            Container(
              width: responsive.wp(90),
              height: responsive.hp(24),
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
                  // scrollGesturesEnabled: true,
                  myLocationEnabled: true,
                  // myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  // zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  // initialCameraPosition: (CameraPosition(
                  //   zoom: 14,
                  //   target: LatLng(
                  //       currentPostion.latitude, currentPostion.longitude),
                  // )),
                  markers: Set.from(myMarker),
                  onTap: _handleTap,
                ),
              ),
            ),
            // SizedBox(
            //   height: responsive.dp(1.5),
            // ),
            InputTextLogin2(
              key: _addressKey,
              icon: FontAwesomeIcons.mapMarkedAlt,
              placeholder: "Dirección",
              validator: (text) {
                return text.trim().length > 0;
              },
            ),
            !_isCustomer
                ? Column(
                    children: [
                      FutureBuilder(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return Text(snapshot.error);

                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
                                hint: Text('Selecciona una categoria'),
                                decoration: new InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),

                                  prefix: Container(
                                    width: responsive.wp(10),
                                    height: responsive.hp(5),
                                    padding: EdgeInsets.only(
                                        right: responsive.dp(0.5),
                                        left: responsive.dp(0.5)),
                                    child: Icon(
                                      FontAwesomeIcons.briefcase,
                                      color: AppColors.primary,
                                    ),
                                  ),

                                  // contentPadding: EdgeInsets.only(
                                  //     right: responsive.dp(0.5),
                                  //     left: responsive.dp(0.5)),
                                ),
                                elevation: 2,
                                iconEnabledColor: AppColors.primary,
                                isExpanded: true,
                                value: selectedCategory,
                                items: snapshot.data
                                    .map<DropdownMenuItem<Categories>>(
                                        (Categories category) {
                                  return DropdownMenuItem<Categories>(
                                    value: category,
                                    child: Text(
                                      category.name,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Categories value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      InputTextLogin2(
                        key: _aboutKey,
                        icon: FontAwesomeIcons.idCard,
                        placeholder: "Acerca de",
                        validator: (text) {
                          return text.trim().length > 0;
                        },
                      ),
                    ],
                  )
                : Row(
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

            DefaultTextStyle(
              style: TextStyle(
                  fontSize: responsive.dp(1.3),
                  color: Theme.of(context).textTheme.subtitle2.color),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: _agree,
                    onChanged: (isChecked) {
                      setState(() {
                        _agree = isChecked;
                      });
                    },
                  ),
                  Text("Estoy de acuerdo con la "),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Términos de servicios",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(" & "),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Política de privacidad",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: responsive.dp(1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.primary),
                  onPressed: () {
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 45.0,
                  ),
                ),
                SizedBox(width: 10),
                RoundedButtonLoading(
                  btnController: _btnController,
                  label: "Regístrese",
                  // onPressed: () => _submit(_btnController),
                  onPressed: () {
                    address = _addressKey.currentState.value;

                    if (_radioValueAddress == 0) {
                      name = "Casa";
                    } else if (_radioValueAddress == 1) {
                      name = "Trabajo";
                    } else {
                      name = "Otro";
                    }
                    addressOk = _addressKey.currentState.isOk;

                    if (_isCustomer) {
                      if (addressOk) {
                        if (_agree) {
                          _formKeyPageTwo.currentState.save();
                          _submit(_btnController);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                              title: "Error",
                              avatarRadius: responsive.dp(5),
                              padding: responsive.dp(1),
                              description:
                                  'Debes aceptar los términos y condiciones',
                              buttonText: "Aceptar",
                              assetImage:
                                  'assets/customDialog/icon_warning.png',
                            ),
                          );

                          _btnController.reset();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                            title: "Error",
                            avatarRadius: responsive.dp(5),
                            padding: responsive.dp(1),
                            description: 'Los campos son oglitorios',
                            buttonText: "Aceptar",
                            assetImage: 'assets/customDialog/icon_info.png',
                          ),
                        );
                        _btnController.reset();
                      }
                    } else {
                      about = _aboutKey.currentState.value;
                      category = selectedCategory.id;
                      aboutOk = _aboutKey.currentState.isOk;
                      if (selectedCategory != null) {
                        categoryOk = true;
                      } else {
                        categoryOk = false;
                      }

                      if (addressOk & categoryOk & aboutOk) {
                        if (_agree) {
                          _formKeyPageTwo.currentState.save();
                          _submit(_btnController);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                              title: "Error",
                              avatarRadius: responsive.dp(5),
                              padding: responsive.dp(1),
                              description:
                                  'Debes aceptar los términos y condiciones',
                              buttonText: "Aceptar",
                              assetImage:
                                  'assets/customDialog/icon_warning.png',
                            ),
                          );
                          // mostrarAlerta(context, 'Error',
                          //     'Debes aceptar los términos y condiciones');

                          _btnController.reset();
                        }
                      } else {
                        // mostrarAlerta(
                        //     context, 'Error', 'Los campos son oglitorios');

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                            title: "Error",
                            avatarRadius: responsive.dp(5),
                            padding: responsive.dp(1),
                            description: 'Los campos son oglitorios',
                            buttonText: "Aceptar",
                            assetImage: 'assets/customDialog/icon_info.png',
                          ),
                        );
                        _btnController.reset();
                      }
                    }

                    // categoryOk = _categoryKey.currentState.isOk;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioChangeAddress(int value) {
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
  }

  void _handleRadioChangeIsCustomer(int value) {
    setState(() {
      _radioValueIsCustomer = value;

      switch (_radioValueIsCustomer) {
        case 0:
          _isCustomer = true;
          break;
        case 1:
          _isCustomer = false;
          break;
      }
    });
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

  void _handleTap(LatLng tappedPoint) {
    currentPostion = tappedPoint;
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            draggable: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(200),
            onDragEnd: (dragEndPosition) {
              currentPostion = dragEndPosition;
              print(dragEndPosition);
            }),
      );
    });
  }
}
