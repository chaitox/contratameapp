import 'dart:async';

import 'package:contratame/src/pages/login/wigdets/input_text_login.dart';
import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/extras.dart';
import 'package:contratame/src/utils/responsive.dart';
import 'package:contratame/src/widgets/circle_button%20_loading.dart';
import 'package:contratame/src/widgets/customDialog.dart';
import 'package:contratame/src/widgets/rounded_button_loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<InputTextLogin2State> _emailKey = GlobalKey();
  final GlobalKey<InputTextLogin2State> _passwordKey = GlobalKey();
  final RoundedLoadingButtonController _btnControllerLogin =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerFacebook =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnControllerGoogle =
      RoundedLoadingButtonController();
  bool _isCustomer = true;
  int _radioValue = 0;
  SharedPreferences _sharedPreferencesInstance;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    void _handleRadioValueChange(int value) {
      setState(() {
        _radioValue = value;

        switch (_radioValue) {
          case 0:
            _isCustomer = true;
            break;
          case 1:
            _isCustomer = false;
            break;
        }
      });
    }

    Future<void> _submit(RoundedLoadingButtonController controller) async {
      getToken();
      final String email = _emailKey.currentState.value;
      final String password = _passwordKey.currentState.value;

      final bool emailOk = _emailKey.currentState.isOk;
      final bool passwordOk = _passwordKey.currentState.isOk;
      _sharedPreferencesInstance = await SharedPreferences.getInstance();
      if (emailOk && passwordOk) {
        FocusScope.of(context).unfocus();

        final loginOk =
            await authService.login(email.trim(), password.trim(), _isCustomer);

        if (loginOk) {
          socketService.connect();
          if (_isCustomer) {
            _sharedPreferencesInstance.setBool("isCustomer", true);
            Navigator.pushReplacementNamed(context, '/');
          } else {
            Navigator.pushReplacementNamed(context, 'homeProfessional');
            _sharedPreferencesInstance.setBool("isCustomer", false);
          }
        } else {
          controller.error();

          // // Mostara alerta
          // mostrarAlerta(context, 'Login incorrecto',
          //     'Revise sus credenciales nuevamente');
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "Inicio sesión incorrecto",
              avatarRadius: responsive.dp(5),
              padding: responsive.dp(1),
              description: "Revise sus credenciales nuevamente",
              buttonText: "Aceptar",
              assetImage: 'assets/customDialog/icon_warning.png',
            ),
          );

          Timer(Duration(seconds: 2), () {
            controller.reset();
          });
        }
      } else {
        // mostrarAlerta(context, 'Error', 'Los campos son oglitorios');
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "Error",
            avatarRadius: responsive.dp(5),
            padding: responsive.dp(1),
            description: "Los campos son oglitorios",
            buttonText: "Aceptar",
            assetImage: 'assets/customDialog/icon_info.png',
          ),
        );
        controller.reset();
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
            top: 10, left: 10.0, right: 10.0, bottom: 10.0),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 70),
              padding:
                  const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Contratame",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: responsive.dp(4.5),
                          fontFamily: 'raleway',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Inicie sesión con su cuenta",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 20.0),
                    InputTextLogin2(
                      key: _emailKey,
                      icon: FontAwesomeIcons.envelope,
                      placeholder: "Correo electrónico",
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) => Extras.isValidEmail(text),
                    ),
                    // const SizedBox(height: 20.0),
                    InputTextLogin2(
                      key: _passwordKey,
                      icon: FontAwesomeIcons.key,
                      placeholder: "Contraseña",
                      isPassword: true,
                      validator: (text) {
                        return text.trim().length >= 6;
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Olvidó tu contraseña".toUpperCase(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'recover');
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          activeColor: AppColors.primary,
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          "Cliente",
                          style: TextStyle(fontFamily: "sans", fontSize: 12),
                        ),
                        Radio(
                          activeColor: AppColors.primary,
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text("Profesional",
                            style: TextStyle(fontFamily: "sans", fontSize: 12))
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    RoundedButtonLoading(
                        label: "Iniciar sesión",
                        btnController: _btnControllerLogin,
                        onPressed: () => _submit(_btnControllerLogin)),
                    const SizedBox(height: 20.0),
                    Text("O continuar con"),
                    SizedBox(
                      height: responsive.dp(1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleButtonLoading(
                          btnController: _btnControllerFacebook,
                          size: 55,
                          iconPath: FontAwesomeIcons.facebookF,
                          backgroundColor: Colors.blue,
                          onPressed: () async {
                            //   final registroOk =
                            //       await authService.signInWithGoogle(_isCustomer);

                            //   if (registroOk == true) {
                            //     _btnControllerFacebook.success();
                            //     socketService.connect();
                            //     Navigator.pushReplacementNamed(context, '/');
                            //   } else {
                            //     // mostrarAlerta(
                            //     //     context, 'Registro incorrecto', registroOk);
                            //     showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) => CustomDialog(
                            //         title: "Registro incorrecto",
                            //         avatarRadius: responsive.dp(5),
                            //         padding: responsive.dp(1),
                            //         description: registroOk,
                            //         buttonText: "Aceptar",
                            //         assetImage: 'assets/customDialog/icon_error.png',
                            //       ),
                            //     );
                            //   }
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CircleButtonLoading(
                          btnController: _btnControllerGoogle,
                          size: 55,
                          iconPath: FontAwesomeIcons.google,
                          backgroundColor: Colors.red,
                          onPressed: () async {
                            // final registroOk =
                            //     await authService.signInWithGoogle(_isCustomer);
                            // _btnControllerGoogle.success();
                            // socketService.connect();
                            // if (registroOk == true) {
                            //   _btnControllerGoogle.success();
                            //   socketService.connect();
                            //   if (_isCustomer) {
                            //     Navigator.pushReplacementNamed(context, '/');
                            //   } else {
                            //     Navigator.pushReplacementNamed(
                            //         context, 'homeProfessional');
                            //   }
                            // } else {
                            //   // mostrarAlerta(context, 'Registro incorrecto',
                            //   //     'Error en el servidor');
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) => CustomDialog(
                            //       title: "Registro incorrecto",
                            //       avatarRadius: responsive.dp(5),
                            //       padding: responsive.dp(1),
                            //       description: registroOk,
                            //       buttonText: "Aceptar",
                            //       assetImage: 'assets/customDialog/icon_error.png',
                            //     ),
                            //   );
                            //   _btnControllerGoogle.reset();
                            // }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.grey.shade600,
                        )),
                        const SizedBox(width: 10.0),
                        Text(
                          "¿No eres miembro?",
                          // style: smallText,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                            child: Divider(
                          color: Colors.grey.shade600,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      child: Text(
                        "Crear una cuenta".toUpperCase(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'register');
                      },
                    ),
                    const SizedBox(height: 20.0),
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

  void getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FirebaseMessaging.instance.getToken.call().then((token) {
      sharedPreferences.setString('fcmToken', token);
      debugPrint('Token: $token');
    });
  }
}
