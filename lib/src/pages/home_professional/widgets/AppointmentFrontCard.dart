import 'package:contratame/src/utils/app_colors.dart';
import 'package:contratame/src/widgets/avatar.dart';
import 'package:contratame/src/widgets/rounded_button.dart';
import 'package:contratame/src/widgets/rounded_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AppointmentFrontCard extends StatefulWidget {
  final String customerName;
  final String jobdescription;
  final Function onInfoTapped;
  final Function onRedCloseButtonTapped;
  final Function onAccep;
  final Function onDecline;
  final String appointmentDate;
  final String imgLink;
  final RoundedLoadingButtonController btnController;
  const AppointmentFrontCard(
      {Key key,
      @required this.imgLink,
      @required this.onAccep,
      @required this.onDecline,
      @required this.customerName,
      @required this.onInfoTapped,
      @required this.appointmentDate,
      @required this.onRedCloseButtonTapped,
      @required this.jobdescription,
      @required this.btnController})
      : super(key: key);
  @override
  _AppointmentFrontCardState createState() => _AppointmentFrontCardState();
}

class _AppointmentFrontCardState extends State<AppointmentFrontCard> {
  bool isinfoPressed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Solicitud de reserva',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 21,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.appointmentDate,
                          style:
                              TextStyle(fontSize: 19.3, color: Colors.white70),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 371,
                      //color: Colors.pink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Avatar(
                              image: widget.imgLink,
                              texto: widget.customerName,
                              radius: 26,
                              borderColor: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.customerName,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 19.3, color: Colors.black87),
                                ),
                                Text(
                                  "Tarea",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                Text(
                                  widget.jobdescription,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.red,
                              child: Icon(
                                Icons.info,
                                size: 38,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        width: 371,
                        //color: Colors.indigo,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 46,
                                child: RoundedButton(
                                  label: 'Aceptar',
                                  onPressed: this.widget.onAccep,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 46,
                                child: RoundedButton(
                                  backgroundColor: AppColors.gray,
                                  backgroundTextColor: Colors.black87,
                                  label: 'Rechazar',
                                  onPressed: this.widget.onDecline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
