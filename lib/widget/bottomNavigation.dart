// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomNavItems;
  const BottomNavigation({super.key, required this.bottomNavItems});

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(items: bottomNavItems);
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: const BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: MyBottomAppBarItem(
                  icon: Icons.home,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: MyBottomAppBarItem(
                  icon: Icons.favorite,
                  label: 'Favorites',
                ),
              ),
              Expanded(
                child: MyBottomAppBarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                ),
              ),
            ],
          ),
        ));
  }
}

//TODO:希望导航的内部组件上现边界紧凑一些
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
