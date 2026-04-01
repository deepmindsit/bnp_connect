import 'package:bnpteam/utils/exported_path.dart';

class UpdateHistoryList extends StatelessWidget {
  final List updateRecords;
  final String? title;

  const UpdateHistoryList({super.key, required this.updateRecords, this.title});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      children: [
        if (title != null) sectionTitleWithIcon(title!),

        ...updateRecords.map(
          (record) => Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child:
                            // Image.network(
                            //   record['profile_image'] ?? '',
                            //   width: 36.w,
                            //   height: 36.h,
                            //   fit: BoxFit.cover,
                            //   loadingBuilder: (_, child, loadingProgress) {
                            //     if (loadingProgress == null) {
                            //       return child;
                            //     }
                            //     return SizedBox(
                            //       height: 36.w,
                            //       child: LoadingWidget(color: primaryColor),
                            //     );
                            //   },
                            //   errorBuilder: (context, error, stackTrace) {
                            //     return SizedBox(
                            //       height: 36.w,
                            //       child: Center(
                            //         child: Icon(
                            //           Icons.broken_image,
                            //           color: Colors.grey,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            FadeInImage(
                              placeholder: AssetImage(Images.fevicon),
                              image: NetworkImage(record['profile_image']),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Images.fevicon,
                                  width: 36.w,
                                  height: 36.h,
                                  fit: BoxFit.cover,
                                );
                              },
                              width: 36.w,
                              height: 36.h,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                            ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title:
                                '${record['updated_by'] ?? ''} (${record['comment_person_role'] ?? ''})',
                            fontSize: 14.sp,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            title:
                                '${record['created_on_date']} ${record['created_on_time']}',
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                    if (record['status'] != null)
                      StatusBadge(
                        status: record['status'] ?? '',
                        color:
                            int.tryParse(
                              record['status_color']?.toString() ?? '',
                            ) ??
                            0xFF898989,
                      ),
                  ],
                ),
                if (record['department_updated'] == '1')
                  Container(
                    padding: EdgeInsets.all(4.r),
                    margin: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CustomText(
                      title: '${record['update_details'] ?? ''}',
                      fontSize: 11.sp,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      color: Colors.white,
                    ),
                  ),
                // Remark Box
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: HtmlWidget(record['description'] ?? ''),
                ),

                // Attachments
                if (record['comment_attachments']?.isNotEmpty ?? false) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Attachments :',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  attachment(record),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget attachment(record) {
    return
    //   Wrap(
    //   spacing: 8.w,
    //   runSpacing: 8.h,
    //   children:
    //       (record['comment_attachments'] as List).map((attachment) {
    //         return InkWell(
    //           onTap: () => downloadFile(attachment['path']),
    //           borderRadius: BorderRadius.circular(8.r),
    //           child: Container(
    //             width: Get.width * 0.4.sw,
    //             padding: EdgeInsets.all(8.w),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(8.r),
    //               border: Border.all(color: Colors.grey.shade200, width: 1),
    //             ),
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   getIconForFile(attachment['name'] ?? ''),
    //                   size: 18.sp,
    //                   color: primaryColor,
    //                 ),
    //                 SizedBox(width: 8.w),
    //                 SizedBox(
    //                   // width: Get.width * 0.4.sw,
    //                   child: CustomText(
    //                     fontSize: 12.sp,
    //                     color: Colors.grey.shade700,
    //                     title: attachment['name'] ?? 'Attachment',
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       }).toList(),
    // );
    SizedBox(
      height: Get.height * 0.17.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: record['comment_attachments'].length,
        itemBuilder: (context, index) {
          final file = record['comment_attachments'][index];
          final name = file['name'] ?? 'Attachment';
          final path = file['path'];
          final extension = name.split('.').last.toLowerCase();
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
          ].contains(extension);

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              width: 0.45.sw,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Preview Section
                  Stack(
                    children: [
                      if (isImage)
                        WidgetZoom(
                          heroAnimationTag: 'tag $path',
                          zoomWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              path,
                              height: 80.w,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return SizedBox(
                                  height: 80.w,
                                  child: LoadingWidget(color: primaryColor),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  height: 80.w,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      // WidgetZoom(
                      //   heroAnimationTag: 'tag $path',
                      //   zoomWidget: ClipRRect(
                      //     borderRadius: BorderRadius.circular(12),
                      //     child: FadeInImage(
                      //       placeholder: AssetImage(Images.fevicon),
                      //       image: NetworkImage(path),
                      //       imageErrorBuilder: (context, error, stackTrace) {
                      //         return Image.asset(
                      //           Images.fevicon,
                      //           height: 80.w,
                      //           fit: BoxFit.contain,
                      //           width: double.infinity,
                      //         );
                      //       },
                      //       height: 80.w,
                      //       width: double.infinity,
                      //       fit: BoxFit.contain,
                      //       fadeInDuration: const Duration(milliseconds: 300),
                      //     ),
                      //   ),
                      // )
                      else
                        Container(
                          height: 80.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: getFileTypeColor(extension),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            getIconForFile(name),
                            size: 36.w,
                            color: Colors.white,
                          ),
                        ),

                      // Download Button (always visible)
                      Positioned(
                        bottom: 6.w,
                        right: 6.w,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: InkWell(
                            onTap: () => downloadFile(path),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              child: Icon(
                                Icons.download,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // File Name
                  CustomText(
                    title: name.length > 20
                        ? '${name.substring(0, 20)}...'
                        : name,
                    fontSize: 13.sp,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // Wrap(
    //   spacing: 8.w,
    //   runSpacing: 8.h,
    //   children: List.generate(
    //     record['comment_attachments'].length,
    //     (i) => GestureDetector(
    //       onTap: () => downloadFile(record['comment_attachments'][i]['path']),
    //       child: SizedBox(
    //         // width: Get.width * 0.4.w,
    //         child: Chip(
    //           surfaceTintColor: Colors.white,
    //           side: BorderSide.none,
    //           avatar: Icon(
    //             getIconForFile(record['comment_attachments'][i]['name'] ?? ''),
    //             size: 18.sp,
    //             color: primaryColor,
    //           ),
    //           label: CustomText(
    //             title: record['comment_attachments'][i]['name'] ?? '',
    //             fontSize: 12.sp,
    //             textAlign: TextAlign.start,
    //           ),
    //           backgroundColor: Colors.blue.shade50,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

//
//
// import 'package:bnpteam/utils/exported_path.dart';
// import 'package:intl/intl.dart';
//
// class UpdateHistoryList extends StatelessWidget {
//   final List updateRecords;
//   final String? title;
//   final bool showUserInfo;
//
//   const UpdateHistoryList({
//     super.key,
//     required this.updateRecords,
//     this.title,
//     this.showUserInfo = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       children: [
//         if (title != null)
//           Padding(
//             padding: EdgeInsets.only(bottom: 12.h),
//             child: sectionTitleWithIcon(title!),
//           ),
//
//         Column(
//           children: List.generate(updateRecords.length, (index) {
//             final record = updateRecords[index];
//             final isLast = index == updateRecords.length - 1;
//
//             return Column(
//               children: [
//                 _buildUpdateItem(record),
//                 if (!isLast)
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 8.h),
//                     child: Divider(height: 1, color: Colors.grey.shade200),
//                   ),
//               ],
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUpdateItem(Map<String, dynamic> record) {
//     return InkWell(
//       onTap: () => _showUpdateDetails(record),
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(width: 0.5, color: primaryGrey),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with User Info and Status
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (showUserInfo) _buildUserAvatar(record),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (showUserInfo)
//                         Text(
//                           record['updated_by'] ?? 'Unknown User',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.access_time_rounded,
//                             size: 14.sp,
//                             color: Colors.grey.shade500,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             _formatDateTime(
//                               record['created_on_date'],
//                               record['created_on_time'],
//                             ),
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 if (record['status'] != null)
//                   StatusBadge(
//                     status: record['status'] ?? '',
//                     color:
//                     int.tryParse(
//                       record['status_color']?.toString() ?? '',
//                     ) ??
//                         0xFF025599,
//                   ),
//               ],
//             ),
//
//             SizedBox(height: showUserInfo ? 12.h : 8.h),
//
//             // Update Content
//             if (record['description']?.isNotEmpty ?? false)
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: HtmlWidget(
//                   record['description'] ?? '',
//                   textStyle: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//               ),
//
//             // Attachments
//             if (record['comment_attachments']?.isNotEmpty ?? false) ...[
//               SizedBox(height: 12.h),
//               Text(
//                 'Attachments',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Wrap(
//                 spacing: 8.w,
//                 runSpacing: 8.h,
//                 children:
//                 (record['comment_attachments'] as List).map((attachment) {
//                   return InkWell(
//                     onTap: () => _openAttachment(attachment),
//                     borderRadius: BorderRadius.circular(8.r),
//                     child: Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8.r),
//                         border: Border.all(
//                           color: Colors.grey.shade200,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             getIconForFile(attachment['name'] ?? ''),
//                             size: 18.sp,
//                             color: Theme.of(Get.context!).primaryColor,
//                           ),
//                           SizedBox(width: 8.w),
//                           ConstrainedBox(
//                             constraints: BoxConstraints(maxWidth: 120.w),
//                             child: Text(
//                               attachment['name'] ?? 'Attachment',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.grey.shade700,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserAvatar(Map<String, dynamic> record) {
//     return Padding(
//       padding: EdgeInsets.only(right: 12.w),
//       child: Stack(
//         children: [
//           CircleAvatar(
//             radius: 20.r,
//             backgroundColor: Colors.grey.shade200,
//             child: ClipOval(
//               child: FadeInImage(
//                 placeholder: AssetImage(Images.fevicon),
//                 image: NetworkImage(record['profile_image'] ?? ''),
//                 imageErrorBuilder: (context, error, stackTrace) {
//                   return Image.asset(
//                     Images.fevicon,
//                     width: 36.w,
//                     height: 36.h,
//                     fit: BoxFit.cover,
//                   );
//                 },
//                 width: 36.w,
//                 height: 36.h,
//                 fit: BoxFit.cover,
//                 fadeInDuration: const Duration(milliseconds: 300),
//               ),
//             ),
//           ),
//           // Add online status indicator if needed
//           // Positioned(
//           //   right: 0,
//           //   bottom: 0,
//           //   child: Container(
//           //     width: 10.w,
//           //     height: 10.h,
//           //     decoration: BoxDecoration(
//           //       color: Colors.green,
//           //       shape: BoxShape.circle,
//           //       border: Border.all(color: Colors.white, width: 2),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDateTime(String? date, String? time) {
//     try {
//       if (date == null || time == null) return 'Unknown time';
//
//       final dateTimeStr = '${date}T$time';
//       final dateTime = DateTime.parse(dateTimeStr);
//       return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
//     } catch (e) {
//       return '${date ?? ''} ${time ?? ''}'.trim();
//     }
//   }
//
//   void _showUpdateDetails(Map<String, dynamic> record) {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//               // Detailed Header
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildUserAvatar(record),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           record['updated_by'] ?? 'Unknown User',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           _formatDateTime(
//                             record['created_on_date'],
//                             record['created_on_time'],
//                           ),
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (record['status'] != null)
//                     StatusBadge(
//                       status: record['status'] ?? '',
//                       color:
//                       int.tryParse(
//                         record['status_color']?.toString() ?? '',
//                       ) ??
//                           0xFF025599,
//                     ),
//                 ],
//               ),
//               SizedBox(height: 16.h),
//
//               // Detailed Content
//               Text(
//                 'Update Details',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: HtmlWidget(
//                   record['description'] ?? 'No description provided',
//                   textStyle: TextStyle(fontSize: 14.sp),
//                 ),
//               ),
//
//               // Detailed Attachments
//               if (record['comment_attachments']?.isNotEmpty ?? false) ...[
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Attachments (${record['comment_attachments'].length})',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 ...(record['comment_attachments'] as List).map((attachment) {
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 8.h),
//                     child: ListTile(
//                       leading: Icon(
//                         getIconForFile(attachment['name'] ?? ''),
//                         color: Theme.of(Get.context!).primaryColor,
//                       ),
//                       title: Text(
//                         attachment['name'] ?? 'Attachment',
//                         style: TextStyle(fontSize: 14.sp),
//                       ),
//                       trailing: Icon(
//                         Icons.download_rounded,
//                         color: Colors.grey.shade600,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       tileColor: Colors.grey.shade50,
//                       onTap: () => _openAttachment(attachment),
//                     ),
//                   );
//                 }),
//               ],
//               SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
//             ],
//           ),
//         ),
//       ),
//       // isScrollControlled: true,
//     );
//   }
//
//   // String _formatFileSize(dynamic size) {
//   //   if (size == null) return 'Unknown size';
//   //   final bytes = size is String ? int.tryParse(size) ?? 0 : size as int;
//   //   if (bytes < 1024) return '$bytes B';
//   //   if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//   //   return '${(bytes / 1048576).toStringAsFixed(1)} MB';
//   // }
//
//   void _openAttachment(Map<String, dynamic> attachment) {
//     // Implement your attachment opening logic here
//     // For example:
//     // if (attachment['url'] != null) {
//     //   Get.to(() => FileViewerScreen(url: attachment['url']));
//     // } else {
//     //   Get.snackbar('Error', 'Unable to open attachment');
//     // }
//
//     // For now, just show a dialog
//     Get.dialog(
//       AlertDialog(
//         surfaceTintColor: Colors.white,
//         backgroundColor: Colors.white,
//         title: Text('Open Attachment'),
//         content: Text(
//           'Would you like to download or view ${attachment['name']}?',
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               // Implement download/view functionality
//             },
//             child: Text('View'),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               // Implement download functionality
//             },
//             child: Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
