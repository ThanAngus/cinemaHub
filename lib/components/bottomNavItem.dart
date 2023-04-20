import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class BottomNavItem extends StatelessWidget {
  final bool? selected;
  final String? itemText;
  final IconData? itemIcon;
  final IconData? unselectedItemIcon;
  final PageController? controller;
  final VoidCallback? onPressed;

  const BottomNavItem({
    Key? key,
    this.selected,
    this.itemText,
    this.itemIcon,
    this.controller,
    this.onPressed,
    this.unselectedItemIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(
            selected! ? itemIcon : unselectedItemIcon,
            color: AppColors.primary,
            size: ScreenUtil().setSp(28),
          ),
          selected! ? Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ) : const SizedBox(
            width: 5,
            height: 5,
          ),
        ],
      ),
    );
  }
}
