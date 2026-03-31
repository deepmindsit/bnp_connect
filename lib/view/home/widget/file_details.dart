import '../../../utils/exported_path.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({super.key});

  @override
  State<FileDetails> createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  // String selectedStatus = 'Approved';
  // final remarkController = TextEditingController();
  // List<String> newAttachments = [];

  final controller = getIt<AddFileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fileId = Get.arguments['id'].toString();
      controller.getFileDetails(fileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(title: 'File Details', showBackButton: true),
      body: Obx(() {
        final details = controller.fileDetails;

        if (controller.isDetailsLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        if (details.isEmpty) {
          return const Center(child: Text("No details available."));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom + 80,
            top: 8,
          ),
          child: Column(
            spacing: 12,
            children: [
              _buildTitleCard(),
              // _buildContactCard(),
              _buildCategory(),
              if ((details['assignee'] as List).isNotEmpty)
                _buildAssigneeCard(),
              if (details['attachments'] != null)
                AttachmentList(attachments: (details['attachments'] as List)),
              if ((details['comments'] as List).isNotEmpty)
                UpdateHistoryList(
                  updateRecords: details['comments'],
                  title: 'Updates',
                ),
            ],
          ),
        );
      }),
      floatingActionButton: _buildUpdateFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildUpdateFAB() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: FloatingActionButton.extended(
        onPressed:
            () => Get.bottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              UpdateFile(id: Get.arguments['id'].toString()),
            ),
        backgroundColor: primaryColor,
        elevation: 4,
        icon: Icon(Icons.edit, color: Colors.white),
        label: Text(
          'Update File',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return GlassCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sectionTitleWithIcon(
              '📄 ${controller.fileDetails['file_number'] ?? ''}',
            ),
            StatusBadge(
              status: controller.fileDetails['status'] ?? '',
              color:
                  int.tryParse(controller.fileDetails['status_color'] ?? '') ??
                  0xFF025599,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDetailRow(
          icon: HugeIcons.strokeRoundedLeftToRightListBullet,
          title: 'Public Service',
          value: controller.fileDetails['public_service'] ?? '-',
        ),

        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildDateCard(
                icon: HugeIcons.strokeRoundedDateTime,
                title: 'Start Date',
                date: controller.fileDetails['file_date'] ?? '-',
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildDateCard(
                icon: HugeIcons.strokeRoundedDateTime,
                title: 'End Date',
                date: controller.fileDetails['last_date'] ?? '-',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildContactCard() {
  //   return GlassCard(
  //     children: [
  //       sectionTitleWithIcon('📝 Contact Details'),
  //       SizedBox(height: 8.h),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildDetailRow(
  //               icon: HugeIcons.strokeRoundedOffice,
  //               title: 'Department',
  //               value: controller.fileDetails['department'] ?? '-',
  //             ),
  //           ),
  //           Expanded(
  //             child: _buildDetailRow(
  //               icon: HugeIcons.strokeRoundedArrange,
  //               title: 'Organisation',
  //               value: controller.fileDetails['orgnaisation'] ?? '-',
  //             ),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildDetailRow(
  //               icon: HugeIcons.strokeRoundedLaptop,
  //               title: 'Designation',
  //               value: controller.fileDetails['designation'] ?? '-',
  //             ),
  //           ),
  //           SizedBox(height: 8.h),
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 IconBox(
  //                   icon: HugeIcons.strokeRoundedFlag02,
  //                   size: 20,
  //                   color: Colors.red.shade700,
  //                 ),
  //                 SizedBox(width: 8.w),
  //                 Text(
  //                   'Priority:',
  //                   style: TextStyle(
  //                     fontSize: 14.sp,
  //                     color: Colors.grey.shade700,
  //                   ),
  //                 ),
  //                 SizedBox(width: 8.w),
  //                 priorityBadge(
  //                   controller.fileDetails['priority'] ?? '-',
  //                   int.tryParse(
  //                         controller.fileDetails['priority_color'] ?? '',
  //                       ) ??
  //                       0xFF025599,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCategory() {
    return GlassCard(
      children: [
        sectionTitleWithIcon('📝 Subject'),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailRow(
                icon: HugeIcons.strokeRoundedLayers01,
                title: 'Subject',
                value: controller.fileDetails['subject'] ?? '-',
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap:
                    () => launchURL(
                      'tel:${controller.fileDetails['contact_info']}',
                    ),
                child: _buildDetailRow(
                  icon: HugeIcons.strokeRoundedCall02,
                  title: 'Contact Info',
                  value: controller.fileDetails['contact_info'] ?? '-',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconBox(
              icon: HugeIcons.strokeRoundedUser,
              size: 20,
              color: Colors.blue.shade700,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created By',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    controller.fileDetails['assigned_by'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            IconBox(
              icon: HugeIcons.strokeRoundedDateTime,
              size: 20,
              color: Colors.blue.shade700,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created On',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    controller.fileDetails['created_on'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssigneeCard() {
    return GlassCard(
      children: [
        sectionTitleWithIcon('👥 Assignee Details'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children:
              controller.fileDetails['assignee'].map<Widget>((assignee) {
                return Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.15),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Profile avatar with status indicator
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: FadeInImage(
                            placeholder: AssetImage(Images.fevicon),
                            image: NetworkImage(assignee['profile_image']),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 35.w,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 20.w,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                            width: 35.w,
                            height: 35.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // User info section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    title: assignee['name'] ?? 'Unassigned',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                priorityBadge(
                                  assignee['status'] ?? '-',
                                  int.tryParse(
                                        assignee['status_color'] ?? '',
                                      ) ??
                                      0xFF025599,
                                ),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            Row(
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  size: 14.w,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: CustomText(
                                    title:
                                        assignee['user_type'] ??
                                        'No role specified',
                                    fontSize: 11.sp,
                                    color: Colors.grey.shade700,
                                    maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),

                            if (assignee['department'] != null &&
                                assignee['department'].isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.group_outlined,
                                      size: 14.w,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: CustomText(
                                        title: assignee['department'],
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade600,
                                        maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(icon: icon, size: 20, color: Colors.blue.shade700),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  title: title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required IconData icon,
    required String title,
    required String date,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          IconBox(icon: icon, size: 20, color: color),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                title: title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconBox({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}
