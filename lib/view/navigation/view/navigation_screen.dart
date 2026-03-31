import '../../../utils/exported_path.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  // final controller = Get.put(NavigationController());
  final controller = getIt<NavigationController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child:
              NavigationController.widgetOptions[controller.currentIndex.value],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            boxShadow: [
              if (theme.brightness == Brightness.light)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              else
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey.shade500,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              currentIndex: controller.currentIndex.value,
              onTap: controller.updateIndex,

              items: [
                _buildNavItem(
                  HugeIcons.strokeRoundedAnalyticsUp,
                  'Dashboard',
                  controller.currentIndex.value == 0,
                ),
                _buildNavItem(
                  HugeIcons.strokeRoundedComplaint,
                  'Complaint',
                  controller.currentIndex.value == 1,
                ),
                // _buildNavItem(
                //   HugeIcons.strokeRoundedNews,
                //   'KMS',
                //   controller.currentIndex.value == 4,
                //   iconSize: Get.width * 0.05,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    bool isSelected, {
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: HugeIcon(
          size: iconSize ?? Get.width * 0.06,
          icon: icon,
          color: isSelected ? primaryColor : Colors.grey.shade500,
        ),
      ),
      label: label,
    );
  }
}
