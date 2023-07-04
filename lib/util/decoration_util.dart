import 'package:flutter/material.dart';

mixin DecorationUtil {

  static BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.lightBlueAccent.shade100,
        Colors.white,
        Colors.deepPurple.shade100
      ],
    ),
  );

  Widget withScreenDecoration(Widget child){
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: DecorationUtil.gradientDecoration,
      child: SafeArea(child: child),
    );
  }
  
  TextStyle prettifyText(TextStyle style) {
    return style.copyWith(
      color: Colors.lightBlueAccent.shade200,
      fontWeight: FontWeight.w700,
    );
  }

}