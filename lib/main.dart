// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chinesestrock/widget/BottomNavigation.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';

import 'pages/StrockQueryPage.dart';
import 'pages/WordScanPage.dart';

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    requestPermission();
  }
  runApp(const MyApp());
}

//请求权限
Future<void> requestPermission() async {
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
}

//打开安的原生设置界面
void openSettings() {
  openAppSettings();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //不显示appbar的测试标签
      title: '汉字笔顺查询',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          bottomAppBarTheme: const BottomAppBarTheme()),
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
  int currentPage = 0;
  final pages = [
    const StrockQueryPage(title: "笔顺查询"),
    const WordScanPage(title: "文字扫描"),
    const StrockQueryPage(title: "我的")
  ];
  BottomNavigation? bnav;

  @override
  void initState() {
    super.initState();
    bnav = getNav();
  }

  final List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.image_search),
      label: '笔顺查询',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.scanner),
      label: '文字扫描',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people_alt_rounded),
      label: '我的',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: getNav(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: pages[currentPage]);
  }

  BottomNavigation getNav() {
    return BottomNavigation(
      bottomNavItems: navItems,
      changePageCallback: _changePage,
    );
  }

  void _changePage(int index, Widget? widget) {
    // print((widget as MyBottomAppBarItem).index);
    if (index != currentPage) {
      setState(() {
        currentPage = index;
        // bnav?.changTab(currentPage);
      });
    }
  }

  // 检查字符是否为汉字（基于Unicode范围）
  bool isChineseCharacter(String text) {
    if (text.isEmpty) return false;
    String pattern = r'[\u4e00-\u9fa5]';
    return RegExp(pattern).hasMatch(text);
  }

  //httpclient发起请求
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
