import '../../../utils/exported_path.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildCardContent();
  }

  Widget _buildCardContent() {
    final dueSoon = isDueSoon(data['last_date']);
    final priorityColor = Color(int.parse(data['priority_color']));

    return Stack(
      children: [
        // Main card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8.r,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: dueSoon ? Colors.red.shade300 : Colors.grey.shade200,
                  width: dueSoon ? 1.5 : 1,
                ),
              ),
              child: Stack(
                children: [
                  // // Priority indicator
                  // Positioned(
                  //   left: 0,
                  //   top: 0,
                  //   bottom: 0,
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(vertical: 4),
                  //     width: 6.w,
                  //     decoration: BoxDecoration(
                  //       color: priorityColor,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(18.r),
                  //         bottomLeft: Radius.circular(18.r),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with priority and status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Priority tag
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                data['priority'] ?? '',
                                style: TextStyle(
                                  color: priorityColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacer(),
                            // Status
                            StatusBadge(
                              status: data['status'] ?? '',
                              color:
                                  int.tryParse(data['status_color'] ?? '') ??
                                  0xFFFFFFFF,
                            ),

                            // Row(
                            //   children: [
                            //     Container(
                            //       width: 8.w,
                            //       height: 8.w,
                            //       decoration: BoxDecoration(
                            //         color: statusColor,
                            //         shape: BoxShape.circle,
                            //       ),
                            //     ),
                            //     SizedBox(width: 6.w),
                            //     Text(
                            //       data['status'] ?? '',
                            //       style: TextStyle(
                            //         fontSize: 12.sp,
                            //         color: Colors.grey.shade600,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Task title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // SizedBox(height: 8.h),

                                // Task code
                                Text(
                                  data['code'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      title: data['created_date'] ?? '',
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 12.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    CustomText(
                                      title: data['last_date'] ?? '',
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: 16.h),

                        // Timeline
                        // data['status'] == 'Closed' ||
                        //         data['status'] == 'Cancelled' ||
                        //         data['status'] == 'Approved'
                        //     ? SizedBox()
                        //     : _buildTimeLine(dueSoon),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildTimeLine(bool dueSoon) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Icon(
  //             Icons.calendar_month_rounded,
  //             size: 16.sp,
  //             color: Colors.grey.shade500,
  //           ),
  //           SizedBox(width: 8.w),
  //           Expanded(
  //             child: Text(
  //               'Timeline',
  //               style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
  //             ),
  //           ),
  //           Text(
  //             deadlineLabel(data['last_date']),
  //             style: TextStyle(
  //               fontSize: 12.sp,
  //               color:
  //                   deadlineLabel(data['last_date']) == "Expired"
  //                       ? Colors.red
  //                       : Colors.green,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 8.h),
  //       ClipRRect(
  //         borderRadius: BorderRadius.circular(4.r),
  //         child: LinearProgressIndicator(
  //           value: calculateTimelineProgress(
  //             data['created_date'],
  //             data['last_date'],
  //           ),
  //           minHeight: 6.h,
  //           backgroundColor: Colors.grey.shade300,
  //           color: getTimelineColor(data['created_date'], data['last_date']),
  //         ),
  //       ),
  //       SizedBox(height: 4.h),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             formatDate(data['created_date']),
  //             style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
  //           ),
  //           Text(
  //             formatDate(data['last_date']),
  //             style: TextStyle(
  //               fontSize: 11.sp,
  //               color: dueSoon ? Colors.red : Colors.grey.shade500,
  //               fontWeight: dueSoon ? FontWeight.w600 : FontWeight.normal,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildInfoRow({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  // }) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 16.sp, color: Colors.grey.shade500),
  //       SizedBox(width: 12.w),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             label,
  //             style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
  //           ),
  //           SizedBox(height: 2.h),
  //           Text(
  //             value,
  //             style: TextStyle(
  //               fontSize: 13.sp,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
