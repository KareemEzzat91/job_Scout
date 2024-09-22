import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final double height;
  final bool isPassword;
  final Icon icon;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.text,
    required this.height,
    required this.icon,
    this.isPassword = false,
    this.validator,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          height: widget.height * .01,
        ),
        TextFormField(
          obscureText: _obscureText && widget.isPassword,
          autofocus: true,
          enabled: true,
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff58AD53)),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff58AD53)),
              borderRadius: BorderRadius.circular(20),
            ),
            fillColor: Colors.cyan[50], // Change this if you want a different shade or keep it as is
            filled: true, // Make sure to set this to true to apply fillColor
            prefixIcon:widget.icon ,
            suffixIcon: widget.isPassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
              ),
            )
                : null,
          ),
        ),
      ],
    );
  }
}