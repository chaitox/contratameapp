import 'package:contratame/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'request_tabs/completed_tab.dart';
import 'request_tabs/pending_tab.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() {
    return _RequestScreenState();
  }
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  _RequestScreenState() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration:
                new BoxDecoration(color: Theme.of(context).primaryColor),
            child: new TabBar(
              indicatorColor: Colors.white,
              indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.symmetric(horizontal: 40.0)),
              controller: tabController,
              tabs: [
                new Tab(
                  child: Text(
                    'Pendiente',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                new Tab(
                  child: Text(
                    'Completado',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: new TabBarView(
                controller: tabController,
                children: <Widget>[
                  PendingTab(usuario: usuario),
                  CompletedTab(usuario: usuario),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
