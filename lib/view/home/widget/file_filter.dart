import '../../../utils/exported_path.dart';

class FileFilter extends StatefulWidget {
  const FileFilter({super.key});

  @override
  State<FileFilter> createState() => _FileFilterState();
}

class _FileFilterState extends State<FileFilter> {
  final controller = getIt<AddFileController>();

  @override
  void initState() {
    controller.getPublicService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8.h),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child:
              controller.isServiceLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : SingleChildScrollView(
                    child: Column(
                      spacing: 16.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Department Filter
                        _buildFileType(),
                        // multiSelectionItem(),

                        /// Date Range
                        _buildDateRange(),

                        /// Complaint Status
                        _buildStatus(),

                        /// Complaint Type
                        // _buildComplaintType(),

                        /// Apply / Reset
                        _buildButtons(),
                      ],
                    ),
                  ),
        ),
      );
    });
  }

  Widget _buildFileType() {
    return AppDropdownField(
      isDynamic: true,
      title: 'File Type',
      value: controller.selectedFileType.value,
      items: controller.fileTypeList,
      hintText: 'Select File Type',
      validator: (value) => value == null ? 'Please select File Type' : null,
      onChanged: (val) => controller.selectedFileType.value = val!,
    );
  }

  Widget _buildDateRange() {
    return AppDropdownField(
      title: 'Date Range',
      value: controller.selectedDateRange.value,
      items: ["Today", "Yesterday", "This Week", "This Month", "Custom"],
      hintText: 'Select Date Range',
      validator: (value) => value == null ? 'Please select Date Range' : null,
      onChanged: (val) async {
        controller.selectedDateRange.value = val!;
        // if (val == "Custom") controller.pickCustomDateRange();
        if (val == "Custom") {
          controller.pickCustomDateRange();
        } else {
          controller.setDateRange(val);
        }
      },
    );
  }

  Widget _buildStatus() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Status',
      value: controller.selectedStatus.value,
      items: controller.statusList,
      hintText: 'Select Status',
      validator: (value) => value == null ? 'Please select Status' : null,
      onChanged: (val) => controller.selectedStatus.value = val!,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Reset -> OutlinedButton
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              side: BorderSide(color: primaryColor), // outline color
            ),
            onPressed: controller.resetFilters,
            child: Text("Reset", style: TextStyle(color: primaryColor)),
          ),
        ),
        SizedBox(width: 12.w), // space between buttons
        // Apply -> ElevatedButton
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: controller.applyFilters,
            child: Text("Apply"),
          ),
        ),
      ],
    );
  }
}
