import 'package:bnpteam/utils/exported_path.dart';

class UpdateFile extends StatefulWidget {
  const UpdateFile({super.key, required this.id});
  final String id;
  @override
  State<UpdateFile> createState() => _UpdateFileState();
}

class _UpdateFileState extends State<UpdateFile> {
  final controller = getIt<AddFileController>();

  @override
  void initState() {
    controller.resetUpdateForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: Get.height * 0.85.h),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.updateFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Description'.tr),
                _buildDescriptionField(),
                SizedBox(height: 12.h),
                _buildStatus(),
                SizedBox(height: 12.h),
                _buildLabel('Attachments'.tr),
                _buildUploadDocuments(),
                SizedBox(height: 12.h),
                _buildSelectedFilesWrap(),
                SizedBox(height: 20.h),
                buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: controller.descriptionController,
      validator:
          (value) => value!.isEmpty ? 'Please Enter Description'.tr : null,
      hintText: 'Enter Your Description'.tr,
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
      onChanged: (value) async {
        controller.selectedStatus.value = value.toString();
      },
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }

  Widget buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 8),
      child: CustomButton(
        isLoading: controller.isUpdateLoading,
        onPressed: () async {
          if (controller.updateFormKey.currentState!.validate()) {
            await controller.addFileComment(widget.id);
          }
        },
        backgroundColor: primaryColor,
        text: 'Update',
        width: 0.8.sw,
        height: 48.h,
      ),
    );
  }
}
