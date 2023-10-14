import 'package:app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Archivos'),
        backgroundColor: const Color(0xFFF48FB1),
      ),
      body: FutureBuilder(
        future: getItems(), 
        builder: ((context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direfction) async {
                    // print(snapshot.data?[index]['id']);
                    await deleteItems(snapshot.data?[index]['id']);
                    snapshot.data?.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = false;

                    result = await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text("¿Esta seguro de eliminar ${snapshot.data?[index]['nombre']}?"),
                        actions: [
                          TextButton(onPressed: () {
                            return Navigator.pop(context, false);
                          }, child: const Text("No", style: TextStyle(color: Colors.red),)),
                          TextButton(onPressed: () {
                            return Navigator.pop(context, true);
                          }, child: const Text("Si")),
                        ],
                      );
                    });

                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.startToEnd,
                  key: Key(snapshot.data?[index]['id']),
                  child: ListTile(
                    title: Text(snapshot.data?[index]['nombre']),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() { });
        },
        backgroundColor: Colors.pink[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}