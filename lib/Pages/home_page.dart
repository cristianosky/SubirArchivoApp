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
        title: const Text(''),
        backgroundColor: const Color(0xFFF48FB1),
      ),
      drawer: Drawer(
        width: 220,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFF48FB1),
              ),
              child: Text(
                'Subir Archivos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Perfil'),
              onTap: () {
                // Acción a realizar al tocar el elemento "Hola" en el menú lateral
                Navigator.pop(context, '/viewpdf'); // Cierra el menú lateral
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                cerrarSession(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: getItems(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async {
                    await deleteItems(snapshot.data?[index]['id'], snapshot.data?[index]['nombrearchivo']);
                    snapshot.data?.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = false;

                    result = await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text("¿Está seguro de eliminar ${snapshot.data?[index]['nombre']}?"),
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
                    onTap: (() {
                      Navigator.pushNamed(context, '/viewpdf', arguments: {
                        "nombreArchivo": snapshot.data?[index]['nombre'],
                        "url": snapshot.data?[index]['url']
                      }); 
                    }),
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
