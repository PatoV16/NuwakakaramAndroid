
import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';


class MyApp extends StatefulWidget {
 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  late PDFDocument document;
  String URLpdf = '';
  @override
  void initState() {
    super.initState();
    changePDF();
  }


  changePDF() async {
    setState(() => _isLoading = true);
      document = await PDFDocument.fromURL(
        "https://www.africau.edu/images/default/sample.pdf",);

    return document;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 36),
            
            ListTile(
              title: Text('Load from URL'),
              onTap: () {
                changePDF();
              },
            ),
    
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('PDFViewer'),
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                lazyLoad: false,
                zoomSteps: 1,
                numberPickerConfirmWidget: const Text(
                  "Confirm",
                ),
              ),
      ),
    );
  }
}