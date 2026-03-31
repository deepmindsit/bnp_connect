import '../../../utils/exported_path.dart';

class TaskFilter extends StatefulWidget {
  const TaskFilter({super.key});

  @override
  State<TaskFilter> createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> {
  final controller = getIt<TaskController>();


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child:
              controller.isStatusLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : SingleChildScrollView(
                    child: Column(
                      spacing: 16.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Department Filter

                        // _buildDepartment(),
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

  // Widget _buildDepartment() {
  //   // If only one department, auto-select it
  //   if (controller.departments.length == 1) {
  //     controller.selectedDepartmentFilter.value =
  //         controller.departments.first['id'].toString();
  //   }
  //
  //   return AppDropdownField(
  //     isDynamic: true,
  //     title: 'Department',
  //     value: controller.selectedDepartmentFilter.value,
  //     items: controller.departments,
  //     hintText: 'Select Department',
  //     validator: (value) => value == null ? 'Please select Department' : null,
  //     onChanged: (val) => controller.selectedDepartmentFilter.value = val!,
  //   );
  // }

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
