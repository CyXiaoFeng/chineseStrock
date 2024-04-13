// ignore: file_names

import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomNavItems;
  // ignore: prefer_typing_uninitialized_variables
  final void Function(int) changePageCallback;
  const BottomNavigation(
      {super.key,
      required this.bottomNavItems,
      required this.changePageCallback});

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(items: bottomNavItems);

    List<Map<String, dynamic>> bbi = [
      {
        "icon": Icons.home,
        "label": '首页',
        "index": 0,
      },
      {
        "icon": Icons.message_rounded,
        "label": '消息',
        "index": 1,
      },
      {
        "icon": Icons.people_alt_rounded,
        "label": '我的',
        "index": 2,
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
                  index: item['index'],
                  callback: changePageCallback,
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
  final int index;
  final Function(int) callback;
  const MyBottomAppBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.callback,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => callback(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            Text(label),
          ],
        ));
  }
}
