import 'package:bnpteam/utils/exported_path.dart';

class Article extends StatelessWidget {
  Article({super.key});

  final controller = getIt<KmsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        // return LoadingWidget(color: primaryColor);
        return _buildShimmer();
      }

      if (controller.articleList.isEmpty) {
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
        itemCount: controller.articleList.length,
        itemBuilder: (context, index, animation) {
          final article = controller.articleList[index];
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: _buildArticleCard(article),
            ),
          );
        },
      );

      //   ListView.builder(
      //   itemCount: controller.articleList.length,
      //   itemBuilder: (context, index) {
      //     final article = controller.articleList[index];
      //     return _buildArticleCard(article);
      //   },
      // );
    });
  }

  Widget _buildArticleCard(article) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: article['name'] ?? '',
              fontSize: 18.sp,
              maxLines: 2,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8.h),
            CustomText(
              title:
                  "By ${article['updated_by']} • ${article['updated_on_date']}",
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
            SizedBox(height: 8.h),
            CustomText(
              title: article['short_description'] ?? '',
              fontSize: 14.sp,
              maxLines: 10,
              textAlign: TextAlign.start,
              color: Colors.grey[800],
            ),
            GestureDetector(
              onTap: () => launchUrlString(article['url']),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    Icon(Icons.open_in_new, size: 18.sp),
                    CustomText(
                      title: "Read More",
                      fontSize: 14.sp,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) => TaskCardShimmer(),
    );
  }
}
