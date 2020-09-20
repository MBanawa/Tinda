import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tinda/Widgets/homepage_stuff.dart';
import 'package:tinda/View/cashier_page.dart';
import 'package:tinda/View/inventory_page.dart';
import 'package:tinda/View/reports_page.dart';

class HomePage extends StatefulWidget {
  //Key for BottomNavigation
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Key for BottomNavigation
  GlobalKey _bottomNavigationKey = GlobalKey();
  //Pagecontroller for Pageview
  PageController _pageController = PageController();
  //List of Screens - these are the app's main 3 pages
  List<Widget> _screens = [ListCategories(), ShowCashier(), ListReports()];

  //create index so that bottom navigation follows page slide action
  int _selectedIndex = 0;
  //setstate so that bottom navigation follows page slide action
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  //animate to icon tapped by user
  void _onItemTapped(int selectedIndex) {
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 50.0,
        color: Colors.teal,
        backgroundColor: Colors.grey.shade200,
        buttonBackgroundColor: Colors.yellow.shade900,
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 200),
        onTap: _onItemTapped,
        //create buildFaIcon widget with preset size and color for cleaner code
        items: <Widget>[
          BuildFaIcon(FontAwesomeIcons.cubes),
          BuildFaIcon(FontAwesomeIcons.cashRegister),
          BuildFaIcon(FontAwesomeIcons.briefcase),
        ],
      ),
      // this is the main widget to change pages
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
