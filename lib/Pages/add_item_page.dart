
import 'package:app/services/firebase_service.dart';
import 'package:app/util/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController nombreController = TextEditingController(text: "");

  String? _filePath; // Almacena la ruta del archivo seleccionado

  // Función para seleccionar un archivo
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _filePath = result.files.single.path;
      // Puedes usar _filePath para trabajar con el archivo seleccionado
    } else {
      // El usuario canceló la selección
    }

    setState(() {}); // Actualiza la interfaz de usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Item'),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
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
            ElevatedButton(onPressed:  _pickFile, style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[200]!)
            ), child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_file),
                SizedBox(width: 8),
                Text('Seleccionar archivo')
              ],
            )),
            ElevatedButton(onPressed: () async {
              // print(nombreController.text);
              if(nombreController.text.isEmpty || _filePath == null){
                showSnackBar(context, 'Debe ingresar un nombre o seleccionar un archivo');
              }else{
                await addItems(nombreController.text, _filePath!, context).then((_) {
                  Navigator.pop(context);
                });
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[200]!)
            ), child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save),
                SizedBox(width: 8),
                Text('Guardar')
              ],
            )
            )
          ],
        ),
        ),
      ),
    );
  }
}