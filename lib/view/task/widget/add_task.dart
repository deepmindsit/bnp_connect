import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final controller = getIt<TaskController>();

  @override
  void initState() {
    controller.resetForm();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
    super.initState();
  }

  void _fetchInitialData() async {
    controller.isMainLoading.value = true;
    await Future.wait([
      controller.getTaskStatus(),
      controller.getTaskAssignee(),
      controller.getTaskPriority(),
    ]);
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Add Task', showBackButton: true),
      body: Obx(() {
        if (controller.isMainLoading.isTrue) {
          LoadingWidget(color: primaryColor);
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: controller.addTaskFormKey,
            child: Column(
              children: [
                _buildLabel('Title'.tr),
                _buildTitleField(),
                SizedBox(height: 12.h),
                _buildLabel('Description'.tr),
                _buildDescriptionField(),
                SizedBox(height: 12.h),
                AppDropdownField(
                  isWithColor: true,
                  isRequired: true,
                  isDynamic: true,
                  title: 'Priority',
                  items: controller.priorityList,
                  hintText: 'Select Priority',
                  validator:
                      (value) =>
                          value == null ? 'Please select Priority' : null,
                  onChanged: (value) async {
                    controller.selectedPriority.value = value;
                    // controller.updateOfficers(value!);
                  },
                ),
                SizedBox(height: 12.h),
                _buildLabel('Assignee'.tr),
                DropdownSearchComponent(
                  dropdownHeight: Get.height * 0.4.h,
                  hintText: 'Select Assignee',
                  showSearchBox: true,
                  searchHintText: 'Select Assignee',
                  items: controller.assigneeList,
                  preselectedValue: null,
                  onChanged: (value) {
                    final selectedItem = controller.assigneeList.firstWhere(
                      (item) => item['name'].toString() == value.toString(),
                      orElse: () => {},
                    );
                    controller.selectedAssignee.value =
                        selectedItem['id'].toString();
                  },
                  validator:
                      (value) => value == null ? 'Select Assignee' : null,
                ),
                SizedBox(height: 12.h),

                AppDropdownField(
                  isWithColor: true,
                  isDynamic: true,
                  title: 'Status',
                  items: controller.statusList,
                  hintText: 'Select Status',
                  validator:
                      (value) => value == null ? 'Please select Status' : null,
                  onChanged: (value) async {
                    controller.selectedStatus.value = value.toString();
                  },
                ),
                SizedBox(height: 12.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 4),
                      child: buildLabel('End Date', isRequired: true),
                    ),
                    Obx(
                      () => _buildDateField(
                        selectedDate: controller.endDate.value,
                        onDateSelected: (date) {
                          controller.endDate.value = date;
                          controller.selectedEndDate.value = DateFormat(
                            'yyyy-MM-dd',
                          ).format(date);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildLabel('Attachments'.tr),
                _buildUploadDocuments(),
                SizedBox(height: 16.h),
                _buildSelectedFilesWrap(),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: buildSubmitButton(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }

  Widget _buildTitleField() {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: controller.titleController,
      validator: (value) => value!.isEmpty ? 'Please Enter title'.tr : null,
      hintText: 'Enter Your title'.tr,
    );
  }

  Widget _buildDescriptionField() {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: controller.addTaskDescController,
      validator:
          (value) => value!.isEmpty ? 'Please Enter Description'.tr : null,
      hintText: 'Enter Your Description'.tr,
    );
  }

  Widget _buildDateField({
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: borderStyle(),
          enabledBorder: borderStyle(),
          focusedBorder: borderStyle(),
          suffixIcon: Icon(Icons.calendar_today, size: 20),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('MMM dd, yyyy').format(selectedDate)
              : 'Select Date',
          style: TextStyle(
            color: selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadDocuments() {
    return GestureDetector(
      onTap: () {
        CustomFilePicker.showPickerBottomSheet(
          onFilePicked: (file) {
            controller.newAttachments.add(file);
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: CustomText(
          title: 'Upload Documents',
          fontSize: 14,
          color: primaryGrey,
        ),
      ),
    );
  }

  Widget _buildSelectedFilesWrap() {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 8,
        children:
            controller.newAttachments.map((file) {
              final isImage =
                  file.path.endsWith('.jpg') || file.path.endsWith('.png');

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: Get.width * 0.25.w,
                    height: Get.width * 0.25.w,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        isImage
                            ? Image.file(file, fit: BoxFit.cover)
                            : Center(
                              child: Icon(
                                HugeIcons.strokeRoundedDocumentAttachment,
                                size: 40.sp,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: InkWell(
                      onTap: () {
                        controller.newAttachments.remove(file);
                      },
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          size: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget buildSubmitButton() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 8),
        child: CustomButton(
          height: 50.h,
          backgroundColor: primaryColor,
          text: 'Submit',
          isLoading: controller.isAddingLoading,
          onPressed: () async {
            if (controller.isAddingLoading.isTrue) return;
            if (controller.addTaskFormKey.currentState!.validate()) {
              if (controller.endDate.value == null) {
                Get.snackbar('Error', 'Please select end date');
                return;
              }
              await controller.addTask();
            }
          },
        ),
      ),
    );
  }
}
