import 'package:bnpteam/utils/exported_path.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final controller = getIt<TaskController>();

  @override
  void initState() {
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
    controller.setInitialData();
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(title: 'Update Task', showBackButton: true),
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          FocusScope.of(context).unfocus();
          controller.showPriorityError.value = false;
          controller.showAssigneeError.value = false;
        },
        child: Obx(
          () =>
              controller.isMainLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Form(
                      key: controller.updateTaskFormKey,
                      child: Column(
                        children: [
                          _buildLabel('Description'.tr),
                          _buildDescriptionField(),
                          SizedBox(height: 12.h),
                          _buildPriority(),
                          SizedBox(height: 12.h),
                          _buildAssignee(),
                          SizedBox(height: 12.h),
                          _buildTaskStatus(),
                          SizedBox(height: 12.h),
                          _buildLabel('Attachments'.tr),
                          _buildUploadDocuments(),
                          SizedBox(height: 16.h),
                          _buildSelectedFilesWrap(),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
      bottomNavigationBar: buildUpdateButton(),
    );
  }

  Widget _buildDescriptionField() {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: controller.descriptionController,
      validator:
          (value) => value!.isEmpty ? 'Please Enter Description'.tr : null,
      hintText: 'Enter Your Description'.tr,
      maxLines: 5,
    );
  }

  Widget _buildPriority() {
    final isBlocked = getIt<UserService>().rollId.value == '5';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (isBlocked) {
              controller.showPriorityError.value = true;
              controller.showAssigneeError.value = false;
            }
          },
          child: AbsorbPointer(
            absorbing: isBlocked,
            child: AppDropdownField(
              isWithColor: true,
              isRequired: true,
              isDynamic: true,
              value: controller.selectedPriority.value,
              title: 'Priority',
              items: controller.priorityList,
              hintText: 'Select Priority',
              validator:
                  (value) => value == null ? 'Please select Priority' : null,
              onChanged: (value) async {
                controller.selectedPriority.value = value;
                // controller.updateOfficers(value!);
              },
            ),
          ),
        ),
        if (controller.showPriorityError.value)
          const ErrorMessageBox(
            message: "You are not allowed to change the Priority",
          ),
      ],
    );
  }

  // Widget _buildPriority() {
  //   return AppDropdownField(
  //     isWithColor: true,
  //     isRequired: true,
  //     isDynamic: true,
  //     value: controller.selectedPriority.value,
  //     title: 'Priority',
  //     items: controller.priorityList,
  //     hintText: 'Select Priority',
  //     validator: (value) => value == null ? 'Please select Priority' : null,
  //     onChanged: (value) async {
  //       controller.selectedPriority.value = value;
  //       // controller.updateOfficers(value!);
  //     },
  //   );
  // }

  Widget _buildAssignee() {
    final isBlocked = getIt<UserService>().rollId.value == '5';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Assignee'.tr),

        GestureDetector(
          onTap: () {
            if (isBlocked) {
              controller.showPriorityError.value = false;
              controller.showAssigneeError.value = true;
            }
          },
          child: AbsorbPointer(
            absorbing: isBlocked,
            child: DropdownSearchComponent(
              dropdownHeight: Get.height * 0.4.h,
              hintText: 'Select Item',
              showSearchBox: true,
              searchHintText: 'Select Item',
              items: controller.assigneeList,
              preselectedValue: controller.selectedAssigneeName.value,
              onChanged: (value) {
                final selectedItem = controller.assigneeList.firstWhere(
                  (item) => item['name'].toString() == value.toString(),
                  orElse: () => {},
                );
                controller.selectedAssignee.value =
                    selectedItem['id'].toString();
              },
              validator: (value) => value == null ? 'Select Item' : null,
            ),
          ),
        ),
        if (controller.showAssigneeError.value)
          const ErrorMessageBox(
            message: "You are not allowed to change the Assignee",
          ),
      ],
    );
  }

  Widget _buildTaskStatus() {
    return AppDropdownField(
      isWithColor: true,
      isDynamic: true,
      title: 'Status',
      value: controller.selectedStatus.value,
      items: controller.statusList,
      onChanged: (value) {
        controller.selectedStatus.value = value;
      },
      hintText: 'Select Status',
      validator: (value) => value == null ? 'Please select Status' : null,
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
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: CustomText(
          title: 'Upload Documents',
          fontSize: 14.sp,
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

  Widget buildUpdateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 8),
        child: CustomButton(
          isLoading: controller.isAddingLoading,
          onPressed: () async {
            if (controller.updateTaskFormKey.currentState!.validate()) {
              await controller.addTaskComment(Get.arguments['id'].toString());
            }
          },
          backgroundColor: primaryColor,
          text: 'Update',
          width: 0.8.sw,
          height: 48.h,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }
}
