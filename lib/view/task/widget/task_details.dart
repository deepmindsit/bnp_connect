import 'package:bnpteam/utils/exported_path.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails>
    with SingleTickerProviderStateMixin {
  final controller = getIt<TaskController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskId = Get.arguments['id'].toString();
      controller.getTaskDetails(taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (_, _) {
          return [_buildAppbar()];
        },
        body: Obx(() {
          final details = controller.taskDetails;

          if (controller.isDetailsLoading.isTrue) {
            return Center(child: LoadingWidget(color: primaryColor));
          }

          if (details.isEmpty) {
            return CustomText(
              title: 'No Details Available',
              color: Colors.white,
              fontSize: 14.sp,
            );
          }

          return AnimationLimiter(
            child: ListView(
              padding: EdgeInsets.only(top: 8.h),
              physics: const BouncingScrollPhysics(),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                children: [
                  // 📋 Main Task Card
                  _buildMainTaskCard(details),
                  SizedBox(height: 16.h),

                  // 📝 Description Section
                  _buildDescriptionSection(details),
                  SizedBox(height: 16.h),

                  // 📎 Attachments Section (if exists)
                  if (details['attachments'] != null &&
                      (details['attachments'] as List).isNotEmpty)
                    _buildAttachmentsSection(details['attachments']),
                  SizedBox(height: 16.h),
                  // 🔄 Update History Section
                  if ((details['comments'] as List).isNotEmpty)
                    _buildUpdateHistorySection(details['comments']),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () {
          Get.toNamed(
            Routes.updateTask,
            arguments: {'id': Get.arguments['id'].toString()},
          );
        },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(Icons.edit_rounded, size: 20.w),
        label: CustomText(
          title: 'Update Task',
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ================ UI Components ================ //

  Widget _buildAppbar() {
    return SliverAppBar(
      expandedHeight: 0.18.sh,
      floating: false,
      pinned: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, size: 22.w),
          onPressed: () {
            final taskId = Get.arguments['id'].toString();
            controller.getTaskDetails(taskId);
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.9),
              primaryColor.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Obx(() {
            final details = controller.taskDetails;
            return Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                top: kToolbarHeight + 16.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    title: details['title'] ?? 'Task Details',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    maxLines: 2,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomText(
                          title: details['code'] ?? 'TASK-000',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      StatusBadge(
                        status: details['status'] ?? '-',
                        color:
                            int.tryParse(
                              controller.taskDetails['status_color'] ?? '',
                            ) ??
                            0xFFFFFFFF,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 📋 Main Task Info Card
  Widget _buildMainTaskCard(dynamic details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Card(
        elevation: 2,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: primaryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 👤 Assignee Row
              _buildDetailRow(
                icon: HugeIcons.strokeRoundedUser02,
                label: 'Assignee',
                value: details['assignee'] ?? '-',
                valueStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      details['assignee'] == null
                          ? Colors.grey
                          : Colors.grey.shade800,
                ),
              ),

              Divider(height: 24.h, color: Colors.grey.shade200),

              // 👥 Created By Row
              _buildDetailRow(
                icon: HugeIcons.strokeRoundedUserAdd02,
                label: 'Created By',
                value: details['assigned_by'] ?? '-',
              ),

              Divider(height: 24.h, color: Colors.grey.shade200),

              // 📅 Dates Row
              Row(
                children: [
                  Expanded(
                    child: _buildDetailRow(
                      icon: HugeIcons.strokeRoundedDateTime,
                      label: 'Created Date',
                      value: details['created_date'] ?? '-',
                      isCompact: true,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildDetailRow(
                      icon: HugeIcons.strokeRoundedCalendarRemove02,
                      label: 'Deadline',
                      value: details['last_date'] ?? '-',
                      isCompact: true,
                      valueStyle: TextStyle(
                        color:
                            isDeadlinePassed(details['last_date'])
                                ? Colors.red.shade600
                                : Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              if ((details['refer_contact'] ?? '').toString().isNotEmpty) ...[
                Divider(height: 24.h, color: Colors.grey.shade200),
                _buildDetailRow(
                  icon: Icons.contact_phone_rounded,
                  label: 'Refer Contact',
                  value: details['refer_contact'],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 📝 Description Section
  Widget _buildDescriptionSection(dynamic details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedDocumentValidation,
                size: 20.w,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: 'Description',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: HtmlWidget(
              details['description'] ?? 'No description provided',
              textStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'p') {
                  return {'margin': '0 0 8px 0'};
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 📎 Attachments Section
  Widget _buildAttachmentsSection(List attachments) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AttachmentList(attachments: attachments),
    );
  }

  /// 🔄 Update History Section
  Widget _buildUpdateHistorySection(List comments) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: UpdateHistoryList(updateRecords: comments, title: 'Activity Log'),
    );
  }

  // ================ Helper Methods ================ //

  /// 🏗️ Generic Detail Row Builder
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String? value,
    bool isCompact = false,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: isCompact ? 16.w : 18.w, color: primaryColor),
        ),
        SizedBox(width: isCompact ? 8.w : 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                title: label,
                fontSize: isCompact ? 12.sp : 13.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: isCompact ? 2.h : 4.h),
              CustomText(
                title: value?.toString() ?? '-',
                fontSize: isCompact ? 13.sp : 14.sp,
                fontWeight: isCompact ? FontWeight.normal : FontWeight.w500,
                color: Colors.grey.shade800,
                style: valueStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ⏳ Format relative time
  // String _formatRelativeTime(String? dateString) {
  //   if (dateString == null) return 'Unknown time';
  //
  //   try {
  //     final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //     final date = dateFormat.parse(dateString);
  //     final now = DateTime.now();
  //     final difference = now.difference(date);
  //
  //     if (difference.inSeconds < 60) return 'Just now';
  //     if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  //     if (difference.inHours < 24) return '${difference.inHours}h ago';
  //     if (difference.inDays < 7) return '${difference.inDays}d ago';
  //
  //     return DateFormat('MMM d, yyyy').format(date);
  //   } catch (e) {
  //     return dateString;
  //   }
  // }
}
