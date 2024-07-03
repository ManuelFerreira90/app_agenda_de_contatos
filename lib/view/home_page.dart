import 'dart:io';

import 'package:app_agenda/database/db.dart';
import 'package:app_agenda/model/contact.dart';
import 'package:app_agenda/view/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DB _db = DB();
  List<Contact> _contacts = [];
  OrderOptions selectedOption = OrderOptions.orderAZ;

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contatos',
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
              initialValue: selectedOption,
              onSelected: _onSelected,
              color: Colors.white,
              itemBuilder: (context) {
                return <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem(
                    value: OrderOptions.orderAZ,
                    child: Text(
                      'Ordenar A-Z',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: OrderOptions.orderZA,
                    child: Text(
                      'Ordenar Z-A',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ];
              })
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showOptions(index: index);
            },
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _contacts[index].img != ''
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(_contacts[index].img),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _contacts[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          _contacts[index].email != ''
                              ? Text(
                                  _contacts[index].email,
                                  style: const TextStyle(fontSize: 15),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            _contacts[index].phone,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage(contact: null);
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final Contact? returnedContact = await Navigator.push<Contact?>(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (returnedContact != null) {
      if (contact != null) {
        await _db.updateContact(returnedContact);
      } else {
        await _db.insertContact(returnedContact);
      }
      _getAllContacts();
      _onSelected(selectedOption);
    }
  }

  void _getAllContacts() async {
    _db.queryAllContacts().then((e) {
      setState(() {
        _contacts = e;
      });
    });
  }

  void _showOptions({required int index}) {
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
                          Navigator.pop(context);
                          launchUrlString('tel:${_contacts[index].phone}');
                        },
                        child: const Text(
                          'Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: _contacts[index]);
                        },
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          _db.deleteContact(index);
                          setState(() {
                            _contacts.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
  }

  void _onSelected(OrderOptions value) {
    switch (value) {
      case OrderOptions.orderAZ:
        selectedOption = OrderOptions.orderAZ;
        _contacts.sort((a, b) {
          return (a.name.toLowerCase()).compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
      selectedOption = OrderOptions.orderZA;
        _contacts.sort((a, b) {
          return (b.name.toLowerCase()).compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }
}
