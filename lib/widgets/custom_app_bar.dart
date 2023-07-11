import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';
import 'package:quiz_app/configs/themes/ui_parameters.dart';
import 'package:quiz_app/screens/questions/test_overview_screen.dart';
import 'package:quiz_app/widgets/app_circle_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool showActionIcon;
  final VoidCallback? onMenuActionTap;
  const CustomAppBar({
    Key? key,
    this.title = '',
    this.titleWidget,
    this.leading,
    this.showActionIcon = false,
    this.onMenuActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(mobileScreenPadding),
        child: Stack(
          children: [
            Positioned.fill(
              child: titleWidget == null
                  ? Center(child: Text(title, style: appBarText))
                  : Center(child: titleWidget),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading ??
                    Transform.translate(
                      offset: const Offset(-14, 0),
                      child: const BackButton(),
                    ),
                if (showActionIcon)
                  Transform.translate(
                    offset: const Offset(8, 0),
                    child: AppCircleButton(
                      child: Icon(Icons.dashboard, size: 25),
                      onTap: onMenuActionTap ??
                          () => Get.toNamed(TestOverViewScreen.routeName),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 80);
}
