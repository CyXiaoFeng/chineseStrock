// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;

class ChildItemPage extends StatefulWidget {
  final String title;
  const ChildItemPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _GetChildItemPageState();
}

class _GetChildItemPageState extends State<ChildItemPage> {
  String? _imageUrl;
  final TextEditingController _textEditingController = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _showClearButton = _textEditingController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.title);
    return Column(
      children: <Widget>[
        Container(height: 10.0),
        _buildQuery(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _buildImage(_imageUrl),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuery() {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
              margin: const EdgeInsets.only(
                  left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
              height: 40.0,
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: '仅能输入一个汉字',
                  border: const OutlineInputBorder(),
                  suffixIcon: _showClearButton
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () {
                              setState(() {
                                _textEditingController.clear();
                                _showClearButton = false;
                                _imageUrl = null;
                              });
                            },
                            child: Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: const Center(
                                child: Icon(Icons.clear, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp(r'[\u4e00-\u9fa5]')),
                ],
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // 灰色背景
                borderRadius: BorderRadius.circular(5), // 圆形边框
                border: Border.all(color: Colors.grey[400]!), // 灰色边框线
              ),
              margin: const EdgeInsets.only(right: 4.0, top: 8.0, bottom: 8.0),
              height: 40.0,
              child: TextButton(
                onPressed: () {
                  _onButtonPressed(_textEditingController.text);
                },
                child: const Text('查询'),
              )),
        ),
      ],
    );
  }

  void _onButtonPressed(String text) {
    print('Text field value: $text');
    // 在这里执行你的方法，可以使用文本字段的值
    _fetchImageUrl(text);
    // request(text);
  }

  Widget _buildImage(imageUrl) {
    try {
      return imageUrl == null
          ? Container()
          : Image(image: NetworkImage(imageUrl));
    } catch (e) {
      return Container(); // 加载失败时返回一个空的容器
    }
  }

  //获取笔顺图片路径
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
