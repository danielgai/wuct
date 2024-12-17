import 'package:flutter/material.dart';
import 'package:wuct/shared/styled_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool withExtraIcon;
  final Color backgroundColor;
  final VoidCallback? onExtraIconPressed;
  final Icon backIcon;
  final IconData? extraIcon;

  const CustomAppBar({
    super.key,
    required this.label,
    this.withExtraIcon = false,
    this.backgroundColor = const Color.fromRGBO(46, 125, 50, 1),
    this.onExtraIconPressed,
    this.backIcon = const Icon(Icons.arrow_back, color: Colors.white),
    this.extraIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: StyledAppBarText(label),
      centerTitle: true,
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: backIcon,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: withExtraIcon
          ? [
              IconButton(
                icon: Icon(extraIcon, color: Colors.white),
                onPressed: onExtraIconPressed ?? () {},
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
