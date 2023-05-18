import 'package:flutter/material.dart';
import '../consts.dart';

class IconItem extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final double size;
  final double padding;
  final bool selected;
  const IconItem(
      {super.key,
      required this.icon,
      this.bgColor = Colors.white,
      this.padding = 7,
      this.selected = true,
      this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Icon(
        icon,
        size: size,
        color: selected ? Const.accentColor : Color.fromARGB(255, 46, 46, 46),
      ),
    );
  }
}
