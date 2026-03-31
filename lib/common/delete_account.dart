import 'package:flutter/gestures.dart';
import '../utils/exported_path.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  final controller = getIt<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Delete Account',
        showBackButton: true,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'We’re sorry to see you leave!'.tr,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: Get.height * 0.02.h),
            CustomText(
              title:
                  'Once your account is deleted, all associated data will be permanently removed. This action is irreversible, and you won’t be able to reactivate your account.'
                      .tr,
              fontSize: 16.sp,
              maxLines: 10,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: Get.height * 0.025.h),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 15.0, color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '• By proceeding, you confirm that you have read and agree to our '
                            .tr,
                  ),
                  TextSpan(
                    text: 'Privacy Policy.'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              () =>
                                  const PolicyData(slug: 'privacy_policy_page'),
                            );
                          },
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.05),
            Center(
              child: CustomButton(
                backgroundColor: Colors.red,
                text: 'Delete My Account',
                isLoading: controller.isDeleteLoading,
                onPressed: showDeleteConfirmationDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Confirm Deletion'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.'
              .tr,
        ),
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
              await controller
                  .deleteAccount(); // Uncomment this when implementing actual logic
            },
            child: Text(
              'Yes, Delete'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
