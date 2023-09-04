import 'package:flutter/material.dart';

class customTextField extends StatelessWidget {
  const customTextField(
      {Key? key,
      this.textEditingController,
      this.icon,
      this.isScure,
      this.hint,
      required this.textInputType})
      : super(key: key);
  final TextEditingController? textEditingController;
  final Icon? icon;
  final bool? isScure;
  final String? hint;
  final enableEdit = true;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: isScure!,
        keyboardType: textInputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              width: 1,
              color: Color(0XFF7e65bf),
            )),
            isCollapsed: false,
            isDense: true,
            focusColor: Colors.blue,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Color(0XFF7e65bf),
              ),
            ),
            prefixIcon: icon,
            prefixStyle: const TextStyle(color: Colors.black),
            prefixIconColor: Colors.black),
      ),
    );
  }
}
