import 'package:bnpteam/utils/exported_path.dart';
import '../utils/color.dart' as app_color;

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final controller = getIt<NotificationController>();

  @override
  void initState() {
    controller.getNotificationInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
        titleSpacing: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _buildShimmerLoader();
        }

        if (controller.notificationData.isEmpty) {
          return _buildEmptyState();
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.getNotificationLoadMore();
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.notificationData.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notificationData[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () async {
                          try {
                            // Mark the notification as read
                            final notificationId = notification['id']
                                ?.toString();

                            // Safely get notification data
                            final data =
                                notification['data'] as Map<String, dynamic>? ??
                                {};

                            // Handle actions
                            final action = notification['action']?.toString();
                            switch (action) {
                              case 'external_url':
                                final url = data['url']?.toString();
                                if (url != null && url.isNotEmpty) {
                                  launchInBrowser(Uri.parse(url));
                                }
                                break;

                              case 'complaint_details':
                                final id = data['id']?.toString();
                                if (id != null && id.isNotEmpty) {
                                  Get.toNamed(
                                    Routes.complaintDetails,
                                    arguments: {'id': id},
                                  );
                                }
                                break;

                              default:
                                // Do nothing or log unhandled actions
                                break;
                            }
                            if (notificationId != null) {
                              await controller.readNotification(notificationId);
                            }
                          } catch (e) {
                            // Optional: handle exceptions
                            // debugPrint('Error handling notification: $e');
                          }
                        },

                        // onTap: () async {
                        //   await controller.readNotification(
                        //     notification['id'].toString(),
                        //   );
                        //   notification['action'] == 'external_url'
                        //       ? launchInBrowser(
                        //         Uri.parse(notification['data']['url']),
                        //       )
                        //       : notification['action'] == 'complaint_details'
                        //       ? Get.toNamed(
                        //         Routes.complaintDetails,
                        //         arguments: {
                        //           'id': notification['data']['id'].toString(),
                        //         },
                        //       )
                        //       : null;
                        // },
                      );
                    },
                  ),
                  controller.notificationData.isEmpty
                      ? const SizedBox()
                      : buildLoader(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLoader() {
    if (controller.isMoreLoading.value) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingWidget(color: app_color.primaryColor),
      );
    } else if (!controller.hasNextPage.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/notitication.png',
            width: Get.width * 0.35,
          ),
          SizedBox(height: 16.sp),
          const Text(
            'No Notifications!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.sp),
          const Text(
            'You don\'t have any notifications yet.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: Get.height * 0.1,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification['is_read'].toString() == '1';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: isRead ? Colors.white : Colors.blue[50]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? Colors.grey.shade200 : Colors.blue.shade100,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon/Image with status indicator
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !isRead
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: !isRead
                              ? Colors.blue.shade200
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        !isRead
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_rounded,
                        color: !isRead
                            ? Colors.blue.shade600
                            : Colors.grey.shade600,
                        size: 24,
                      ),
                    ),

                    // Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12),
                    //     color: Colors.grey.shade100,
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Image.network(
                    //       notification['image'] ??
                    //           'https://static-00.iconduck.com/assets.00/person-icon-2048x2048-wiaps1jt.png',
                    //       fit: BoxFit.cover,
                    //       errorBuilder: (context, error, stackTrace) =>
                    //           Container(
                    //             color: Colors.grey.shade200,
                    //             alignment: Alignment.center,
                    //             child: Icon(
                    //               Icons.notifications,
                    //               color: Colors.grey.shade400,
                    //               size: 24,
                    //             ),
                    //           ),
                    //       loadingBuilder: (context, child, loadingProgress) {
                    //         if (loadingProgress == null) return child;
                    //         return Container(
                    //           color: Colors.grey.shade200,
                    //           alignment: Alignment.center,
                    //           child: CircularProgressIndicator(
                    //             value: loadingProgress.expectedTotalBytes != null
                    //                 ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes!
                    //                 : null,
                    //             strokeWidth: 2,
                    //             color: Colors.blue,
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    if (!isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title with read status
                                Text(
                                  notification['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                    color: isRead
                                        ? Colors.grey.shade800
                                        : Colors.blue.shade900,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 4),

                                // Body text
                                Text(
                                  notification['body'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification['created_on_time'] ?? '',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),

                          // Time and quick actions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(
                                  notification['created_on_date'] ?? '',
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Quick action button for unread notifications
                              if (!isRead)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                  child: Text(
                                    'New',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return 'Now';
      if (difference.inHours < 1) return '${difference.inMinutes}m';
      if (difference.inDays < 1) return '${difference.inHours}h';
      if (difference.inDays < 7) return '${difference.inDays}d';

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

// class NotificationItem {
//   final String title;
//   final String body;
//   final String time;
//   final bool isRead;
//   final IconData icon;
//
//   NotificationItem({
//     required this.title,
//     required this.body,
//     required this.time,
//     required this.isRead,
//     required this.icon,
//   });
// }
//
// class NotificationTile extends StatelessWidget {
//   final dynamic notification;
//   final VoidCallback onTap;
//
//   const NotificationTile({
//     super.key,
//     required this.notification,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       surfaceTintColor: Colors.white,
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       color:
//           notification['is_read'].toString() == '1'
//               ? Colors.white
//               : Colors.blue[50],
//       child: ListTile(
//         leading: WidgetZoom(
//           heroAnimationTag: 'tag ${notification['image']}',
//           zoomWidget: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               notification['image'] ??
//                   'https://static-00.iconduck.com/assets.00/person-icon-2048x2048-wiaps1jt.png',
//               width: Get.width * 0.17.w,
//               fit: BoxFit.contain,
//               errorBuilder:
//                   (context, error, stackTrace) => Container(
//                     color: Colors.grey.shade300,
//                     alignment: Alignment.center,
//                     child: const Icon(
//                       Icons.broken_image,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                   ),
//             ),
//           ),
//         ),
//         title: CustomText(
//           title: notification['title'] ?? '',
//           fontSize: 14.sp,
//           textAlign: TextAlign.start,
//           maxLines: 2,
//           fontWeight:
//               notification['is_read'].toString() == '1'
//                   ? FontWeight.normal
//                   : FontWeight.bold,
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               title: notification['body'] ?? '',
//               fontSize: 12.sp,
//               color: Colors.grey,
//               textAlign: TextAlign.start,
//               maxLines: 2,
//             ),
//             SizedBox(height: 4),
//             Text(
//               notification['created_on_date'] ?? '',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         trailing:
//             notification['is_read'].toString() == '1'
//                 ? null
//                 : Icon(Icons.circle, color: Colors.blue, size: 12),
//         onTap: onTap,
//       ),
//     );
//   }
// }
