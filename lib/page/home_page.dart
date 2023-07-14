import 'package:flutter/material.dart';
import 'package:member_manage_web/widget/brightness_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  final selectedPageIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedPageIndex,
            builder: (context, index, _) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: index,
                      labelType: NavigationRailLabelType.all,
                      onDestinationSelected: (int index) {
                        pageController.jumpToPage(index);
                        selectedPageIndex.value = index;
                      },
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          label: Text('会员'),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          icon: Icon(Icons.people_alt_outlined),
                          selectedIcon: Icon(Icons.people_alt),
                        ),
                        NavigationRailDestination(
                          label: Text('统计'),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          icon: Icon(Icons.area_chart_outlined),
                          selectedIcon: Icon(Icons.area_chart),
                        ),
                        NavigationRailDestination(
                          label: Text('配置'),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                  const BrightnessButton(),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                Text('会员'),
                Text('统计'),
                Text('配置'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
