/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */
import 'package:contratame/src/pages/login/wigdets/input_text_login.dart';
import 'package:contratame/src/utils/extras.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecoverPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(2.0),
                  color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Restablecer la contraseña",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                        "Introduzca su dirección de correo electrónico a continuación te enviaremos un enlace para restablecer su contraseña."),
                    const SizedBox(height: 20.0),
                    InputTextLogin2(
                      icon: FontAwesomeIcons.envelope,
                      placeholder: "Correo electrónico",
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) => Extras.isValidEmail(text),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text("Recover".toUpperCase()),
                          onPressed: () {},
                        )),
                    const SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.grey.shade600,
                        )),
                        const SizedBox(width: 10.0),
                        Text(
                          "Tienes problemas?",
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
                        "Contacta con nosotros".toUpperCase(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {},
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
}
