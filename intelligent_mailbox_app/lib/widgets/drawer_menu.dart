import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onSignOut;
  final String selectedMailbox;
  final List<String> mailboxes;
  //final ValueChanged<String?> onMailboxChanged;

  const DrawerMenu({
    super.key,
    required this.onSignOut,
    required this.selectedMailbox,
    required this.mailboxes,
    //required this.onMailboxChanged,
  });

  _onChange(String? newValue){
    print(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Seleccionar Buzón'),
            trailing: DropdownButton<String>(
              value: selectedMailbox,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: _onChange,
              items: mailboxes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}