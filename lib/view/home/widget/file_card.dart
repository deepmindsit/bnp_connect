import 'package:bnpteam/utils/exported_path.dart';

class FileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const FileCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row (Title + Status)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// File Number with Priority Indicator
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Priority Indicator
                        Container(
                          width: 4.w,
                          height: 40.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(data['priority_color']),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        // Title and Department
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: data['file_number'] ?? '',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data['public_service'] ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Status Badge
                  StatusBadge(
                    status: data['status'] ?? '',
                    color: int.parse(data['status_color']),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              /// Metadata Row (Creator + Dates)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Created By
                  Flexible(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: FadeInImage(
                            placeholder: AssetImage(Images.fevicon),
                            image: NetworkImage(data['profile_image']),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.fevicon,
                                width: 24.w,
                                height: 24.w,
                                fit: BoxFit.contain,
                              );
                            },
                            width: 24.w,
                            height: 24.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: CustomText(
                            title: 'By ${data['created_by'] ?? '-'}',
                            textAlign: TextAlign.start,
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Dates Timeline
                  // Flexible(
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 8.w,
                  //       vertical: 6.h,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(20.r),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         CustomText(
                  //           title: data['file_date'] ?? '',
                  //           fontSize: 11.sp,
                  //           color: Colors.grey.shade700,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 4.w),
                  //           child: Icon(
                  //             Icons.arrow_forward,
                  //             size: 12.sp,
                  //             color: Colors.grey.shade600,
                  //           ),
                  //         ),
                  //         CustomText(
                  //           title: data['last_date'] ?? '',
                  //           fontSize: 11.sp,
                  //           color: Colors.grey.shade700,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              data['status'] == 'Completed' || data['status'] == 'Reject'
                  ? SizedBox()
                  : SizedBox(height: 12.h),
              // Timeline
              data['status'] == 'Completed' || data['status'] == 'Reject'
                  ? SizedBox()
                  : _buildTimeLine(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLine() {
    final dueSoon = isDueSoon(data['last_date']);
    // final priorityColor = Color(int.parse(data['priority_color']));
    // final statusColor = Color(int.parse(data['status_color']));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16.sp,
              color: Colors.grey.shade500,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Timeline',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
              ),
            ),
            // Text(
            //   '${daysUntilDeadline(data['last_date'])} days left',
            //   style: TextStyle(
            //     fontSize: 12.sp,
            //     color: dueSoon ? Colors.red : Colors.green,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            Text(
              deadlineLabel(data['last_date']),
              style: TextStyle(
                fontSize: 12.sp,
                color: deadlineLabel(data['last_date']) == "Expired"
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: calculateTimelineProgress(
              data['file_date'],
              data['last_date'],
            ),
            minHeight: 6.h,
            backgroundColor: Colors.grey.shade300,
            color: getTimelineColor(data['file_date'], data['last_date']),
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDate(data['file_date']),
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
            Text(
              formatDate(data['last_date']),
              style: TextStyle(
                fontSize: 11.sp,
                color: dueSoon ? Colors.red : Colors.grey.shade500,
                fontWeight: dueSoon ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getPriorityColor(String? priorityColor) {
    final colorValue =
        int.tryParse(priorityColor ?? '0xFF025599') ?? 0xFF025599;
    return Color(colorValue);
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final int color;

  const StatusBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(color).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        spacing: 4,
        children: [
          HugeIcon(icon: getIcon(status), color: Color(color), size: 14),
          TranslatedText(
            title: status,
            fontSize: 12.sp,
            color: Color(color),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
