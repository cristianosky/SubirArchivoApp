import 'package:app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController nombreController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Item'),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                hintText: "Ingresar Nombre",
                focusColor: Color.fromARGB(255, 244, 143, 177),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 244, 143, 177)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 244, 143, 177))
                )
              ),
              
            ),
            ElevatedButton(onPressed: () async {
              // print(nombreController.text);
              await addItems(nombreController.text).then((_) {
                Navigator.pop(context);
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[200]!)
            ), child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}