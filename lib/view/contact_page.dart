import 'dart:io';

import 'package:app_agenda/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool userEdited = false;
  final _formKey = GlobalKey<FormState>();
  Contact _editingContact = Contact.empty();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _editingContact = widget.contact!;
      _nameController.text = _editingContact.name;
      _emailController.text = _editingContact.email;
      _phoneController.text = _editingContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _onPopInvoked,
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _editingContact.name == ''
                ? const Text('Novo Contato')
                : Text(_editingContact.name),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showOptions();
                    },
                    child: _editingContact.img != ''
                        ? Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(_editingContact.img),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      userEdited = true;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome do contato vazio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    onChanged: (value) {
                      userEdited = true;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    onChanged: (value) {
                      userEdited = true;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefone do contato vazio';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _editingContact.name = _nameController.text;
                  _editingContact.email = _emailController.text;
                  _editingContact.phone = _phoneController.text;
                });
                Navigator.pop(context, _editingContact);
              }
            },
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _onPopInvoked(bool didPop) async {
    if (didPop) {
      return;
    }
    if (userEdited) {
      final shouldPop = await _showDialog() ?? false;
      if (context.mounted && shouldPop) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      return;
    }
  }

  Future<bool?> _showDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Descastar Alterações?'),
          content: const Text('Se sair as alterações serão perdidas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Sim',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  void _showOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                          onPressed: () {
                            _picker
                                .pickImage(source: ImageSource.camera)
                                .then((file) {
                              if (file == null) {
                                return;
                              }
                              userEdited = true;
                              setState(() {
                                _editingContact.img = file.path;
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Câmera',
                            style: TextStyle(color: Colors.red),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                          onPressed: () {
                            _picker
                                .pickImage(source: ImageSource.gallery)
                                .then((file) {
                              if (file == null) {
                                return;
                              }
                              userEdited = true;
                              setState(() {
                                _editingContact.img = file.path;
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Galeria',
                            style: TextStyle(color: Colors.red),
                          )),
                    ),
                  ],
                );
              });
        });
  }
}
