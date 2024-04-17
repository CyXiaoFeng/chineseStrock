// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WordScanPage extends StatefulWidget {
  final String title;
  const WordScanPage({super.key, required this.title});
  @override
  State<StatefulWidget> createState() => _WordScanPage();
}

class _WordScanPage extends State<WordScanPage> {
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
        body: Text(widget.title));
  }
}
