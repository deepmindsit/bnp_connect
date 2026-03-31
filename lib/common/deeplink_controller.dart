import 'package:app_links/app_links.dart';

import '../utils/exported_path.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLinkString();
      if (initialLink != null) {
        _handleDeepLink(Uri.parse(initialLink.toString()));
      }
    } catch (_) {}

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(Uri.parse(uri.toString()));
    }, onError: (_) {});
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.length < 2) return;
    String? token;
    final firstSegment = uri.pathSegments[0]; // cl
    // final encodedId = uri.pathSegments[1]; // NDk=

    if (firstSegment == 'cl') {
      try {
        // Decode Base64 ID
        // final decodedBytes = base64.decode(encodedId);
        // final decodedId = utf8.decode(decodedBytes);
        if (token!.isNotEmpty) {
          Get.offAllNamed(Routes.mainScreen);

          // 2️⃣ Switch to Complaint Tab
          final navController = getIt<NavigationController>();
          navController.updateIndex(1);
        } else {
          Get.offAllNamed(Routes.login);
        }

        // // 3️⃣ Open Complaint Details
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   Get.toNamed(Routes.complaintDetails, arguments: {'id': decodedId});
        // });
      } catch (e) {
        // print("DeepLink Decode Error: $e");
      }
    }
  }
}
