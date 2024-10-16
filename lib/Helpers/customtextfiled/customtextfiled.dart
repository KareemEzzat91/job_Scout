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
  late FocusNode _focusNode;
  Color _iconColor = Colors.grey;


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus ? const Color(0xff0186c7) : Colors.grey;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height * .01,
        ),
        TextFormField(
          obscureText: _obscureText && widget.isPassword,
          enabled: true,
          validator: widget.validator,
          focusNode: _focusNode, // Assign the focus node

          controller: widget.controller,
          cursorHeight: 19,
          decoration: InputDecoration(
            enabled: true ,
            focusColor:  const Color(0xff0186c7),
            hintText: "Enter ${widget.text}",hintStyle: TextStyle(color: _iconColor) ,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color:Color(0xff0186c7)),
              borderRadius: BorderRadius.circular(15),
            ),
            prefixIcon: Icon(
              widget.icon.icon,
              color: _iconColor, // Change icon color dynamically
            ),
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
                color: _iconColor,
              ),
            )
                : null,
          ),
          cursorColor:  const Color(0xff0186c7),
        ),
      ],
    );
  }

}