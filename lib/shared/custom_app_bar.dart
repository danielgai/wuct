import 'package:flutter/material.dart';
import 'package:wuct/shared/styled_text.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    required String label,
    Color super.backgroundColor = const Color.fromRGBO(46, 125, 50, 1),
  }) : super(
          title: StyledAppBarText(label),
          centerTitle: true,
        );
}
