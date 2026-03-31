import 'package:bnpteam/utils/exported_path.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = getIt<DashboardController>();
  final langController = getIt<TranslateController>();
  final nController = getIt<NavigationController>();
  final complaintController = getIt<ComplaintController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDashboard();
      getIt<UpdateController>().checkForUpdate();
      checkInternetAndShowPopup();
    });

    getIt<FirebaseTokenController>().updateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _infoGridShimmer();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 16.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statsGrid(),

              Obx(() => _complaintSummary()),

              _monthlyComplaintChart(),

              _complaintTypeChart(),

              _recentComplaints(),

              _deadComplaints(),

              // _departmentWiseComplaint(),
            ],
          ),
        );
      }),
    );
  }

  /////////////////////////////////////////////////////////////
  /// APP BAR
  /////////////////////////////////////////////////////////////

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: Image.asset(Images.logoAppBar, width: 0.35.sw),
      actions: [_languageToggle(), _notificationButton()],
    );
  }

  Widget _languageToggle() {
    return GestureDetector(
      onTap: () async {
        langController.toggleLang();
        await controller.getDashboard(load: false);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Obx(
          () => Image.asset(
            langController.lang.value == 'en'
                ? 'assets/images/translation_english_marathi.png'
                : 'assets/images/translation_marathi_english.png',
            width: 20.w,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _notificationButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.notificationList),
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          HugeIcons.strokeRoundedNotification02,
          color: primaryColor,
          size: 20.sp,
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// STATS GRID
  /////////////////////////////////////////////////////////////

  Widget _statsGrid() {
    final items = [
      DashboardCard(
        onTap: () {
          nController.updateIndex(1, isFromDashboard: false);
        },
        icon: HugeIcons.strokeRoundedAddToList,
        title: "Total Complaints",
        value: controller.dashboardData['total_complaints']?.toString() ?? '',
        iconColor: primaryColor,
        bgColor: Colors.blue,
      ),
      DashboardCard(
        onTap: () {
          complaintController.selectedFilterStatus.value = '3';
          nController.updateIndex(1, isFromDashboard: true);
        },
        icon: HugeIcons.strokeRoundedTickDouble03,
        title: "Completed Complaints",
        value:
            controller.dashboardData['completed_complaints']?.toString() ?? '',
        iconColor: primaryColor,
        bgColor: primaryGreen,
      ),
      DashboardCard(
        onTap: () {
          complaintController.selectedFilterStatus.value = '2';
          nController.updateIndex(1, isFromDashboard: true);
        },
        icon: HugeIcons.strokeRoundedProgress,
        title: "Inprogress Complaints",
        value:
            controller.dashboardData['inprogress_complaints']?.toString() ?? '',
        iconColor: primaryColor,
        bgColor: Colors.amber,
      ),
      DashboardCard(
        onTap: () {
          complaintController.selectedFilterStatus.value = '1';
          nController.updateIndex(1, isFromDashboard: true);
        },
        icon: HugeIcons.strokeRoundedTimeSchedule,
        title: "Pending Complaints",

        value: controller.dashboardData['pending_complaints']?.toString() ?? '',
        iconColor: primaryColor,
        bgColor: Colors.orange,
      ),
      DashboardCard(
        onTap: () {
          complaintController.selectedFilterStatus.value = '4';
          nController.updateIndex(1, isFromDashboard: true);
        },
        icon: HugeIcons.strokeRoundedCancel02,
        title: "Rejected Complaints",
        value:
            controller.dashboardData['rejected_complaints']?.toString() ?? '',
        iconColor: primaryColor,
        bgColor: Colors.red,
      ),
    ];

    return LiveGrid.options(
      options: LiveOptions(
        delay: Duration(milliseconds: 100),
        showItemInterval: Duration(milliseconds: 100),
        showItemDuration: Duration(milliseconds: 300),
        reAnimateOnVisibility: false,
      ),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: SizedBox(height: 50, child: items[index]),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  /////////////////////////////////////////////////////////////
  /// COMPLAINT SUMMARY PIE
  /////////////////////////////////////////////////////////////

  Widget _complaintSummary() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_complaints']?.toString() ?? '0',
    );

    final int completed = int.parse(
      controller.dashboardData['completed_complaints']?.toString() ?? '0',
    );
    final int inProgress = int.parse(
      controller.dashboardData['inprogress_complaints']?.toString() ?? '0',
    );
    final int pending = int.parse(
      controller.dashboardData['pending_complaints']?.toString() ?? '0',
    );
    final int rejected = int.parse(
      controller.dashboardData['rejected_complaints']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Complaint Summary", HugeIcons.strokeRoundedWaterfallUp01),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45.r,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: completed.toDouble(),
                          radius: 8.r,
                          color: Colors.green,
                          title: '',
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: inProgress.toDouble(),
                          radius: 8.r,
                          color: Colors.amber,
                          title: '',
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: pending.toDouble(),
                          radius: 8.r,
                          color: Colors.orange,
                          title: '',
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: rejected.toDouble(),
                          radius: 8.r,
                          color: Colors.red,
                          title: '',
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "In Progress",
                      inProgress,
                      Colors.amber,
                      percent(inProgress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Pending",
                      pending,
                      Colors.orange,
                      percent(pending),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Rejected",
                      rejected,
                      Colors.red,
                      percent(rejected),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// MONTHLY CHART
  /////////////////////////////////////////////////////////////

  Widget _monthlyComplaintChart() {
    if (controller.chartData.isEmpty) return const SizedBox.shrink();
    bool isAllZero = controller.chartData.every((item) {
      return (item["pending"] == 0) &&
          (item["inProgress"] == 0) &&
          (item["completed"] == 0) &&
          (item["rejected"] == 0);
    });
    if (isAllZero) return const SizedBox.shrink();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Monthly Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 16.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  legend("Pending", const Color(0xffe83e8c)),
                  legend("In Progress", const Color(0xffffc105)),
                  legend("Completed", const Color(0xff58d8a3)),
                  legend("Rejected", const Color(0xffFB0404)),
                ],
              ),

              SizedBox(height: 8.w),

              SizedBox(
                height: 250.h,
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h, right: 10.w),
                      width: controller.chartData.length * 60.w,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              tooltipBorderRadius: BorderRadius.circular(8.r),
                              tooltipPadding: EdgeInsets.all(8),
                              getTooltipItem: (group, _, __, ___) {
                                final item = controller.chartData[group.x];

                                return BarTooltipItem(
                                  "${item["month"]}\n"
                                  "Pending : ${item["pending"]}\n"
                                  "InProgress : ${item["inProgress"]}\n"
                                  "Completed : ${item["completed"]}\n"
                                  "Rejected : ${item["rejected"]}",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          barGroups: buildBarGroups(),

                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withValues(alpha: 0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),

                          borderData: FlBorderData(show: false),
                          maxY: controller.getMaxComplaintCount().toDouble(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >=
                                      controller.chartData.length) {
                                    return const SizedBox();
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(top: 6.h),
                                    child: Text(
                                      controller.chartData[value
                                          .toInt()]["month"],
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// COMPLAINT TYPE
  /////////////////////////////////////////////////////////////

  Widget _complaintTypeChart() {
    if (controller.complaintTypeData.isEmpty ||
        controller.complaintTypeData.values.every((value) => value == 0)) {
      return const SizedBox(); // OR show "No Data"
    }
    final chartData = controller.complaintTypeData.entries.toList();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Complaint Type", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 14.h),

          /// Your existing pie chart code
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.2.sh,
                  width: 0.2.sw,
                  child: PieChart(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    PieChartData(
                      sections: chartData.map((entry) {
                        final color = getColor(entry.key);
                        return PieChartSectionData(
                          color: color,
                          value: entry.value.toDouble(),
                          title: "${entry.value.toInt()}%",
                          radius: 24.r,
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chartData.map((entry) {
                    final color = getColor(entry.key);
                    return _legendItem(
                      entry.key,
                      entry.value.toInt(),
                      color,
                      entry.value.toDouble(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// RECENT COMPLAINTS
  /////////////////////////////////////////////////////////////

  Widget _recentComplaints() {
    if (controller.recentComplaints.isEmpty) return const SizedBox();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Recent Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 12.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.recentComplaints.asMap().entries.map((entry) {
                  // int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.complaintDetails,
                          arguments: {'id': dept['id'].toString()},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              dept['code']?.toString() ?? '-',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      tableCell(dept['department'] ?? '-'),
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: hexToColor(dept['status_color']),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: hexToColor(
                                    dept['status_color'],
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                dept['status'].toString(),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),

                      tableCell(dept['created_on'].toString()),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// DEAD COMPLAINTS
  /////////////////////////////////////////////////////////////

  Widget _deadComplaints() {
    if (controller.deadComplaints.isEmpty) return const SizedBox();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Dead Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 12.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.deadComplaints.asMap().entries.map((entry) {
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.complaintDetails,
                          arguments: {'id': dept['id'].toString()},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              dept['code']?.toString() ?? '-',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      tableCell(dept['department'] ?? '-'),
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: hexToColor(dept['status_color']),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: hexToColor(
                                    dept['status_color'],
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                dept['status'].toString(),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),

                      tableCell(dept['created_on'].toString()),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// Helper Widgets
  /////////////////////////////////////////////////////////////

  Widget _pieChartFiles() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_files']?.toString() ?? '0',
    );

    final int initialized = int.parse(
      controller.dashboardData['initialized_files']?.toString() ?? '0',
    );

    final int hold = int.parse(
      controller.dashboardData['hold_files']?.toString() ?? '0',
    );

    final int inprogress = int.parse(
      controller.dashboardData['inprogress_files']?.toString() ?? '0',
    );

    final int completed = int.parse(
      controller.dashboardData['completed_files']?.toString() ?? '0',
    );

    final int rejected = int.parse(
      controller.dashboardData['rejected_files']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              TranslatedText(
                title: "Files Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45.r,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: initialized.toDouble(),
                          radius: 26.r,
                          color: Colors.grey,
                          title: "${percent(initialized).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: hold.toDouble(),
                          radius: 22.r,
                          color: Colors.amberAccent,
                          title: "${percent(hold).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: inprogress.toDouble(),
                          radius: 22.r,
                          color: Colors.blueAccent,
                          title: "${percent(inprogress).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: completed.toDouble(),
                          radius: 28.r,
                          color: Colors.green,
                          title: "${percent(completed).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: rejected.toDouble(),
                          radius: 24.r,
                          color: Colors.redAccent,
                          title: "${percent(rejected).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      "Initialized",
                      initialized,
                      Colors.grey,
                      percent(initialized),
                    ),

                    SizedBox(height: 12.h),
                    _legendItem(
                      "Hold",
                      hold,
                      Colors.amberAccent,
                      percent(hold),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "In Progress",
                      inprogress,
                      Colors.blueAccent,
                      percent(inprogress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Rejected",
                      rejected,
                      Colors.redAccent,
                      percent(rejected),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pieChartTask() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_tasks']?.toString() ?? '0',
    );
    final int open = int.parse(
      controller.dashboardData['open_tasks']?.toString() ?? '0',
    );
    final int assigned = int.parse(
      controller.dashboardData['assignee_tasks']?.toString() ?? '0',
    );
    final int inProgress = int.parse(
      controller.dashboardData['inprogress_tasks']?.toString() ?? '0',
    );
    final int completed = int.parse(
      controller.dashboardData['completed_tasks']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              TranslatedText(
                title: "Task Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45.r,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: open.toDouble(),
                          radius: 24.r,
                          color: Colors.blue,
                          title: "${percent(open).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: assigned.toDouble(),
                          radius: 22.r,
                          color: Colors.orangeAccent,
                          title: "${percent(assigned).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: inProgress.toDouble(),
                          radius: 26.r,
                          color: Colors.purpleAccent,
                          title: "${percent(inProgress).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: completed.toDouble(),
                          radius: 28.r,
                          color: Colors.green,
                          title: "${percent(completed).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem("Open", open, Colors.blue, percent(open)),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Assigned",
                      assigned,
                      Colors.orangeAccent,
                      percent(assigned),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "In Progress",
                      inProgress,
                      Colors.purpleAccent,
                      percent(inProgress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    // _legendItem(
                    //   "Completed",
                    //   completed,
                    //   Colors.green,
                    //   percent(completed),
                    // ),
                    // SizedBox(height: 12.h),
                    // _legendItem(
                    //   "In Progress",
                    //   inProgress,
                    //   Colors.blue,
                    //   percent(inProgress),
                    // ),
                    // SizedBox(height: 12.h),
                    // _legendItem(
                    //   "Pending",
                    //   pending,
                    //   Colors.orange,
                    //   percent(pending),
                    // ),
                    // SizedBox(height: 12.h),
                    // _legendItem(
                    //   "Rejected",
                    //   rejected,
                    //   Colors.red,
                    //   percent(rejected),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, int count, Color color, double percent) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.h,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
        Expanded(
          child: TranslatedText(
            title: "$label ($count)",
            fontSize: 12.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            maxLines: 2,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            title: "${percent.toStringAsFixed(0)}%",
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoGridShimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(6, (index) => const DashboardCardShimmer()),
      ),
    );
  }

  Widget _departmentWiseComplaint() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Department Wise Complaint",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(), // Department column adapts to text size
                1: IntrinsicColumnWidth(), // Pending
                2: IntrinsicColumnWidth(), // In Progress
                3: IntrinsicColumnWidth(), // Complete
                4: IntrinsicColumnWidth(), // Reject
                5: IntrinsicColumnWidth(), // Total
                6: IntrinsicColumnWidth(), // Total
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('#', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Pending', isHeader: true),
                    tableCell('In Progress', isHeader: true),
                    tableCell('Completed', isHeader: true),
                    tableCell('Rejected', isHeader: true),
                    tableCell('Total', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.data.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  // dynamic total =
                  //     dept['pending'] +
                  //     dept['inProgress'] +
                  //     dept['complete'] +
                  //     dept['reject'];
                  return TableRow(
                    children: [
                      tableCell(index.toString()),
                      tableCell(dept['department']),
                      tableCell(dept['pending'].toString()),
                      tableCell(dept['inProgress'].toString()),
                      tableCell(dept['complete'].toString()),
                      tableCell(dept['reject'].toString()),
                      tableCell('100'),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> buildBarGroups() {
    return List.generate(controller.chartData.length, (index) {
      final item = controller.chartData[index];

      double pending = item["pending"].toDouble();
      double inProgress = item["inProgress"].toDouble();
      double completed = item["completed"].toDouble();
      double rejected = item["rejected"].toDouble();

      double total = pending + inProgress + completed + rejected;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            width: 10,

            rodStackItems: [
              /// Pending
              BarChartRodStackItem(0, pending, const Color(0xffe83e8c)),

              /// In Progress
              BarChartRodStackItem(
                pending,
                pending + inProgress,
                const Color(0xffffc105),
              ),

              /// Completed
              BarChartRodStackItem(
                pending + inProgress,
                pending + inProgress + completed,
                const Color(0xff58d8a3),
              ),

              /// Rejected
              BarChartRodStackItem(
                pending + inProgress + completed,
                total,
                const Color(0xffFB0404),
              ),
            ],
          ),
        ],
      );
    });
  }

  /////////////////////////////////////////////////////////////
  /// CARD WRAPPER (Reusable)
  /////////////////////////////////////////////////////////////

  Widget dashboardCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /////////////////////////////////////////////////////////////
  /// HEADER
  /////////////////////////////////////////////////////////////
  Widget header(String title, IconData icon) {
    return Row(
      spacing: 10.w,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 18.sp, color: primaryColor),
        ),
        Expanded(
          child: TranslatedText(
            title: title,
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class DashboardCardShimmer extends StatelessWidget {
  const DashboardCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Title placeholder
            Container(width: 80, height: 12, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Value placeholder
            Container(width: 50, height: 20, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Percentage placeholder
            Container(width: 40, height: 12, color: Colors.grey[300]),
            const Spacer(),
            // Update date placeholder
            Container(width: 100, height: 10, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
