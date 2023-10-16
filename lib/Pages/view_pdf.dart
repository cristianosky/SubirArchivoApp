
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfPage extends StatefulWidget {
  const ViewPdfPage({super.key});

  @override
  State<ViewPdfPage> createState() => _ViewPdfPageState();
}

class _ViewPdfPageState extends State<ViewPdfPage> {
  TextEditingController url = TextEditingController(text: "");
  TextEditingController nombreArchivo = TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Archivo'),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SfPdfViewer.network(arguments["url"])
      ),
    );
  }
}