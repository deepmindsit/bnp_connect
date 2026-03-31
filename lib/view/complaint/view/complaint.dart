import 'package:bnpteam/utils/exported_path.dart';
import '../../../utils/color.dart' as color;

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = getIt<NavigationController>();
      if (!navController.fromDashboard.value) {
        controller.resetFilters(false);
      }
      controller.getComplaintInitial();
      checkInternetAndShowPopup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Complaints',
        showBackButton: false,
        titleSpacing: null,
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(isScrollControlled: true, ComplaintFilter());
            },
            icon: Icon(HugeIcons.strokeRoundedFilter),
          ),
        ],
      ),
      body: Obx(() {
        final complaints = controller.complaintList;

        if (controller.isLoading.isTrue) {
          return _buildShimmer();
        }

        if (complaints.isEmpty) {
          return _buildEmptyState();
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.getComplaintLoadMore();
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                LiveList.options(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  options: LiveOptions(
                    delay: Duration.zero,
                    showItemInterval: Duration(milliseconds: 100),
                    showItemDuration: Duration(milliseconds: 250),
                    reAnimateOnVisibility: false,
                  ),
                  itemCount: complaints.length,
                  itemBuilder: (context, index, animation) {
                    final ticket = complaints[index];
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: GestureDetector(
                          onTap: () => Get.toNamed(
                            Routes.complaintDetails,
                            arguments: {'id': ticket['id'].toString()},
                          ),
                          child: ComplaintCard2(
                            title: ticket['department'] ?? 'N/A',
                            location: ticket['ward']?.toString() ?? 'N/A',
                            date: ticket['created_on'] ?? 'N/A',
                            status: ticket['status'] ?? 'N/A',
                            statusColor:
                                ticket['status_color']!.toString().isNotEmpty
                                ? ticket['status_color'] ?? '0xFF898989'
                                : '0xFF898989',
                            ticketNo: ticket['code'] ?? '',
                            source: ticket['source'] ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                complaints.isEmpty ? const SizedBox() : buildLoader(),
              ],
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
        child: LoadingWidget(color: color.primaryColor),
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
            'assets/images/no_complaint_found.png',
            width: Get.width * 0.6,
          ),
          SizedBox(height: 16.sp),
          const Text(
            'No Complaints!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.sp),
          const Text(
            'You don\'t have any Complaints yet.',
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

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title and status shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 180.w, height: 16.h, color: Colors.grey),
                      Container(width: 60.w, height: 20.h, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  /// Location and Date shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100.w, height: 12.h, color: Colors.grey),
                      Container(width: 80.w, height: 12.h, color: Colors.grey),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  Divider(height: 16.h, thickness: 0.5.h),

                  /// Ticket No and icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 120.w, height: 12.h, color: Colors.grey),
                      Container(width: 20.w, height: 20.h, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
