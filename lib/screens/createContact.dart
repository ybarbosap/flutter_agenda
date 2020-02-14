import 'package:flutter/material.dart';
import 'package:flutter_agenda/models/contact.dart';
import 'package:image_picker/image_picker.dart';

class CreateContact extends StatefulWidget {
  Contact contact;

  CreateContact({this.contact});

  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  var nameCtrl = TextEditingController();

  var phoneCtrl = TextEditingController();

  var emailCtrl = TextEditingController();

  Contact _newContact;

  ContactProvider db = ContactProvider();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _newContact = Contact.fromMap(widget.contact.toMap());
      nameCtrl.text = _newContact.name;
      phoneCtrl.text = _newContact.phone;
      emailCtrl.text = _newContact.email;
    } else {
      _newContact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_newContact.name ?? 'New contact'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _buildBottomSheet(context);
            },
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: _newContact.img != null
                  ? Image.asset(_newContact.img)
                  : Icon(
                      Icons.person_add,
                      size: 140,
                      color: Colors.white,
                    ),
            ),
          ),
          _buildTextField(_newContact.name ?? 'Nome', nameCtrl, iconPeople),
          _buildTextField(_newContact.phone ?? 'Phone', phoneCtrl, iconPhone),
          _buildTextField(_newContact.email ?? 'Email', emailCtrl, iconEmail),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _newContact.name = nameCtrl.text;
            _newContact.phone = phoneCtrl.text;
            _newContact.email = emailCtrl.text;
          });
          Navigator.pop(context, _newContact);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  var iconPeople = Icon(Icons.people, color: Colors.deepPurple);
  var iconPhone = Icon(Icons.phone, color: Colors.deepPurple);
  var iconEmail = Icon(Icons.email, color: Colors.deepPurple);

  Widget _buildTextField(
          String label, TextEditingController controller, Icon icon) =>
      Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label, prefixIcon: icon),
        ),
      );

  void _buildBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Text('Camera'),
                    onPressed: () {
                      Navigator.pop(context);
                      ImagePicker.pickImage(source: ImageSource.camera)
                          .then((img) {
                        if (img != null) {
                          setState(() {
                            _newContact.img = img.path;
                          });
                        }
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Galeria'),
                    onPressed: () {
                      Navigator.pop(context);
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((img) {
                        if (img != null) {
                          setState(() {
                            _newContact.img = img.path;
                          });
                        }
                      });
                    },
                  )
                ],
              ),
            );
          },
        );
      });
}
