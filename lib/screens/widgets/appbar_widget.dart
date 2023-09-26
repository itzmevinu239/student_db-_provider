import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget> action;
  const AppBarWidget({
    super.key,
    required this.title,
    this.leading = const SizedBox.shrink(),
    this.action = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: action,
      centerTitle: true,
    );
  }
}
