import 'package:contratame/src/pages/chats/chat_page.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/CategoryModule/book_page.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/CategoryModule/persons_list.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/CategoryModule/user_profile.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/RequestModule/job_details.dart';

import 'package:contratame/src/pages/home_customer/home.dart';

import 'package:contratame/src/pages/home_customer/homePage.dart';
import 'package:contratame/src/pages/home_customer/inner_pages/AccountModule/account_screen.dart';
import 'package:contratame/src/pages/home_professional/homePageProf.dart';
import 'package:contratame/src/pages/loading_page.dart';
import 'package:contratame/src/pages/login/login.dart';
import 'package:contratame/src/pages/login/register.dart';
import 'package:contratame/src/pages/login/wigdets/recover.dart';



import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (_) => HomePage(),
  'home': (_) => Home(),
  'chat': (_) => ChatPage(),
  'loading': (_) => LoadingPage(),
  'profile': (_) => AccountScreen(),
  'profesional': (_) => PersonsList(),
  'homeProfessional': (_) => HomePageProf(),
  'userProfile': (_) => UserProfile(),
  'bookPage': (_) => BookPage(),
  'jobDetails': (_) => JobDetails(),
  'login2': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'recover': (_) => RecoverPasswordPage(),
};
