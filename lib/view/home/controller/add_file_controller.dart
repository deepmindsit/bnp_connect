import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';

@lazySingleton
class AddFileController extends GetxController {
  final ApiService _apiService = Get.find();

  // =================== UPDATE FILE  ===================
  final descriptionController = TextEditingController();
  final newAttachments = [].obs;
  final updateFormKey = GlobalKey<FormState>();

  void resetUpdateForm() {
    descriptionController.clear();
    selectedStatus.value = null;
    newAttachments.clear();
  }

  final List<Map<String, dynamic>> statusList = [
    {'id': '0', 'name': 'Initialized'},
    {'id': '1', 'name': 'Hold'},
    {'id': '2', 'name': 'Inprogress'},
    {'id': '3', 'name': 'Completed'},
    {'id': '4', 'name': 'Rejected'},
  ];

  // =================== ADD FILE COMMENT ===================
  Future<void> addFileComment(String fileId) async {
    isUpdateLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final docs = await prepareDocuments(newAttachments);
      final res = await _apiService.addFileComment(
        userId,
        fileId,
        selectedStatus.value!,
        descriptionController.text.trim(),
        attachment: docs,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message']);
        Get.back();
        await getFileDetails(fileId);
        resetUpdateForm();
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isUpdateLoading.value = false;
    }
  }

  // =================== FILE DATA ===================
  final fileList = [].obs;
  final fileDetails = {}.obs;

  // =================== LOADERS ===================
  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isUpdateLoading = false.obs;

  // =================== FORM CONTROLLERS ===================
  final formKey = GlobalKey<FormState>();
  final fileNumberController = TextEditingController();
  final organizationController = TextEditingController();
  final designationController = TextEditingController();
  final contactInfoController = TextEditingController();
  final subjectController = TextEditingController();

  // =================== DROPDOWN VALUES ===================
  Rxn<String> selectedType = Rxn<String>();
  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<String> selectedDepartment = Rxn<String>();
  Rxn<String> selectedCategory = Rxn<String>();
  Rxn<String> selectedSubCategory = Rxn<String>();
  Rxn<String> selectedMember = Rxn<String>();

  // =================== DATE PICKERS ===================
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // =================== REMINDER OPTIONS ===================
  RxInt selectedReminderValue = 1.obs;
  final List<Map<String, dynamic>> options = [
    {'label': '1 Day', 'value': 1},
    {'label': '1 Week', 'value': 2},
    {'label': '15 Days', 'value': 3},
  ];

  // =================== PRIORITY SELECTION ===================
  RxList<bool> isSelected = <bool>[true, false, false, false].obs;

  void selectPriority(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
  }

  // =================== FETCH FILE LIST ===================
  /// Fetches all Files for the logged-in user
  ///

  final page = 0.obs;
  final hasNextPage = true.obs;
  final isMoreLoading = false.obs;

  /// Fetches getFilesInitial
  Future<void> getFilesInitial({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    page.value = 0;
    fileList.clear();
    // print('getFilesInitial');
    // print(getDateParam());
    // print('selectedStatus=============>$selectedStatus');
    // print('selectedFileType====================>$selectedFileType');
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getFiles(
        userId,
        page.value.toString(),
        selectedStatus.value ?? '',
        getDateParam(),
        selectedFileType.value ?? '',
      );
// print('getFilesInitial res');
// print(res);
      if (res['common']['status'] == true) {
        fileList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Fetches getFilesLoadMore
  Future<void> getFilesLoadMore() async {
    isMoreLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      page.value += 1;
      final res = await _apiService.getFiles(
        userId,
        page.value.toString(),
        selectedStatus.value ?? '',
        getDateParam(),
        selectedFileType.value ?? '',
      );
      if (res['common']['status'] == true) {
        final List fetchedPosts = res['data'];
        if (fetchedPosts.isNotEmpty) {
          fileList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  // =================== FETCH FILE DETAILS ===================
  /// Fetches task details by [fileId]
  Future<void> getFileDetails(String fileId, {bool isLoading = true}) async {
    if (isLoading) isDetailsLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getFileDetails(userId, fileId);
      if (res['common']['status'] == true) {
        fileDetails.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      if (isLoading) isDetailsLoading.value = false;
    }
  }

  // =================== FORM SUBMIT ===================
  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (selectedType.value == null || selectedStatus.value == null) {
        Get.snackbar('Error', 'Please select Type and Status');
        return;
      }
      if (startDate.value == null || endDate.value == null) {
        Get.snackbar('Error', 'Please select both dates');
        return;
      }
      showToastNormal('File submitted successfully!');
      resetForm();
      // Perform API call or form submission here
      // Get.offAllNamed('/main');
    }
  }

  // =================== RESET FORM ===================
  void resetForm() {
    fileNumberController.clear();
    organizationController.clear();
    designationController.clear();
    contactInfoController.clear();
    subjectController.clear();

    selectedType.value = null;
    selectedStatus.value = null;
    selectedDepartment.value = null;
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedMember.value = null;

    startDate.value = null;
    endDate.value = null;
    selectedReminderValue.value = 1;
    isSelected.value = [true, false, false, false];
  }

  @override
  void onClose() {
    fileNumberController.dispose();
    organizationController.dispose();
    designationController.dispose();
    contactInfoController.dispose();
    subjectController.dispose();
    super.onClose();
  }

  // =================== FILTER ===================

  String getDateParam() {
    if (customStart != null && customEnd != null) {
      return "${_dateFormat.format(customStart!)} - ${_dateFormat.format(customEnd!)}";
    }
    return ""; // blank if not selected
  }

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;
  final selectedFileType = RxnString();
  final fileTypeList = [].obs;
  final isServiceLoading = false.obs;

  Future<void> getPublicService() async {
    isServiceLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getPublicService(userId);
      if (res['common']['status'] == true) {
        fileTypeList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isServiceLoading.value = false;
    }
  }

  Future<void> pickCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      customStart = picked.start;
      customEnd = picked.end;
    } else {
      // If user cancels, keep them null
      customStart = null;
      customEnd = null;
    }
  }

  void setDateRange(String val) {
    final now = DateTime.now();

    switch (val) {
      case "Today":
        customStart = now;
        customEnd = now;
        break;

      case "Yesterday":
        customStart = now.subtract(Duration(days: 1));
        customEnd = now.subtract(Duration(days: 1));
        break;

      case "This Week":
        final firstDayOfWeek = now.subtract(
          Duration(days: now.weekday - 1),
        ); // Monday
        final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
        customStart = firstDayOfWeek;
        customEnd = lastDayOfWeek;
        break;

      case "This Month":
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
        customStart = firstDayOfMonth;
        customEnd = lastDayOfMonth;
        break;

      case "Custom":
        // keep existing pickCustomDateRange() logic
        break;
      default:
        // If nothing selected, keep blank
        customStart = null;
        customEnd = null;
    }
  }

  void resetFilters() {
    applyFilters();
    // selectedDepartmentFilter.value = null;
    selectedDateRange.value = null;
    selectedStatus.value = null;
    selectedFileType.value = null;
    customStart = null;
    customEnd = null;
  }

  void applyFilters() async {
    Get.back();
    await getFilesInitial();
  }
}
