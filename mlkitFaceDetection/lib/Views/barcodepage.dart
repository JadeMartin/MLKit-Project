import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class BarcodePage extends StatefulWidget {
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {

  File _imageFile;
  List<Barcode> _barcodes;
  IconData settingsIcon = Icons.photo;
  String mode = "Gallary Mode";
  final picker = ImagePicker();

  void getImageAndDetectBarcodes() async {
    File pickedFile;
    if(mode == 'Gallary Mode') {
      pickedFile = File((await picker.getImage(source: ImageSource.gallery)).path);
    } else {
      pickedFile = File((await picker.getImage(source: ImageSource.camera)).path);
    }
    final image = FirebaseVisionImage.fromFile(pickedFile);
    final barcodeDetector = FirebaseVision.instance.barcodeDetector();
    final barcode = await barcodeDetector.detectInImage(image);
    if(mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _barcodes = barcode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: Text('Barcode Detector ' + mode),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if(mode == 'Gallary Mode') {
                    settingsIcon = Icons.camera_alt;
                    mode = 'Camera Mode';
                } else {
                    settingsIcon = Icons.photo;
                    mode = 'Gallary Mode';
                }
              });
            },
            icon: Icon(settingsIcon)
          ),
        ],
      ),

      body: _imageFile == null ? Container() : ImagesAndBarcodes(_barcodes, _imageFile),

      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndDetectBarcodes,
        tooltip: 'Pick an image',
        child: Icon(settingsIcon),
      ),      
    );
  }
}

class ImagesAndBarcodes extends StatelessWidget {
  ImagesAndBarcodes(this.barcodes, this.imageFile);
  final File imageFile;
  final List<Barcode> barcodes;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        )),
        Flexible(
          flex: 1,
          child: ListView(
            children: barcodes.map<Widget>( (b) => BarcodeInfo(b)).toList(),
            ),
        ),
      ],
    );
  }
}

class BarcodeInfo extends StatelessWidget {
  BarcodeInfo(this.barcode);
  final Barcode barcode;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Barcode format:${barcode.format} Barcode value:${barcode.displayValue}')
    );
  }
}