import 'package:flutter/material.dart';
import 'package:flutter_agenda/models/contact.dart';
import 'package:flutter_agenda/screens/createContact.dart';

class ContactPage extends StatefulWidget {
  Contact contact;
  ContactPage({@required this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactProvider db = ContactProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name ?? ''),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: Colors.black87),
              height: 180,
              width: double.infinity,
              child: Center(
                  child: widget.contact.img != null
                      ? Image.asset(widget.contact.img)
                      : Icon(
                          Icons.perm_media,
                          size: 140,
                          color: Colors.white,
                        ))),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildText('Name', widget.contact.name, context),
                  _buildText('Phone', widget.contact.phone ?? '', context),
                  _buildText('Email', widget.contact.email ?? '', context),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton('Delete', iconDell, context, true, true),
                Container(
                  height: 50,
                  color: Colors.white,
                  width: 1,
                ),
                _buildButton('Edit', iconUpdate, context, false, false),
              ],
            ),
          )
        ],
      ),
    );
  }

  final iconDell = Icon(Icons.delete, color: Colors.white, size: 20);

  final iconUpdate = Icon(Icons.edit, color: Colors.white, size: 20);

  Widget _buildButton(String label, Icon icon, BuildContext context, bool dell,
          bool left) =>
      GestureDetector(
        onTap: () {
          dell
              ? _buildAlert(context)
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateContact(
                            contact: widget.contact,
                          ))).then((newContact) {
                  if (newContact != null) {
                    db.updateContact(newContact);
                    setState(() {
                      widget.contact = newContact;
                    });
                  }
                });
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: left
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30))
                    : BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30))),
            child: left
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      icon,
                      Text(label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      icon
                    ],
                  )),
      );

  Widget _buildText(String labelName, String labelInfo, BuildContext context) =>
      Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              labelName,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
              labelInfo,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            Divider(height: 5)
          ],
        ),
      ));

  Widget _buildAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deseja realmente excluir este contanto ?'),
            content: Text(
                'O contato ${widget.contact.name} será apagado permanentemente do seu dispositivo'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  db.deleteContact(widget.contact.id).then((_) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: Text('Sim'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Não'),
              )
            ],
          );
        });
  }
}
