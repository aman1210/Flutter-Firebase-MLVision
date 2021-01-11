import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  File imgPath;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  List<ImageLabel> labels;

  Future getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        imgPath = File(pickedImage.path);
        detect();
      }
    });
  }

  detect() async {
    final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imgPath);
    labels = await imageLabeler.processImage(visionImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Firebase ML Vision'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imgPath == null)
            Container(
              alignment: Alignment.center,
              child: Text(
                'Please select image',
                textAlign: TextAlign.center,
              ),
            )
          else
            Container(
              height: 400,
              width: double.infinity,
              child: Image.file(
                imgPath,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(
            height: 10,
          ),
          if (labels != null)
            ...labels.map((e) => Text(
                  e.text,
                  style: TextStyle(fontSize: 16),
                ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(
          Icons.camera_enhance,
        ),
      ),
    );
  }
}
