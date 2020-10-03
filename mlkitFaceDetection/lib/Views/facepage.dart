import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {

  File _imageFile;
  List<Face> _faces;
  IconData settingsIcon = Icons.photo;
  String mode = "Gallary Mode";
  final picker = ImagePicker();

  void getImageAndDetectFaces() async {
    File pickedFile;
    if(mode == 'Gallary Mode') {
      pickedFile = File((await picker.getImage(source: ImageSource.gallery)).path);
    } else {
      pickedFile = File((await picker.getImage(source: ImageSource.camera)).path);
    }
    final image = FirebaseVisionImage.fromFile(pickedFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
          mode: FaceDetectorMode.accurate,
        ));
    final faces = await faceDetector.processImage(image);
    if(mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _faces = faces;
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
        title: Text('Face Detector ' + mode),
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

      body: _imageFile == null ? Container() : ImagesAndFaces(_faces, _imageFile),

      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndDetectFaces,
        tooltip: 'Pick an image',
        child: Icon(settingsIcon),
      ),      
    );
  }
}

class ImagesAndFaces extends StatelessWidget {
  ImagesAndFaces(this.faces, this.imageFile);
  final File imageFile;
  final List<Face> faces;
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
            children: faces.map<Widget>( (f) => FaceCoordinates(f)).toList(),
            ),
        ),
      ],
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates(this.face);
  final Face face;
  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, ${pos.left}), (${pos.bottom}, ${pos.right})')
    );
  }
}