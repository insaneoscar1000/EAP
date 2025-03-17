import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/ui/views/views.dart';

class TabsView extends StatefulWidget {
  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  int _currentIndex = 0;
  late Widget _currentView;

  @override
  void initState() {
    super.initState();
    _currentView = HomeView();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(IconsaxPlusLinear.home_1),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(IconsaxPlusLinear.briefcase),
        label: 'My Projects',
      ),
      BottomNavigationBarItem(
        icon: Icon(IconsaxPlusLinear.info_circle),
        label: 'EIA Basics',
      ),
      BottomNavigationBarItem(
        icon: Icon(IconsaxPlusLinear.calendar),
        label: 'Schedule',
      ),
    ];

    return Scaffold(
      bottomNavigationBar: SizedBox(
          height: 75,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
              highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: BottomNavigationBar(
              elevation: 8,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (int value) => returnView(value),
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.black,
              selectedLabelStyle:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              enableFeedback: true,
              selectedIconTheme:
                  IconThemeData(color: Theme.of(context).primaryColor),
              unselectedIconTheme: IconThemeData(color: Colors.black),
              items: items,
            ),
          )),
      body: _currentView,
    );
  }

  void returnView(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        _currentView = HomeView();
        break;
      case 1:
        _currentView = Center(child: Text('Projects'));
        break;
      case 2:
        _currentView = EIABasicsView();
        break;
      case 3:
        _currentView = Center(child: Text('Schedule'));
        break;
      default:
        break;
    }
  }
}
