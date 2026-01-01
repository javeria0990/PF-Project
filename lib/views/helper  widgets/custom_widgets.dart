import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWidgets {
  Widget signInTf({
    required TextEditingController controller,
    required Widget icon,
    required String hint,
    FocusNode? focus,
    TextInputAction? taction,
    void Function(String)? onsubmitted,
    String? Function(String?)? validator,
    bool obsecure = false,
  }) {
    return TextFormField(
      focusNode: focus,
      textInputAction: taction,
      onFieldSubmitted: onsubmitted,
      controller: controller,
      obscureText: obsecure,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: icon,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 1, color: Color(0xff57C785)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
      validator: validator,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
    );
  }

  Widget button({
    FocusNode? focusnode,
    required Widget text,
    required VoidCallback onPressed,
    bool loading = false,
  }) {
    return Focus(
      onKeyEvent: (node, event) {
        if (!loading &&
            event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      focusNode: focusnode,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          
          backgroundColor: Color(0xff57C785),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              )
            : text,
      ),
    );
  }


}
