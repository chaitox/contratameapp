import 'dart:async';

import 'package:contratame/src/pages/home_professional/homePageProf.dart';
import 'package:contratame/src/pages/login/login.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/utils/responsive.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/services/auth_service.dart';

import 'package:contratame/src/pages/home_customer/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  @override
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-0.8, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    Timer(Duration(seconds: 3), () {
      checkLoginState(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(children: <Widget>[
            SlideTransition(
                position: _offsetAnimation,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: "ico",
                      child: Container(
                        height: responsive.height * 0.80,
                        width: responsive.width * 0.80,
                        child: Image.asset('assets/common/top.png'),
                      ),
                    ))),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: responsive.height * 0.6),
                child: Column(
                  children: <Widget>[
                    SlideTransition(
                      position: _offsetAnimation,
                      child: Hero(
                        tag: "ico",
                        child: Text(
                          'Contratame',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: "Manrope",
                              fontSize: responsive.height * 0.06,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.height * 0.05),
                    Text(
                      '"Estamos aquí para ayudar."',
                      style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontSize: responsive.height * 0.03),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    SharedPreferences instance = await SharedPreferences.getInstance();
    // TODO : AQUI VALIDA SI ES CLIENTE O PROFESIONAL
    if (instance.getBool("isCustomer") != null) {
      final autenticado =
          await authService.isLoggedIn(instance.getBool("isCustomer"));

      if (autenticado) {
        socketService.connect();
        if (instance.getBool("isCustomer")) {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(),
                  transitionDuration: Duration(milliseconds: 0)));
        } else {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePageProf(),
                  transitionDuration: Duration(milliseconds: 0)));
        }
      } else {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoginPage(),
                transitionDuration: Duration(milliseconds: 0)));
      }
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
