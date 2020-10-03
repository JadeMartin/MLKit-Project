import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new RaisedButton(onPressed: () => Navigator.pushNamed(context, '/faceDetector'), child: Text("Face Detector")),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new RaisedButton(onPressed: () => Navigator.pushNamed(context, '/barcodeScanner'), child: Text("Barcode Scanner")),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new RaisedButton(onPressed: () => Navigator.pushNamed(context, '/imageLabeling'), child: Text("Image Labeling")),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new RaisedButton(onPressed: () => Navigator.pushNamed(context, '/textRecognition'), child: Text("Text Recognition")),
          ],
        ),
      )
    );
  }
}
