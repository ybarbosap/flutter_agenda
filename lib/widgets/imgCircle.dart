import 'package:flutter/material.dart';
import 'package:flutter_agenda/models/contact.dart';

class CircleImg extends StatelessWidget {
  Contact contact;
  double width;
  double height;

  CircleImg(
      {@required this.contact, @required this.width, @required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(contact.img),
            )));
  }
}
