import 'package:flutter/material.dart';
import 'package:wuct/shared/styled_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool withHamburger;
  final Color backgroundColor;
  final VoidCallback? onHamburgerPressed;

  const CustomAppBar({
    super.key,
    required this.label,
    this.withHamburger = false,
    this.backgroundColor = const Color.fromRGBO(46, 125, 50, 1),
    this.onHamburgerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: StyledAppBarText(label),
      centerTitle: true,
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: withHamburger
          ? [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: onHamburgerPressed ?? () {},
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
