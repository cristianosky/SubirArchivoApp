import 'dart:io';
import 'package:app/util/showSnackBar.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth dbAuth = FirebaseAuth.instance;
FirebaseStorage dbStorage = FirebaseStorage.instance;

Future<List> getItems() async {
  List items = [];
  QuerySnapshot queryItems = await db.collection('items').where('uid', isEqualTo: dbAuth.currentUser!.uid).get();

  for (var doc in queryItems.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final item = {
      "nombre": data['nombre'],
      "nombrearchivo": data['nombrearchivo'],
      "tipo": data['tipo'],
      "id": doc.id,
      "url": data['url']
    };
    items.add(item);
  }

  return items;
}

Future<void> addItems(String name, String path, BuildContext context) async {
  final nombrearchivoSinformato = File(path).uri.pathSegments.last;
  String nombreSinExtencion = nombrearchivoSinformato.split(".")[0];
  String tipo = path.split(".").last;
  String now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()); 

  String nombreFormateado = '${nombreSinExtencion}_$now.$tipo';

  nombreFormateado = nombreFormateado.replaceAll(' ', '_');
  nombreFormateado = nombreFormateado.replaceAll('/', '_');

  final ref = dbStorage.ref().child('archivos/$nombreFormateado');

  try {
    await ref.putFile(File(path)); // Sube el archivo a Firebase Storage
    final downloadURL = await ref.getDownloadURL(); // Obtiene la URL de descarga del archivo
    // Aquí puedes guardar la URL de descarga en Firebase Realtime Database o Firestore, si es necesario
   try {
      Map<String, String> data = {
        "nombre": name,
        "nombrearchivo": nombreFormateado,
        "tipo": tipo,
        "uid": dbAuth.currentUser!.uid,
        "url": downloadURL
      };
    await db.collection('items').add(data);
   } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context, 'No se pudo subir el archivo');
   }
  } on firebase_storage.FirebaseException {
    // Maneja errores de subida de archivos aquí
    // ignore: use_build_context_synchronously
    showSnackBar(context, 'No se pudo subir el archivo');
  } 
  
} 

Future<void> deleteItems(String id, String nombrearchivo) async {
  await db.collection('items').doc(id).delete();

  deleteAruchivo(nombrearchivo);
}

Future<dynamic> login(String email, String pass, BuildContext context) async {
  try {
    await dbAuth.signInWithEmailAndPassword(email: email, password: pass);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/');
  } on FirebaseAuthException catch (e) {
    if(e.message!.contains("INVALID_LOGIN_CREDENTIALS")) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Datos incorrectos');
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.message!);
    }
  }
}

Future<User> getUser() async {
  return dbAuth.currentUser!;
}

Future<void> cerrarSession(BuildContext context) async {
  await dbAuth.signOut();
  
  // ignore: use_build_context_synchronously
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
}

Future <void> deleteAruchivo(String nombre) async {
  await dbStorage.ref('archivos/$nombre').delete();
}
