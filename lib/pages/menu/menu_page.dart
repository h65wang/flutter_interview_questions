import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/pages/setup/setup_page.dart';

PageController pageController = PageController();
SideMenuController sideMenu = SideMenuController();

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSideMenu(),
          _buildPage(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Expanded(
      child: PageView(
        controller: pageController,
        children: [
          SetupPage(),
          Container(
            child: Center(child: Text('TODO Page')),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SideMenu(
      title: Text(
        'Flutter Interview Question',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      showToggle: true,
      footer: Text('footer'),
      items: [
        SideMenuItem(
          title: 'Home',
          priority: 0,
          icon: Icon(Icons.home),
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
        SideMenuItem(
          title: 'TODO',
          icon: Icon(Icons.toc),
          priority: 1,
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
      ],
      controller: sideMenu,
    );
  }
}
