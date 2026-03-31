import 'package:bnpteam/utils/exported_path.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getHelpSupport();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Help & Support',
        showBackButton: true,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            _buildTile(
              icon: HugeIcons.strokeRoundedHelpCircle,
              title: 'Help Center',
              onTap: () {
                final phone = controller.helpSupport['helpline'] ?? '';
                if (phone.isNotEmpty) makePhoneCall(phone);
              },
            ),
            _buildTile(
              icon: HugeIcons.strokeRoundedChatting01,
              title: 'Chat With Us',
              onTap: () {
                final email = controller.helpSupport['support'] ?? '';
                if (email.isNotEmpty) sendingMails(email);
              },
            ),
            _buildTile(
              icon: HugeIcons.strokeRoundedPolicy,
              title: 'Privacy Policy',
              onTap: () {
                Get.to(() => const PolicyData(slug: 'privacy_policy_page'));
              },
            ),
            // _buildTile(
            //   icon: HugeIcons.strokeRoundedPoliceBadge,
            //   title: 'Terms & Conditions',
            //   onTap: () {
            //     Get.to(
            //       () => const PolicyData(slug: 'terms_and_conditions_page'),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    // required String iconPath,
    required String title,
    required VoidCallback onTap,
    required var icon,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          // leading: Image.asset(iconPath, height: Get.width * 0.07.h),
          leading: Icon(icon, size: Get.width * 0.07.h),
          title: CustomText(
            title: title,
            textAlign: TextAlign.start,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(thickness: 0.5, indent: 10, endIndent: 10, color: Colors.grey),
      ],
    );
  }
}
