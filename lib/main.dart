// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化WidgetsBinding
  if (Platform.isAndroid) requestInternetPermission(); // 请求网络权限
  runApp(const MyApp());
}

Future<void> requestInternetPermission() async {
  // 请求网络权限
  var status = await Permission.camera.request();
  if (!status.isGranted) {
    // 如果权限未授予，您可以在这里处理，比如显示一个提示并退出应用
    print('Internet permission not granted');
    // 退出应用
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '汉字笔顺查询',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '汉字笔顺'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _imageUrl =
      'https://hanyu-word-gif.cdn.bcebos.com/b0d9fcfd69c44426ab3626573ac4c62e1.gif';
  late bool _loadingFailed;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('汉字查询'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          children: <Widget>[
            Center(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        labelText: '仅能输入一个汉字',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\u4e00-\u9fa5]')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Align(
                      child: TextButton(
                    onPressed: () {
                      _onButtonPressed(_textEditingController.text);
                    },
                    child: const Text('查询'),
                  ))
                ],
              ),
            )),
            _buildImage(_imageUrl),
            // ElevatedButton(
            //   onPressed: () async {
            //     setState(() {
            //       _inputText = _textEditingController.text;
            //     });
            //     print('Input Text: $_inputText');
            //     // 按钮点击事件
            //     final result = showDialog<String>(
            //         context: context,
            //         builder: (BuildContext context) => AlertDialog(
            //               title: const Text('AlertDialog Title'),
            //               content: Text('输入的文字内容是：$_inputText'),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () => Navigator.pop(context, 'Cancel'),
            //                   child: const Text('OK'),
            //                 )
            //               ],
            //             ));
            //   },
            //   child: const Text('Submit'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(imageUrl) {
    try {
      return Image.network(
        imageUrl,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const CircularProgressIndicator(); // 加载过程中显示进度指示器
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          // setState(() {
          //   _loadingFailed = true; // 设置加载失败标志为true
          // });
          return Container(); // 加载失败时返回一个空的容器
        },
      );
    } catch (e) {
      setState(() {
        _loadingFailed = true; // 设置加载失败标志为true
      });
      return Container(); // 加载失败时返回一个空的容器
    }
  }

  // 检查字符是否为汉字（基于Unicode范围）
  bool isChineseCharacter(String text) {
    if (text.isEmpty) return false;
    String pattern = r'[\u4e00-\u9fa5]';
    return RegExp(pattern).hasMatch(text);
  }

  void _onButtonPressed(String text) {
    print('Text field value: $text');
    // 在这里执行你的方法，可以使用文本字段的值
    _fetchImageUrl(text);
  }

  Future<void> _fetchImageUrl(String text) async {
    String queryUrl =
        'https://hanyu.baidu.com/s?wd=$text&cf=rcmd&t=img&ptype=zici';
    print(queryUrl);
    final response = await http.get(Uri.parse(queryUrl));
    if (response.statusCode == 200) {
      final document = htmlParser.parse(response.body);
      final imageElement =
          document.getElementById('word_bishun'); // 根据实际情况选择相应的选择器

      if (imageElement != null) {
        // imageElement.attributes.forEach((key, value) {
        //   print('$key: $value');
        // });
        String? gifUrl = imageElement.attributes['data-gif'];
        // print(gifUrl);
        setState(() {
          _imageUrl = gifUrl!;
        });
      }
    } else {
      throw Exception('Failed to load image');
    }
  }
}
