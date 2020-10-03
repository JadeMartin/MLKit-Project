import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class LabelingPage extends StatefulWidget {
  @override
  _LabelingPageState createState() => _LabelingPageState();
}

class _LabelingPageState extends State<LabelingPage> {

  File _imageFile;
  List<ImageLabel> _labels;
  IconData settingsIcon = Icons.photo;
  String mode = "Gallary Mode";
  final picker = ImagePicker();

  void getImageAndDetectLabels() async {
    File pickedFile;
    if(mode == 'Gallary Mode') {
      pickedFile = File((await picker.getImage(source: ImageSource.gallery)).path);
    } else {
      pickedFile = File((await picker.getImage(source: ImageSource.camera)).path);
    }
    final image = FirebaseVisionImage.fromFile(pickedFile);
    final labelDetector = FirebaseVision.instance.imageLabeler();
    final labels = await labelDetector.processImage(image);
    if(mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _labels = labels;
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
        title: Text('Label Detector ' + mode),
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

      body: _imageFile == null ? Container() : ImagesAndLabels(_labels, _imageFile),

      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndDetectLabels,
        tooltip: 'Pick an image',
        child: Icon(settingsIcon),
      ),      
    );
  }
}

class ImagesAndLabels extends StatelessWidget {
  ImagesAndLabels(this.labels, this.imageFile);
  final File imageFile;
  final List<ImageLabel> labels;
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
            children: labels.map<Widget>( (l) => ImageLabels(l)).toList(),
            ),
        ),
      ],
    );
  }
}

class ImageLabels extends StatelessWidget {
  ImageLabels(this.label);
  final ImageLabel label;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Confidence:${(label.confidence * 100).toStringAsFixed(0)}%, Label:${label.text}'),
    );
  }
}