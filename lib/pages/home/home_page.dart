import 'package:flutter/material.dart';
import 'package:member_manage_web/extensions/media_query_extension.dart';
import 'package:member_manage_web/pages/home/navigation_icon_model.dart';
import 'package:member_manage_web/widgets/brightness_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  final selectedPageIndex = ValueNotifier<int>(0);

  final navigationIcons = [
    const NavigationIconModel(
        '会员', Icons.people_alt_outlined, Icons.people_alt),
    const NavigationIconModel(
        '统计', Icons.area_chart_outlined, Icons.area_chart),
    const NavigationIconModel('配置', Icons.settings_outlined, Icons.settings),
  ];

  Widget navigationRail(BuildContext context) {
    return ValueListenableBuilder(
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
                destinations: navigationIcons
                    .map((item) => NavigationRailDestination(
                          label: Text(item.label),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                        ))
                    .toList(),
              ),
            ),
            const BrightnessButton(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageIndex,
      builder: (context, index, _) {
        return BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          onTap: (int index) {
            pageController.jumpToPage(index);
            selectedPageIndex.value = index;
          },
          items: navigationIcons
              .map((item) => BottomNavigationBarItem(
                    label: item.label,
                    icon: Icon(item.icon),
                    activeIcon: Icon(item.selectedIcon),
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).isCompact;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on_outlined),
            Text('结账'),
          ],
        ),
      ),
      bottomNavigationBar: isCompact ? bottomNavigationBar(context) : null,
      body: Flex(
        direction: isCompact ? Axis.vertical : Axis.horizontal,
        children: [
          if (!isCompact) navigationRail(context),
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
