import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/main.dart';
import 'package:flutter_interview_questions/pages/setup/setup_page.dart';

import '../../util/only_web/only_web.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          if (constraints.maxWidth > 829) SideMenu(),
          Expanded(child: ClipRect(child: child)),
        ],
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 44),
              child: InkWell(
                onTap: () => launchUrlString(
                  'https://github.com/h65wang',
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/image/uncle_wang.png',
                  ),
                  radius: 80,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.app_registration_outlined),
              title: Text('Setup'),
              onTap: () => _pushWithoutAnimation(SetupPage()),
            ),
            ListTile(
              leading: Icon(Icons.token_outlined),
              title: Text('TODO'),
              onTap: () => _pushWithoutAnimation(
                Center(child: Text('todo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushWithoutAnimation(Widget page) {
    navigatorKey.currentState?.pushAndRemoveUntil<void>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, child) => child,
      ),
      (_) => false,
    );
  }

  // void _push(Widget page) {
  //   navigatorKey.currentState?.pushAndRemoveUntil<void>(
  //     MaterialPageRoute(builder: (context) => page),
  //     (_) => false,
  //   );
  // }
}
