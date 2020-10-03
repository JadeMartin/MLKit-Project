import 'package:flutter/material.dart';
import 'package:mlkitFaceDetection/Views/home.dart';
import './Views/facepage.dart';
import './Views/home.dart';
import './Views/barcodepage.dart';
import './Views/labelingpage.dart';
import './Views/textrecognitionpage.dart';

void main() {
  runApp(MaterialApp(
    title: "MLKit",
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/faceDetector': (context) => FacePage(),
      '/barcodeScanner': (context) => BarcodePage(),
      '/imageLabeling': (context) => LabelingPage(),
      '/textRecognition': (context) => TextRecognitionPage(),
    }
    
  ));
}
