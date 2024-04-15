// ignore: file_names

import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final List<BottomNavigationBarItem> bottomNavItems;
  // ignore: prefer_typing_uninitialized_variables
  final void Function(int, Widget?) changePageCallback;

  const BottomNavigation(
      {super.key,
      required this.bottomNavItems,
      required this.changePageCallback});
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => getBTM();
  // ignore: library_private_types_in_public_api
  _BottomNavigationState getBTM() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  void updateState(int index) {
    widget.changePageCallback(index, null);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(items: bottomNavItems);
    List<Map<String, dynamic>> bbi = [];
    int i = 0;
    for (BottomNavigationBarItem element in widget.bottomNavItems) {
      bbi.add({
        "icon": (element.icon as Icon).icon,
        "label": element.label,
        "index": i++,
      });
    }
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
                  callback: updateState,
                  isSelected: item['index'] == selectedIndex,
                ),
              );
            }).toList(),
          ),
        ));
  }
}

//自定义底部导航
class MyBottomAppBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final Function(int) callback;
  final bool isSelected;
  const MyBottomAppBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.callback,
    required this.index,
    required this.isSelected,
  });

  Widget buildItem() {
    return GestureDetector(
        child: InkWell(
      onTap: () => {
        callback(index),
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(label,
              style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return buildItem();
  }
}
