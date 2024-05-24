import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRScanPage extends StatelessWidget {
  final CameraDescription camera;
  const OCRScanPage({super.key, required this.camera});
  final isDebugMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: isDebugMode, //不显示appbar的测试标签
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final barTitle = "开始扫描";
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.chinese);
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(barTitle)),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            XFile file = await _controller.takePicture();
            final inputImage = InputImage.fromFilePath(file.path);
            final recognizedText =
                await _textRecognizer.processImage(inputImage);
            /* String recognizedText = await FlutterTesseractOcr.extractText(
                file.path,
                language: 'eng+chi_sim',
                args: {
                  "preserve_interword_spaces": "1",
                }); */
            _showRecognizedTextDialog(getText(recognizedText));
          } catch (e) {
            print('Error: $e');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  String getText(RecognizedText recognizedText) {
    String scannedText = "";
    List textBlocks = [];
    for (final textBunk in recognizedText.blocks) {
      for (final element in textBunk.lines) {
        for (final textBlock in element.elements) {
          textBlocks.add(textBlock);
          scannedText += " ${textBlock.text}";
        }
      }
    }
    return scannedText;
  }

  void _showRecognizedTextDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recognized Text'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
