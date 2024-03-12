import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewrwe extends StatefulWidget {
  var url;
  PDFViewrwe({super.key,this.url});

  @override
  State<PDFViewrwe> createState() => _PDFViewrweState();
}

class _PDFViewrweState extends State<PDFViewrwe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("PDF"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: 500,
              height: MediaQuery.of(context).size.height,
              child: SfPdfViewer.network(
                  canShowPageLoadingIndicator: false,
                  widget.url.toString()),
            )
          ],
        ),
      ),
    );
  }
}