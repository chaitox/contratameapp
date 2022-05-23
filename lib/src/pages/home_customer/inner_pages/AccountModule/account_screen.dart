import 'package:contratame/src/pages/login/login.dart';
import 'package:contratame/src/services/auth_service.dart';

import 'package:contratame/src/services/socket_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:contratame/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/about_us.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/contact_us.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/faq_terms.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/manage_address.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/privacy_policy.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(
              coverImage: AssetImage('assets/common/headerprofilebg.png'),
              title: "${usuario.displayName}",
              subtitle: this.preferences.getBool("isCustomer")
                  ? "Cliente"
                  : "Professional",
              actions: <Widget>[
                MaterialButton(
                  color: Colors.white,
                  shape: CircleBorder(),
                  elevation: 0,
                  child: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
            _accountItems(
                Icons.location_on, "Manejo de Dirección", "manage", context),
            _accountItems(Icons.markunread, "Contáctenos", "contact", context),
            _accountItems(
                Icons.lock, "Política de privacidad", "privacy", context),
            _accountItems(Icons.contacts, "Sobre nosotros", "about", context),
            _accountItems(
                Icons.line_weight, "Preguntas frecuentes", "faq", context),
            SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () {
                // AuthService().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 2),
                  ],
                ),
                child: Center(
                  child: RoundedButton(
                      onPressed: () {
                        socketService.disconnect();
                        authService.logout();
                        Navigator.popAndPushNamed(context, 'login2');
                        //Navigator.pushReplacementNamed(context, 'login2');

                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     'login', (Route<dynamic> route) => false);
                      },
                      label: "Cerrar sesión"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _accountItems(IconData iconFirst, String title, String goToPageName,
      BuildContext context) {
    return GestureDetector(
      onTap: () => _pageRoute(goToPageName, context),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid,
                color: Colors.grey.withOpacity(0.5),
                width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  iconFirst,
                  color: AppColors.primary,
                  size: 20.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }

  _pageRoute(goToPage, context) {
    if (goToPage == "manage") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ManageAddress()));
    } else if (goToPage == "about") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUs()));
    } else if (goToPage == "contact") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ContactUs()));
    } else if (goToPage == "privacy") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FaqTerms()));
    }
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader({
    Key key,
    @required this.coverImage,
    @required this.title,
    this.subtitle,
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final usuario = authService.usuario;
    return Stack(
      children: <Widget>[
        Ink(
          height: 310,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        // Ink(
        //   height: 200,
        //   decoration: BoxDecoration(
        //     color: Colors.black,
        //   ),
        // ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: usuario.profilePicUrl,
                texto: usuario.displayName,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              // CircleAvatar(
              //   radius: 44.0,
              //   backgroundColor: Colors.grey.shade300,
              //   child: CircleAvatar(
              //     radius: 40,
              //     backgroundImage: (usuario.profilePicUrl == null)
              //         ? null
              //         : NetworkImage(usuario.profilePicUrl),
              //     child: (usuario.profilePicUrl != null)
              //         ? null
              //         : Text(usuario.displayName.substring(0, 2)),
              //     backgroundColor: Colors.blue[100],
              //   ),
              // ),
              // Avatar(
              //   image: avatar,
              //   radius: 40,
              //   backgroundColor: Colors.white,
              //   borderColor: Colors.grey.shade300,
              //   borderWidth: 4.0,
              // ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                // MaterialButton(
                //   color: Colors.white,
                //   shape: CircleBorder(),
                //   elevation: 0,
                //   child: Icon(Icons.logout),
                //   onPressed: () {
                //     socketService.disconnect();
                //     Navigator.pushReplacementNamed(context, 'login');
                //     AuthService.deleteToken();
                //     Navigator.of(context).pushNamedAndRemoveUntil(
                //         'login', (Route<dynamic> route) => false);
                //   },
                // ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
