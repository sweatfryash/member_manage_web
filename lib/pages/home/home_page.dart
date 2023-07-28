import 'package:flutter/material.dart';
import 'package:member_manage_web/extensions/context_extension.dart';
import 'package:member_manage_web/extensions/media_query_extension.dart';
import 'package:member_manage_web/pages/home/navigation_icon_model.dart';
import 'package:member_manage_web/pages/home/setting_page.dart';
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

  void onNavigationChanged(int index) {
    pageController.jumpToPage(index);
    selectedPageIndex.value = index;
  }

  Widget navigationDrawer(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageIndex,
      builder: (context, index, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: context.mediaQuery.isMedium
                  ? NavigationRail(
                      selectedIndex: index,
                      onDestinationSelected: onNavigationChanged,
                      labelType: NavigationRailLabelType.all,
                      destinations: navigationIcons
                          .map(
                            (item) => NavigationRailDestination(
                              label: Text(item.label),
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                            ),
                          )
                          .toList(),
                    )
                  : NavigationDrawer(
                      elevation: 0,
                      selectedIndex: index,
                      onDestinationSelected: onNavigationChanged,
                      children: navigationIcons
                          .map(
                            (item) => NavigationDrawerDestination(
                              label: Text(item.label),
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                            ),
                          )
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
          selectedItemColor: context.colorScheme.primary,
          onTap: onNavigationChanged,
          items: navigationIcons
              .map(
                (item) => BottomNavigationBarItem(
                  label: item.label,
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.selectedIcon),
                ),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = context.mediaQuery.isCompact;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.monetization_on_outlined),
      ),
      bottomNavigationBar: isCompact ? bottomNavigationBar(context) : null,
      body: Flex(
        direction: isCompact ? Axis.vertical : Axis.horizontal,
        children: [
          if (!isCompact) navigationDrawer(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[
                  Text('会员'),
                  Text('统计'),
                  SettingPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
