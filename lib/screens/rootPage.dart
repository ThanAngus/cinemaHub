import 'package:cinemahub/screens/accountPage.dart';
import 'package:cinemahub/screens/bookmarkPage.dart';
import 'package:cinemahub/screens/upcomingScreen.dart';
import 'package:cinemahub/utils/responsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/bottomNavItem.dart';
import '../models/itemModel.dart';
import '../utils/colors.dart';
import 'homePage.dart';

class RootPage extends ConsumerStatefulWidget {
  static const routeName = '/rootPage';

  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  int _currentIndex = 0;

  List<ItemModel> bottomItems = [
    ItemModel(
      index: 0,
      text: "Home",
      unselectedIcon: Icons.home_outlined,
      icon: Icons.home,
    ),
    ItemModel(
      index: 1,
      text: "Explore",
      unselectedIcon: Icons.explore_outlined,
      icon: Icons.explore,
    ),
    ItemModel(
      index: 2,
      text: "Saved",
      unselectedIcon: Icons.bookmark_outline,
      icon: Icons.bookmark,
    ),
    ItemModel(
      index: 3,
      text: "Account",
      unselectedIcon: Icons.person_2_outlined,
      icon: Icons.person_2,
    ),
  ];

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const UpcomingScreen(),
      const BookmarkPage(),
      const AccountPage(),
    ];
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentIndex,
    );
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScreen: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _buildScreens(),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: AppColors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bottomItems.map((e) {
                  return BottomNavItem(
                    itemText: e.text,
                    itemIcon: e.icon,
                    unselectedItemIcon: e.unselectedIcon,
                    selected: _currentIndex == e.index ? true : false,
                    onPressed: () {
                      setState(() {
                        _currentIndex = e.index!;
                        _pageController.animateToPage(
                          e.index!,
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.linear,
                        );
                        HapticFeedback.selectionClick();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      webScreen: const HomePage(),
    );
  }
}
