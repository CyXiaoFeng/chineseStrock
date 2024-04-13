// import 'page_home.dart';
// import 'page_business.dart';
// import 'page_school.dart';

import 'package:flutter/material.dart';

class BottomAppBarDemo extends StatefulWidget {
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomAppBarDemoState();
  }
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
