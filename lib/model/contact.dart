import 'package:app_agenda/database/db.dart';

class Contact {
  int? id;
  String name;
  String email;
  String phone;
  String img;

  Contact({ this.id, required this.name, required this.phone, this.email = '', this.img = ''});

  Contact.empty()
  :  id = null,
    name = '',
    email = '',
    phone = '',
    img = '';

  Contact.fromMap(Map map) 
  : id = map[idColumn],
    name = map[nameColumn],
    email = map[emailColumn],
    phone = map[phoneColumn],
    img = map[imgColumn];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      nameColumn : name,
      emailColumn : email,
      phoneColumn : phone,
      imgColumn : img
    };
    if(id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $name, email: $email, phone: $phone, img: $img)";
  }
}
