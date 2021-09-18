import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sma_mobile/pages/news/index.dart';
import 'package:sma_mobile/pages/portfolio/index.dart';
import 'package:sma_mobile/pages/settings/index.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _BottomNavigatorState();
  }

}

class _BottomNavigatorState extends State<BottomNavigator> {

  final List<_BottomItems> items = [
    _BottomItems(Icons.important_devices_outlined, "组合"),
    _BottomItems(Icons.article_outlined, "资讯"),
    _BottomItems(Icons.manage_accounts, "个人"),
  ];
  final List<Widget> components = [
    const Portfolio(),
    const NewsPage(),
    const SettingsPage()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: components[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: items.map((item) =>BottomNavigationBarItem(icon: Icon(item.icon), label: item.name)).toList(),
        currentIndex: _currentIndex,
        onTap: (index)=>{
          setState((){
            _currentIndex = index;
          })
        },
      ),
    );
  }

}

class _BottomItems {
  String name;
  IconData icon;

  _BottomItems(this.icon, this.name);
}