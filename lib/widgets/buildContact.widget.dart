import 'package:flutter/material.dart';
import 'package:flutter_agenda/models/contact.dart';
import 'package:flutter_agenda/screens/contactPage.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildContact extends StatefulWidget {
  ContactProvider db;
  List<Contact> contacts;
  int index;

  BuildContact(
      {@required this.db, @required this.contacts, @required this.index});

  @override
  _BuildContactState createState() => _BuildContactState();
}

class _BuildContactState extends State<BuildContact> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
