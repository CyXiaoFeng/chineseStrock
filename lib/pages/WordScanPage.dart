// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ocr_text_recognization/flutter_ocr_text_recognization.dart';

class WordScanPage extends StatefulWidget {
  final String title;
  const WordScanPage({super.key, required this.title});
  @override
  State<StatefulWidget> createState() => _WordScanPage();
}

class _WordScanPage extends State<WordScanPage> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  void setText(value) {
    controller.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.dashboard, color: Colors.white), //自定义图标
              onPressed: () {
                // 打开抽屉菜单
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: TextOrcScan(
                  paintboxCustom: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.0
                    ..color = const Color.fromARGB(153, 102, 160, 241),
                  boxRadius: 12,
                  painBoxLeftOff: 5,
                  painBoxBottomOff: 2.5,
                  painBoxRightOff: 5,
                  painBoxTopOff: 2.5,
                  widgetHeight: MediaQuery.of(context).size.height / 3,
                  getScannedText: (value) {
                    setText(value);
                  },
                ),
              ),
              StreamBuilder<String>(
                stream: controller.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return ScanResult(
                      text: snapshot.data != null ? snapshot.data! : "");
                },
              )
            ],
          ),
        ));
  }
}

class ScanResult extends StatelessWidget {
  const ScanResult({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("识别结果 : $text");
  }
}
