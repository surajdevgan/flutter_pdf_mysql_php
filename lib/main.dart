import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_mysql_php/pdfview.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pdf Viewer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  List pdfList;

  Future fetchAllPdf() async {
    final response = await http
        .get("https://gulatimart.000webhostapp.com/FlutterPdf/Scripts/pdf.php");
    if (response.statusCode == 200) {
      setState(() {
        pdfList = jsonDecode(response.body);
        loading = false;
      });

      print(pdfList);
    }
  }

  @override
  void initState() {
    super.initState();

    fetchAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf List'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: pdfList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewPage(
                                    url: "https://gulatimart.000webhostapp.com/FlutterPdf/Files/"+pdfList[index]['pdffile'], name: pdfList[index]['name'],// here pdffile is column name in mysql, where we have oath of pdf files
                                  )));
                    },
                  ),
                  title: Text(pdfList[index]['name']),
                );
              }),
    );
  }
}
