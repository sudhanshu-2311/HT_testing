import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  const LoginTextFormField({
    Key key,
    @required TextEditingController codeController,this.hintText,this.iconData
  }) : _codeController = codeController, super(key: key);

  final TextEditingController _codeController;
  final String hintText;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _codeController,
      // textAlign: TextAlign.center,
      autofocus: true,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(iconData),
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
    );
  }
}