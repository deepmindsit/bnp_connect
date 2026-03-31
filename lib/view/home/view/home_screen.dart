// import 'package:bnpteam/utils/exported_path.dart';
//
// import '../../../utils/color.dart' as AppColors;
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final controller = getIt<AddFileController>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.resetFilters();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'E-Office',
//         showBackButton: false,
//         titleSpacing: null,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.bottomSheet(isScrollControlled: true, FileFilter());
//             },
//             icon: Icon(HugeIcons.strokeRoundedFilter),
//           ),
//         ],
//       ),
//       floatingActionButton:
//           getIt<UserService>().rollId.value == '1' ||
//               getIt<UserService>().rollId.value == '3'
//           ? _floatingButton()
//           : SizedBox.shrink(),
//       body: Obx(() {
//         final file = controller.fileList;
//
//         if (controller.isLoading.isTrue) {
//           return taskShimmer();
//         }
//
//         if (file.isEmpty) {
//           return const Center(child: Text("No Files available."));
//         }
//         return NotificationListener<ScrollNotification>(
//           onNotification: (scrollNotification) {
//             if (scrollNotification is ScrollEndNotification &&
//                 scrollNotification.metrics.pixels ==
//                     scrollNotification.metrics.maxScrollExtent) {
//               controller.getFilesLoadMore();
//             }
//             return true;
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               spacing: 10,
//               children: [
//                 LiveList.options(
//                   shrinkWrap: true,
//                   physics: BouncingScrollPhysics(),
//                   options: LiveOptions(
//                     delay: Duration.zero,
//                     showItemInterval: Duration(milliseconds: 100),
//                     showItemDuration: Duration(milliseconds: 250),
//                     reAnimateOnVisibility: false,
//                   ),
//                   itemCount: controller.fileList.length,
//                   itemBuilder: (context, index, animation) {
//                     final file = controller.fileList[index];
//
//                     return FadeTransition(
//                       opacity: animation,
//                       child: SlideTransition(
//                         position: Tween<Offset>(
//                           begin: Offset(0, 0.05),
//                           end: Offset.zero,
//                         ).animate(animation),
//                         child: FileCard(
//                           data: file,
//                           onTap: () => Get.toNamed(
//                             Routes.fileDetails,
//                             arguments: {'id': file['id'].toString()},
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 file.isEmpty ? const SizedBox() : buildLoader(),
//               ],
//             ),
//           ),
//         );
//       }),
//
//       // Obx(() {
//       //   final file = controller.fileList;
//       //
//       //   if (controller.isLoading.isTrue) {
//       //     return taskShimmer();
//       //   }
//       //
//       //   if (file.isEmpty) {
//       //     return const Center(child: Text("No Files available."));
//       //   }
//       //
//       //   return LiveList.options(
//       //     shrinkWrap: true,
//       //     physics: BouncingScrollPhysics(),
//       //     options: LiveOptions(
//       //       delay: Duration.zero,
//       //       showItemInterval: Duration(milliseconds: 100),
//       //       showItemDuration: Duration(milliseconds: 250),
//       //       reAnimateOnVisibility: false,
//       //     ),
//       //     itemCount: controller.fileList.length,
//       //     itemBuilder: (context, index, animation) {
//       //       final file = controller.fileList[index];
//       //
//       //       return FadeTransition(
//       //         opacity: animation,
//       //         child: SlideTransition(
//       //           position: Tween<Offset>(
//       //             begin: Offset(0, 0.05),
//       //             end: Offset.zero,
//       //           ).animate(animation),
//       //           child: FileCard(
//       //             data: file,
//       //             onTap:
//       //                 () => Get.toNamed(
//       //                   Routes.fileDetails,
//       //                   arguments: {'id': file['id'].toString()},
//       //                 ),
//       //           ),
//       //         ),
//       //       );
//       //     },
//       //   );
//       // }),
//     );
//   }
//
//   Widget buildLoader() {
//     if (controller.isMoreLoading.value) {
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: LoadingWidget(color: AppColors.primaryColor),
//       );
//     } else if (!controller.hasNextPage.value) {
//       return const Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Center(child: Text('No more data')),
//       );
//     }
//     return const SizedBox.shrink();
//   }
//   // SingleChildScrollView(
//   //   padding: EdgeInsets.all(12.w),
//   //   child: Column(
//   //     children: [
//   //       GestureDetector(
//   //         onTap: () => Get.toNamed(Routes.fileDetails),
//   //         child: Card(
//   //           color: Colors.white,
//   //           surfaceTintColor: Colors.white,
//   //           elevation: 2,
//   //           shadowColor: Colors.black12,
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(16.r),
//   //           ),
//   //           child: Padding(
//   //             padding: EdgeInsets.all(16.w),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 /// Top Row
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     /// Title + Department
//   //                     Expanded(
//   //                       child: Column(
//   //                         crossAxisAlignment: CrossAxisAlignment.start,
//   //                         children: [
//   //                           CustomText(
//   //                             title: 'Hinterland Road Creation',
//   //                             fontSize: 18.sp,
//   //                             fontWeight: FontWeight.w600,
//   //                             textAlign: TextAlign.start,
//   //                             maxLines: 2,
//   //                           ),
//   //                           SizedBox(height: 6.h),
//   //                           CustomText(
//   //                             title: 'Road Department',
//   //                             fontSize: 14.sp,
//   //                             color: Colors.grey.shade600,
//   //                             fontWeight: FontWeight.w500,
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                     StatusBadge(status: "Approved"),
//   //                   ],
//   //                 ),
//   //                 SizedBox(height: 8.h),
//   //
//   //                 /// Description
//   //                 CustomText(
//   //                   title:
//   //                       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
//   //                       "It has survived not only five centuries, but also the leap into electronic typesetting.",
//   //                   fontSize: 14.sp,
//   //                   maxLines: 4,
//   //                   textAlign: TextAlign.start,
//   //                   color: Colors.black87,
//   //                 ),
//   //                 SizedBox(height: 16.h),
//   //
//   //                 /// Timeline Row
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     Row(
//   //                       children: [
//   //                         HugeIcon(
//   //                           icon: HugeIcons.strokeRoundedDateTime,
//   //                           size: 16.sp,
//   //                           color: Colors.grey.shade600,
//   //                         ),
//   //                         SizedBox(width: 6.w),
//   //                         Text(
//   //                           "01/01/2021",
//   //                           style: TextStyle(
//   //                             color: Colors.grey.shade600,
//   //                             fontSize: 12.sp,
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                     SizedBox(width: 8.w),
//   //                     Icon(
//   //                       Icons.arrow_right_alt,
//   //                       size: 18.sp,
//   //                       color: Colors.grey.shade500,
//   //                     ),
//   //                     SizedBox(width: 8.w),
//   //                     Row(
//   //                       children: [
//   //                         HugeIcon(
//   //                           icon: HugeIcons.strokeRoundedDateTime,
//   //                           size: 16.sp,
//   //                           color: Colors.grey.shade600,
//   //                         ),
//   //                         SizedBox(width: 6.w),
//   //                         Text(
//   //                           "01/02/2021",
//   //                           style: TextStyle(
//   //                             color: Colors.purple,
//   //                             fontWeight: FontWeight.w500,
//   //                             fontSize: 12.sp,
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   ),
//   // ),
//
//   Widget _floatingButton() {
//     return FloatingActionButton(
//       backgroundColor: primaryColor,
//       mini: true,
//       elevation: 0,
//       shape: const CircleBorder(),
//       onPressed: () => Get.toNamed(Routes.addFile),
//       child: Icon(Icons.add, color: Colors.white, size: 20.sp),
//     );
//   }
//
//   /// 🧱 Labeled Row Tile
//   Widget buildRowTile(IconData icon, String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: primaryColor),
//           const SizedBox(width: 12),
//           SizedBox(
//             width: Get.width * 0.28.w,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value?.toString() ?? '-',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
