// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    requestInternetPermission();
  }
  runApp(const MyApp());
}

Future<void> requestInternetPermission() async {
  const permission = Permission.camera;
  if (await permission.isDenied) {
    final result = await permission.request();

    if (result.isGranted) {
      print("isGranted");
      // Permission is granted
    } else if (result.isDenied) {
      print("isDenied");
      openSettings();
      // Permission is denied
    } else if (result.isPermanentlyDenied) {
      print("isPermanentlyDenied");
      // Permission is permanently denied
    }
  }
  // 请求网络权限
  // var status = await Permission.camera.request();
  // if (!status.isGranted) {
  //   // 如果权限未授予，您可以在这里处理，比如显示一个提示并退出应用
  //   print('Camera permission not granted');
  //   // 退出应用
  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  // }
}

void openSettings() {
  openAppSettings();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '汉字笔顺查询',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '汉字笔顺'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('汉字查询'),
      ),
      body: Center(
        child: Column(
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
    // _fetchImageUrl(text);
    request(text);
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

  request(String key) async {
    try {
      //创建一个HttpClient
      HttpClient httpClient = HttpClient();
      //打开Http连接
      final request = await httpClient.getUrl(Uri.parse(
          "https://hanyu.baidu.com/s?wd=$key&cf=rcmd&t=img&ptype=zici"));
      if (request is BrowserHttpClientRequest) {
        print("browserCredentialsMode");
        request.browserCredentialsMode = true;
      }
      //使用iPhone的UA
      // request.headers.add(
      //   "user-agent",
      //   "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
      // );
      var headers = {
        "Access-Control-Allow-Origin": "*",
        "Accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "en,zh;q=0.9,zh-CN;q=0.8",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
        "Host": "hanyu.baidu.com",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-User": "?1",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
        "sec-ch-ua":
            "\"Google Chrome\";v=\"123\", \"Not:A-Brand\";v=\"8\", \"Chromium\";v=\"123\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Windows\""
      };

      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
      //等待连接服务器（会将请求信息发送给服务器）
      HttpClientResponse response = await request.close();
      //读取响应内容
      print(response.statusCode);

      String text = await response.transform(utf8.decoder).join();
      final document = htmlParser.parse(text);
      final imageElement = document.getElementById('word_bishun');
      String? gifUrl = imageElement?.attributes['data-gif'];
      print(gifUrl);
      //输出响应头
      print(response.headers);

      //关闭client后，通过该client发起的所有请求都会终止。
      httpClient.close();
    } catch (e) {
      print("请求失败：$e");
    } finally {}
  }
}
