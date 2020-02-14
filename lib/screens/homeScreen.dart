import 'package:flutter/material.dart';
import 'package:flutter_agenda/models/contact.dart';
import 'package:flutter_agenda/screens/contactPage.dart';
import 'package:flutter_agenda/screens/createContact.dart';
import 'package:flutter_agenda/widgets/buildContact.widget.dart';
import 'package:flutter_agenda/widgets/imgCircle.dart';
import 'package:flutter_agenda/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContactProvider db = ContactProvider();
  bool finishAwait = false;
  List contacts;

  @override
  void initState() {
    super.initState();
    db.getContacts().then((list) {
      setState(() {
        contacts = list;
        finishAwait = !finishAwait;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.contacts),
            SizedBox(width: 3),
            Text('Agenda')
          ],
        ),
      ),
      body: !finishAwait
          ? Loading()
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                          child: _buildContact(index),
                        ),
                      ),
                      Divider(
                        height: 2,
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateContact()))
              .then((newContact) {
            db.saveContact(newContact);
          }).then((_) {
            db.getContacts().then((newList) {
              _getList();
            });
          });
        },
        child: Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildContact(int index) => Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactPage(
                                contact: contacts[index],
                              ))).then((_) {
                    _getList();
                  });
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: contacts[index].img != null
                            ? CircleImg(
                                contact: contacts[index],
                                height: 50,
                                width: 50,
                              )
                            : Icon(
                                Icons.people,
                                size: 30,
                                color: Colors.white,
                              ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        contacts[index].name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment(1, 0),
            child: IconButton(
              icon: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                launch('tel:${contacts[index].phone}');
              },
            ),
          ),
        ],
      );
  void _getList() async => await db.getContacts().then((lista) {
        setState(() {
          contacts = lista;
        });
      });
}
