import '../../../utils/exported_path.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.7.sw,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              //header
              _buildHeader(),
              _buildDepartment(),
              _buildDrawerItem(
                icon: HugeIcons.strokeRoundedAnalyticsUp,
                title: 'Dashboard',
                onTap: () => Navigator.pop(context),
              ),

              _buildDrawerItem(
                icon: HugeIcons.strokeRoundedEditUser02,
                title: 'Profile',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.editProfile);
                },
              ),
              _buildDrawerItem(
                icon: HugeIcons.strokeRoundedHelpCircle,
                title: 'Help And Support',
                onTap: () => Get.toNamed(Routes.helpSupport),
              ),
              _buildDrawerItem(
                icon: HugeIcons.strokeRoundedLogout01,
                title: 'Logout',
                iconColor: Colors.black87,
                onTap: showLogoutConfirmationDialog,
              ),
              // _buildDrawerItem(
              //   icon: HugeIcons.strokeRoundedDelete03,
              //   title: 'Delete Account',
              //   iconColor: Colors.red,
              //   textColor: Colors.red,
              //   onTap: () => Get.toNamed(Routes.deleteAccount),
              // ),
            ],
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => SizedBox(
        width: Get.width,
        child: DrawerHeader(
          decoration: BoxDecoration(color: blueColor),
          child: controller.isProfileLoading.isTrue
              ? LoadingWidget(color: Colors.white)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage(Images.fevicon),
                          image: NetworkImage(
                            controller.userData['profile_image'] ?? '',
                          ),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Images.fevicon,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            );
                          },
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      title: controller.userData['name'] ?? '',
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      title: controller.userData['role'] ?? '',
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    Color iconColor = Colors.black,
    Color textColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      leading: Icon(icon, color: iconColor, size: 22.sp),
      title: CustomText(
        title: title,
        fontSize: 14.sp,
        color: textColor,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade200,
    );
  }

  Widget _buildDepartment() {
    final roleId = getIt<UserService>().rollId.value;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    title: roleId == '9'
                        ? controller.userData['wards']?.toString() ?? '-'
                        : controller.userData['department']?.toString() ?? '-',
                    fontSize: 15.sp,
                    color: primaryColor,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('Crafted with by ❤', style: TextStyle(color: Colors.grey)),
          InkWell(
            onTap: () =>
                launchInBrowser(Uri.parse('https://deepmindsinfotech.com')),
            child: const Text(
              'Deepminds Infotech Pvt. Ltd.',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Confirm Logout'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to logout?'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await LocalStorage.clear();
              Get.offAllNamed(Routes.login);
            },
            child: Text('Logout'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
