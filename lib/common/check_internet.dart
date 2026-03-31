import '../utils/exported_path.dart';

Future<void> checkInternetAndShowPopup() async {
  final List<ConnectivityResult> connectivityResult = await (Connectivity()
      .checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.none)) {
    noInternetDialog();
  }
}

void noInternetDialog() {
  Get.dialog(
    PopScope(
      canPop: false,
      child: AlertDialog(
        surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
        backgroundColor: Theme.of(Get.context!).cardColor,
        title: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.noInternet, width: Get.height * 0.25.w),
            const SizedBox(height: 12),
            Text(
              'Please check your internet connection.',
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.offAll(() => const SplashScreen());
            },
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}
//
// void showNoInternetDialog() {
//   Get.dialog(
//     PopScope(
//       canPop: false,
//       child: AlertDialog(
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'No Internet Connection',
//           style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//         ),
//         content: SizedBox(
//           height: Get.height * 0.35,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/no_wifi.png', width: Get.height * 0.3),
//               const Text('Check your Internet Connection'),
//             ],
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Get.offAll(() => const SplashScreen());
//             },
//             child: Container(
//               width: Get.width * 0.15,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 color: Colors.red,
//               ),
//               child: const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Retry',
//                     style: TextStyle(letterSpacing: 1, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Future<void> _handleProfileCheck() async {
//   try {
//     var profileData = await GetLinks().getLinks();
//     if (profileData['android']['is_maintenance'] == true) {
//       _navigateToMaintenance(profileData);
//     }
//   } finally {}
// }
//
// void _navigateToMaintenance(Map<String, dynamic> profileData) {
//   Get.offAll(
//     () => Maintenance(msg: profileData['android']['maintenance_msg'] ?? ''),
//     transition: Transition.rightToLeftWithFade,
//   );
// }
