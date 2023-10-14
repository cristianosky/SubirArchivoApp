import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getItems() async {
  List items = [];
  QuerySnapshot queryItems = await db.collection('items').get();

  // QuerySnapshot queryItems = await collectionReferenceItems.get();

  for (var doc in queryItems.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final item = {
      // "uid": data['uid'],
      "nombre": data['nombre'],
      "nombrearchivo": data['nombrearchivo'],
      "tipo": data['tipo'],
      "id": doc.id,
      "url": data['url']
    };
    // print(item);
    items.add(item);
  }

  return items;
}

Future<void> addItems(String name) async {
  await db.collection('items').add({"nombre": name});
} 

Future<void> deleteItems(String id) async {
  await db.collection('items').doc(id).delete();
}