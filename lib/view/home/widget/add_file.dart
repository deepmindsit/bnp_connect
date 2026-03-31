import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';

class AddFile extends StatefulWidget {
  const AddFile({super.key});

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final controller = getIt<AddFileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Add File', showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: 12.h,
            children: [
              _buildFileDetails(),
              _buildContactDetails(),
              _buildCategoryAndSubject(),
              _buildLabel('Attachments'.tr),
              _buildUploadDocuments(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildSubmitButton(),
    );
  }

  // ------------------ File Details ------------------ //
  Widget _buildFileDetails() {
    return _sectionContainer(
      title: 'File Details',
      child: Column(
        children: [
          _buildLabel('File Number'.tr, isRequired: true),
          _buildTextField('File Number', controller.fileNumberController),
          SizedBox(height: 10.h),
          _buildDropdown('Type', ['A', 'B', 'C'], controller.selectedType),
          SizedBox(height: 10.h),
          _buildDropdown('Status', [
            'Open',
            'Closed',
          ], controller.selectedStatus),
          SizedBox(height: 10.h),
          _buildLabel('Priority'.tr, isRequired: true),
          _buildToggleButtons(),
          SizedBox(height: 10.h),
          _buildDates(),
        ],
      ),
    );
  }

  // ------------------ Contact Details ------------------ //
  Widget _buildContactDetails() {
    return _sectionContainer(
      title: 'Contact Details',
      child: Column(
        children: [
          _buildDropdown('Department', [
            'Shubham',
            'Gaurav',
            'Rahul',
            'Prasad',
          ], controller.selectedDepartment),
          SizedBox(height: 10.h),
          _buildLabel('Organization'.tr),
          _buildTextField('Organization', controller.organizationController),
          SizedBox(height: 10.h),
          _buildLabel('Designation'.tr),
          _buildTextField('Designation', controller.designationController),
          SizedBox(height: 10.h),
          _buildLabel('Contact Info'.tr),
          _buildTextField('Contact Info', controller.contactInfoController),
          SizedBox(height: 10.h),
          _buildDropdown('Member', [
            'Shubham',
            'Gaurav',
            'Rahul',
            'Prasad',
          ], controller.selectedMember),
        ],
      ),
    );
  }

  // ------------------ Category & Subject ------------------ //
  Widget _buildCategoryAndSubject() {
    return _sectionContainer(
      title: 'Category & Subject',
      child: Column(
        children: [
          _buildDropdown('Category', [
            'Shubham',
            'Gaurav',
            'Rahul',
            'Prasad',
          ], controller.selectedCategory),
          SizedBox(height: 10.h),
          _buildDropdown('Sub Category', [
            'Shubham',
            'Gaurav',
            'Rahul',
            'Prasad',
          ], controller.selectedSubCategory),
          SizedBox(height: 10.h),
          _buildLabel('Subject'.tr),
          _buildTextField('Subject', controller.subjectController),
          SizedBox(height: 10.h),
          _buildLabel('Remainder'.tr),
          _buildReminderRadio(),
        ],
      ),
    );
  }

  // ------------------ Upload Documents ------------------ //
  Widget _buildUploadDocuments() {
    return GestureDetector(
      // onTap: controller.pickImages,
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

  // ------------------ Submit Button ------------------ //
  Widget buildSubmitButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.white,
          backgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: controller.submitForm,
        // onPressed: () => Get.offAllNamed(Routes.mainScreen),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  // ------------------ Common Widgets ------------------ //
  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text, isRequired: isRequired),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl) {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: ctrl,
      validator: (val) => val!.isEmpty ? 'Please enter $label' : null,
      hintText: 'Enter Your $label'.tr,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    Rxn<String> selectedValue,
  ) {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        value: selectedValue.value,
        title: label,
        items: items,
        hintText: 'Select $label',
        validator: (val) => val == null ? 'Please select $label' : null,
        onChanged: (val) => selectedValue.value = val,
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Obx(
      () => ToggleButtons(
        isSelected: controller.isSelected.toList(),
        onPressed: controller.selectPriority,
        borderWidth: 0.2,
        fillColor: primaryColor.withValues(alpha: 0.2),
        selectedColor: primaryColor,
        borderRadius: BorderRadius.circular(12),
        constraints: BoxConstraints(minHeight: 45, minWidth: Get.width * 0.2),
        children:
            ['Low', 'Medium', 'High', 'Urgent']
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(e),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildDates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 4),
              child: buildLabel('Received Date', isRequired: true),
            ),
            Obx(
              () => _buildDateField(
                selectedDate: controller.startDate.value,
                onDateSelected: (date) {
                  controller.startDate.value = date;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 4),
              child: buildLabel('File Date', isRequired: true),
            ),
            Obx(
              () => _buildDateField(
                selectedDate: controller.endDate.value,
                onDateSelected: (date) {
                  controller.endDate.value = date;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderRadio() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            controller.options
                .map(
                  (option) => Row(
                    children: [
                      Radio<int>(
                        activeColor: primaryColor,
                        value: option['value'],
                        groupValue: controller.selectedReminderValue.value,
                        onChanged:
                            (val) =>
                                controller.selectedReminderValue.value = val!,
                      ),
                      Text(option['label']),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return SizedBox(
      width: Get.width * 0.4.w,
      child: InkWell(
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
      ),
    );
  }

  Widget _sectionContainer({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: CustomText(
              title: title,
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}
