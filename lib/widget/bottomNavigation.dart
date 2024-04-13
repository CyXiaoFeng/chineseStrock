// ignore: file_names
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomNavItems;
  const BottomNavigation({super.key, required this.bottomNavItems});

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(items: bottomNavItems);

    List<Map<String, dynamic>> bbi = [
      {
        "icon": Icons.home,
        "label": '首页',
      },
      {
        "icon": Icons.message_rounded,
        "label": '消息',
      },
      {
        "icon": Icons.people_alt_rounded,
        "label": '我的',
      }
    ];

    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bbi.map((item) {
              return Expanded(
                child: MyBottomAppBarItem(
                  icon: item['icon'],
                  label: item['label'],
                ),
              );
            }).toList(),
          ),
        ));
  }
}

//TODO:希望导航的内部组件上现边界紧凑一些
//自定义底部导航
class MyBottomAppBarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const MyBottomAppBarItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(label),
      ],
    );
  }
}

// import 'page_home.dart';
// import 'page_business.dart';
// import 'page_school.dart';

class BottomAppBarDemo extends StatefulWidget {
  @override
  _BottomAppBarDemoState createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ignore: prefer_final_fields
  List<Widget> _bottomNavPages = []; // 底部导航栏各个可切换页面组

  @override
  void initState() {
    super.initState();

    // _bottomNavPages..add(PageHome('首页'))..add(PageBusiness('商城'))..add(PageSchool('课程'))..add(PageBusiness('搜索'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavPages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        // ignore: sort_child_properties_last
        child: Row(
          // ignore: sort_child_properties_last
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.business,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(), // 增加一些间隔
            IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.school,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(2),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        // ignore: prefer_const_constructors
      ),
    );
  }
}
