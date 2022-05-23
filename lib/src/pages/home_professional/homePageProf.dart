import 'package:contratame/src/pages/home_customer/inner_pages/ChatModule/chat_screen.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/RequestModule/requests_screen.dart';
import 'package:contratame/src/pages/home_professional/home.dart';
import 'package:contratame/src/pages/usuario.dart';
import 'package:contratame/src/services/bottomNavigationBar_Provider.dart';
import 'package:contratame/src/services/geo_current_position.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:geocoding/geocoding.dart';

import 'package:contratame/src/widgets/bottomNavigationBar/fancy_tab_bar.dart';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/socket_service.dart';

class HomePageProf extends StatefulWidget {
  @override
  _HomePageProfState createState() => _HomePageProfState();
}

class _HomePageProfState extends State<HomePageProf> {
  SocketService socketService;
  AuthService authService;
  GeoServices geoServices;
  Position currentPostion;
  Placemark currentAddress;

  @override
  void initState() {
    super.initState();
    this.geoServices = Provider.of<GeoServices>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    currentPostion = await geoServices.determinePosition();
    currentAddress = await geoServices.getAddressFromLatLng();
    // var position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    //currentPostion = position;

    // passing this to latitude and longitude strings

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var navigatorbarIndex = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      appBar: _callAppBar(navigatorbarIndex.currentIndex),
      body: _callPage(navigatorbarIndex.currentIndex),
      bottomNavigationBar: FancyTabBar(),
    );
  }

  Widget _callPage(int index) {
    switch (index) {
      case 0:
        return RequestScreen();
      case 1:
        return FadeInUp(duration: Duration(seconds: 1), child: Home());
      case 2:
        return UsuariosPage(); //ChatListScreen();
      default:
        return FadeInUp(duration: Duration(seconds: 1), child: Home());
    }
  }

  _callAppBar(int index) {
    switch (index) {
      case 0:
        return _appBarBookin();
      case 1:
        return _appBarHome();
      case 2:
        return _appBarChat();

        break;
      default:
    }
  }

  AppBar _appBarHome() {
    final usuario = authService.usuario;
    return AppBar(
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Localización de Servicios",
              style: TextStyle(fontSize: 15.0, color: Colors.black54)),
          currentPostion == null
              ? Padding(
                  padding: EdgeInsets.only(left: 70.0),
                  child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator()))
              : Text(
                  currentAddress.locality +
                      "\n" +
                      currentPostion.latitude.toString() +
                      ", " +
                      currentPostion.longitude.toString(),
                  style: TextStyle(fontSize: 12.0, color: Color(0xffafc3d2))),
        ],
      ),
      //  Text(
      //   usuario.streetAddress[0].name,
      //   style: TextStyle(fontSize: 15, color: Color(0xffafc3d2)),
      // ),
      titleSpacing: -25,
      centerTitle: false, // <-- and this
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.location_on,
          size: 20,
          color: Color(0xffafc3d2),
        ),
        alignment: Alignment.centerLeft,
        onPressed: () => currentPostion != null
            ? getCurrentLocation()
            : CircularProgressIndicator(),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            child: Avatar(
              image: usuario.profilePicUrl,
              texto: usuario.displayName,
              radius: 26.5,
              backgroundColor: Colors.white,
              borderColor: Colors.grey.shade300,
              borderWidth: 4.0,
            ),
            onTap: () => Navigator.pushNamed(context, 'profile'),
          ),
        )
      ],
    );
  }

  AppBar _appBarBookin() {
    return AppBar(
      title: Text('Reservas', style: TextStyle(color: Colors.black)),
    );
  }

  AppBar _appBarChat() {
    final usuario = authService.usuario;
    return AppBar(
      title: Text(usuario.displayName, style: TextStyle(color: Colors.black87)),
      elevation: 1,
      // leading: IconButton(
      //   icon: Icon(Icons.exit_to_app, color: Colors.black87),
      //   onPressed: () {
      //     socketService.disconnect();
      //     Navigator.pushReplacementNamed(context, 'login');
      //     AuthService.deleteToken();
      //   },
      // ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: (socketService.serverStatus == ServerStatus.Online)
              ? Icon(Icons.check_circle, color: Colors.blue[400])
              : Icon(Icons.offline_bolt, color: Colors.red),
        )
      ],
    );
  }
}
