import 'package:contratame/src/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'package:contratame/src/utils/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputTextLogin2 extends StatefulWidget {
  final IconData icon;
  final String placeholder, initValue;
  final bool Function(String text) validator;
  final bool isPassword;

  final TextInputType keyboardType;

  const InputTextLogin2(
      {Key key,
      @required this.icon,
      @required this.placeholder,
      this.validator,
      this.initValue = '',
      this.isPassword = false,
      this.keyboardType = TextInputType.text})
      : assert(icon != null && placeholder != null),
        super(key: key);

  @override
  InputTextLogin2State createState() => InputTextLogin2State();
}

class InputTextLogin2State extends State<InputTextLogin2> {
  TextEditingController _controller;
  bool _validationOk = false;
  bool _obscureText = false;

  bool get isOk => _validationOk;
  String get value => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initValue);

    checkValidation();
    _obscureText = this.widget.isPassword;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void checkValidation() {
    if (widget.validator != null) {
      final bool isOk = widget.validator(_controller.text);
      if (_validationOk != isOk) {
        setState(() {
          _validationOk = isOk;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(responsive.width * 0.02, 0,
          responsive.width * 0.04, responsive.width * 0.04),
      child: TextFormField(
        controller: _controller,
        onChanged: (text) => checkValidation(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: responsive.height * 0.01,
            bottom: responsive.height * 0.01,
          ),
          // suffix: widget.validator != null
          //     ? Icon(
          //         Icons.check_circle,
          //         color: _validationOk ? AppColors.primary : Colors.black12,
          //       )
          //     : null,
          suffix: this.widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    !_obscureText
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                  ),
                )
              : null,
          suffixIcon: widget.validator != null
              ? Icon(
                  Icons.check_circle,
                  color: _validationOk ? AppColors.primary : Colors.black12,
                )
              : null,
          icon: Icon(
            this.widget.icon,
            color: AppColors.primary,
            size: responsive.height * 0.03,
          ),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2)),
          labelText: this.widget.placeholder,
          labelStyle: TextStyle(
              fontFamily: "Poppins", fontSize: responsive.height * 0.022),
        ),
        style: TextStyle(
            fontFamily: "Manrope", fontSize: responsive.height * 0.022),
        keyboardType: this.widget.keyboardType,
        obscureText: _obscureText,
      ),
    );
  }
}
