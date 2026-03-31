import 'package:bnpteam/utils/exported_path.dart';

class Knowledge extends StatelessWidget {
  Knowledge({super.key});

  final controller = getIt<KmsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        // return LoadingWidget(color: primaryColor);
        return _buildShimmer();
      }

      if (controller.knowledgeList.isEmpty) {
        return const Center(child: Text("No data available."));
      }
      return LiveList.options(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        options: LiveOptions(
          delay: Duration.zero,
          showItemInterval: Duration(milliseconds: 100),
          showItemDuration: Duration(milliseconds: 250),
          reAnimateOnVisibility: false,
        ),
        itemCount: controller.knowledgeList.length,
        itemBuilder: (context, index, animation) {
          final file = controller.knowledgeList[index];
          // print(file);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: _buildKnowledgeCard(file),
            ),
          );
        },
      );
    });
  }

  Widget _buildKnowledgeCard(dynamic file) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          HugeIcons.strokeRoundedDocumentAttachment,
          color: primaryColor,
          size: 20.sp,
        ),
        title: CustomText(
          title: file['name']!,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
        ),
        subtitle: CustomText(
          title: 'By ${file['updated_by']} • ${file['updated_on_date']}',
          fontSize: 12.sp,
          maxLines: 3,
          textAlign: TextAlign.start,
          color: Colors.grey,
        ),
        trailing: IconButton(
          icon: Icon(Icons.download),
          onPressed: () {
            if (file['file'] != null) {
              downloadFile(file['file']!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.all(16.w).copyWith(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                        Container(
                          width: 60.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// Code
                    Container(width: 100.w, height: 14.h, color: Colors.white),

                    SizedBox(height: 16.h),

                    /// Assigned by
                    Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedUser03,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 120.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    /// Assigned date & Deadline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                        Container(
                          width: 100.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
