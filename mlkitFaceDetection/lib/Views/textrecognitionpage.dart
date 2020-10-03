import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class TextRecognitionPage extends StatefulWidget {
  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {

  File _imageFile;
  VisionText _text;
  IconData settingsIcon = Icons.photo;
  String mode = "Gallary Mode";
  final picker = ImagePicker();

  void getImageAndDetectText() async {
    File pickedFile;
    if(mode == 'Gallary Mode') {
      pickedFile = File((await picker.getImage(source: ImageSource.gallery)).path);
    } else {
      pickedFile = File((await picker.getImage(source: ImageSource.camera)).path);
    }
    final image = FirebaseVisionImage.fromFile(pickedFile);
    final textDetector = FirebaseVision.instance.textRecognizer();
    final text = await textDetector.processImage(image);
    if(mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _text = text;
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
        title: Text('Text Detector ' + mode),
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

      body: _imageFile == null ? Container() : ImagesAndText(_text, _imageFile),

      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndDetectText,
        tooltip: 'Pick an image',
        child: Icon(settingsIcon),
      ),      
    );
  }
}

class ImagesAndText extends StatelessWidget {
  ImagesAndText(this.text, this.imageFile);
  final File imageFile;
  final VisionText text;
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
          child: Text(text.text),
        ),
      ],
    );
  }
}