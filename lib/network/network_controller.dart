// import 'package:bnpteam/common/app_under_maintainance.dart';
// import 'package:bnpteam/utils/exported_path.dart';
//
// @injectable
// class NetworkController extends GetxController {
//   final _connectionChecker = InternetConnectionChecker.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _connectionChecker.onStatusChange.listen(_updateConnectionStatus);
//   }
//
//   void _updateConnectionStatus(InternetConnectionStatus status) async {
//     if (status == InternetConnectionStatus.disconnected) {
//       if (!(Get.isDialogOpen ?? false)) {
//         _showNoInternetDialog();
//       }
//     } else {
//       if (Get.isDialogOpen ?? false) {
//         Get.back(); // Close the dialog
//       }
//
//       // Check for maintenance if internet comes back
//       await _checkMaintenance();
//     }
//   }
//
//   void _showNoInternetDialog() {
//     Get.dialog(
//       PopScope(
//         canPop: false,
//         child: AlertDialog(
//           surfaceTintColor: Colors.transparent,
//           backgroundColor: Colors.white,
//           title: const Text(
//             'No Internet Connection',
//             style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 'assets/images/no_internet_connection.png',
//                 width: Get.height * 0.25,
//               ),
//               const SizedBox(height: 12),
//               const Text('Please check your internet connection.'),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () async {
//                 final isConnected = await _connectionChecker.hasConnection;
//                 if (isConnected) {
//                   if (Get.isDialogOpen ?? false) Get.back();
//                   await _checkMaintenance();
//                 } else {
//                   // Optionally show a toast/snackbar
//                 }
//               },
//               child: const Text('Retry', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   Future<void> _checkMaintenance() async {
//     try {
//       var profileData = await getIt<ProfileController>().getProfile2();
//       if (profileData['android']['is_maintenance'] == true) {
//         Get.offAll(
//           () =>
//               Maintenance(msg: profileData['android']['maintenance_msg'] ?? ''),
//           transition: Transition.rightToLeftWithFade,
//         );
//       }
//     } catch (_) {
//       // handle error
//     }
//   }
// }
