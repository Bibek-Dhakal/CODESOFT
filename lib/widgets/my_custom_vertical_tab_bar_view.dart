/// widgets/my_custom_vertical_tab_bar_view.dart

import 'package:flutter/material.dart';

/// tab bar item model
class TabBarItem {
  final IconData? icon;
  final String text;
  TabBarItem({required this.icon, this.text = ''});
}

/// my custom vertical tab bar view
class MyCustomVerticalTabBarView extends StatefulWidget {
  final List<TabBarItem> tabBarItems;
  final List<Widget> contentsArray;
  final int initialIndex;
  final double tabBarWidth;
  final double tabBarHeight;
  final Color tabBarColor;
  final Color unselectedTabItemColor;
  final Color selectedTabItemColor;

  const MyCustomVerticalTabBarView({
    Key? key,
    required this.tabBarItems,
    required this.contentsArray,
    required this.initialIndex,
    required this.tabBarWidth,
    required this.tabBarHeight,
    required this.tabBarColor,
    required this.unselectedTabItemColor,
    required this.selectedTabItemColor,
  }) : super(key: key);

  @override
  State<MyCustomVerticalTabBarView> createState() => MyCustomTabBarViewState();
}

class MyCustomTabBarViewState extends State<MyCustomVerticalTabBarView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _currentIndex = widget.initialIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// Vertical Tab items Bar
          SingleChildScrollView(
            child: Container(
              height: widget.tabBarHeight,
              width: widget.tabBarWidth,
              color: widget.tabBarColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildTabItems(widget.tabBarItems),
              ),
            ),
          ),

          /// Vertical Tab View contents
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: widget.contentsArray,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildTabItems(List<TabBarItem> tabBarItems) {
    /// as map is used because index too needed.
    return tabBarItems.asMap().entries.map((MapEntry<int, TabBarItem> entry) {
      int index = entry.key;
      TabBarItem tabBarItem = entry.value;

      return Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Container(
            width: widget.tabBarWidth,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.red, width: 2),
            // ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  tabBarItem.icon,
                  color: (index == _currentIndex)
                      ? widget.selectedTabItemColor
                      : widget.unselectedTabItemColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  tabBarItem.text,
                  style: TextStyle(
                    color: (index == _currentIndex)
                        ? widget.selectedTabItemColor
                        : widget.unselectedTabItemColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

}





























