import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';

@lazySingleton
class ComplaintController extends GetxController {
  final ApiService _apiService = Get.find();
  final complaintList = [].obs;
  final complaintDetails = {}.obs;
  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isSendLoading = false.obs;
  final isDepartmentLoading = false.obs;
  final isWardLoading = false.obs;
  final isMainLoading = false.obs;
  final isComplaintLoading = false.obs;

  //update Complaint
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final selectedDepartment = RxnString();
  final selectedStatus = RxnString();
  final selectedFilterStatus = RxnString();
  final selectedWard = RxnString();
  final selectedHOD = RxnString();
  final selectedFieldOfficer = RxnString();
  final newAttachments = [].obs;
  final departmentList = [].obs;
  final wardList = [].obs;
  final hodList = [].obs;
  final fieldOfficerList = [].obs;
  final statusList = [].obs;

  final page = 0.obs;
  final hasNextPage = true.obs;
  final isMoreLoading = false.obs;

  final showFieldOfficerError = false.obs;
  final showHODError = false.obs;
  final showWardError = false.obs;
  final showDepartmentError = false.obs;

  /// Fetches getComplaintInitial
  Future<void> getComplaintInitial({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    page.value = 0;
    hasNextPage.value = true;
    complaintList.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getComplaint(
        userId,
        page.value.toString(),
        selectedDepartmentIds,
        selectedFilterStatus.value ?? '',
        selectedSource.value ?? '',
        getDateParam(),
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      if (res['common']['status'] == true) {
        complaintList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("getComplaintInitial error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Fetches getComplaintLoadMore
  Future<void> getComplaintLoadMore() async {
    isMoreLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      page.value += 1;
      final res = await _apiService.getComplaint(
        userId,
        page.value.toString(),
        selectedDepartmentIds,
        selectedFilterStatus.value ?? '',
        selectedSource.value ?? '',
        getDateParam(),
        getIt<TranslateController>().lang.value == 'mr' ? 'mr' : 'en',
      );
      if (res['common']['status'] == true) {
        final List fetchedPosts = res['data'];
        if (fetchedPosts.isNotEmpty) {
          complaintList.addAll(fetchedPosts);
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

  Future<void> getStatus() async {
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getStatus(userId);
      if (res['common']['status'] == true) {
        statusList.value = res['data'] ?? [];
        departments.value = res['user']['department'] ?? [];
      } else {
        showToastNormal(res['common']['message'] ?? 'Error fetching status');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {}
  }

  Future<void> getComplaintDetails(String complaintId) async {
    isDetailsLoading.value = true;
    complaintDetails.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getComplaintDetails(userId, complaintId);
      if (res['common']['status'] == true) {
        complaintDetails.value = res['data'][0] ?? {};
      }
      // else {
      //   showToastNormal(
      //     // res['common']['message'] ??
      //         'Something went wrong. Please try again later.',
      //   );
      // }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isDetailsLoading.value = false;
    }
  }

  Future<void> addComplaintComment(String complaintId) async {
    isComplaintLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final docs = await prepareDocuments(newAttachments);
      final res = await _apiService.addComplaintComment(
        userId,
        complaintId,
        selectedStatus.value!,
        selectedFieldOfficer.value.toString(),
        selectedHOD.value.toString(),
        selectedDepartment.value.toString(),
        descriptionController.text.trim(),
        attachment: docs,
      );

      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message']);
        Get.back();
        if (complaintDetails['department_id']?.toString() !=
            selectedDepartment.value) {
          Get.offAllNamed(Routes.mainScreen);
        }
        await getComplaintDetails(complaintId);
        resetUpdateForm();
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
    } finally {
      isComplaintLoading.value = false;
    }
  }

  Future<void> getDepartment() async {
    isDepartmentLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getDepartment(userId);
      if (res['common']['status'] == true) {
        departmentList.value = res['data'] ?? [];
      } else {
        showToastNormal(
          res['common']['message'] ??
              'Something went wrong. Please try again later.',
        );
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isDepartmentLoading.value = false;
    }
  }

  Future<void> getWard() async {
    isWardLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getWard(userId);
      if (res['common']['status'] == true) {
        wardList.value = res['data'] ?? [];
      } else {
        showToastNormal(
          res['common']['message'] ??
              'Something went wrong. Please try again later.',
        );
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
    } finally {
      isWardLoading.value = false;
    }
  }

  void setInitialData() {
    selectedDepartment.value =
        complaintDetails['department_id']?.toString() ?? '';
    selectedStatus.value = complaintDetails['status_id']?.toString();
    selectedWard.value = complaintDetails['ward_id']?.toString() ?? '';
    updateOfficers(
      complaintDetails['department_id']?.toString() ?? '',
      isInitial: true,
    );
  }

  void resetUpdateForm() {
    descriptionController.clear();
    // selectedStatus.value = null;
    newAttachments.clear();
  }

  void updateOfficers(String departmentId, {bool isInitial = false}) {
    final selectedDept = departmentList.firstWhere(
      (element) => element['id'].toString() == departmentId,
      orElse: () => {},
    );

    hodList.value = selectedDept['hod'] ?? [];
    fieldOfficerList.value = selectedDept['field_officer'] ?? [];

    if (isInitial) {
      final hodId = complaintDetails['hod_id']?.toString();
      final fieldId = complaintDetails['field_id']?.toString();

      final hodMatch = hodList.firstWhere(
        (e) => e['id'].toString() == hodId,
        orElse: () => null,
      );

      final fieldMatch = fieldOfficerList.firstWhere(
        (e) => e['id'].toString() == fieldId,
        orElse: () => null,
      );

      if (hodId != null && hodId.isNotEmpty && hodMatch != null) {
        selectedHOD.value = hodId;
      }

      if (fieldId != null && fieldId.isNotEmpty && fieldMatch != null) {
        selectedFieldOfficer.value = fieldId;
      }
    } else {
      selectedHOD.value = null;
      selectedFieldOfficer.value = null;
    }
  }

  //////////////////////////////////////////Filter////////////////////////////////////////

  final mainLoader = false.obs;

  Future<void> loadInitialData() async {
    mainLoader.value = true;
    await Future.wait([getStatus()]);
    mainLoader.value = false;
  }

  // Future<void> getDepartmentFilter() async {
  //   final data = await LocalStorage.getJson("department");
  //   if (data != null) {
  //     departments.value = List<Map<String, dynamic>>.from(data);
  //   }
  // }

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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

  // Department
  final departments = [].obs;
  final selectedDepartments = <String>[].obs;

  // Date Range
  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;

  final selectedDepartmentName = [].obs;
  final selectedDepartmentIds = <String>[].obs;

  // Complaint Source
  final sourceList = [
    {"id": '', "name": "All"},
    {"id": 1, "name": "Web"},
    {"id": 2, "name": "App"},
    {"id": 3, "name": "Toll Free"},
    {"id": 4, "name": "Inward"},
    {"id": 5, "name": "WhatsApp"},
  ].obs;
  final selectedSource = RxnString();

  void toggleDepartment(String dept) {
    if (selectedDepartments.contains(dept)) {
      selectedDepartments.remove(dept);
    } else {
      selectedDepartments.add(dept);
    }
  }

  String getDateParam() {
    if (customStart != null && customEnd != null) {
      return "${_dateFormat.format(customStart!)} - ${_dateFormat.format(customEnd!)}";
    }
    return ""; // blank if not selected
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

      // 👇 Format dates
      String formatted =
          "${_dateFormat.format(customStart!)} to ${_dateFormat.format(customEnd!)}";

      // 👇 Update dropdown value
      selectedDateRange.value = formatted;
    } else {
      // If user cancels, keep them null
      customStart = null;
      customEnd = null;
    }
  }

  void resetFilters(bool isHome) {
    applyFilters();
    // selectedDepartmentFilter.value = null;
    selectedDateRange.value = null;
    if (!isHome) selectedFilterStatus.value = null;
    selectedSource.value = null;
    customStart = null;
    customEnd = null;
    selectedDepartmentIds.clear();
    selectedDepartmentName.clear();
  }

  void applyFilters() async {
    Get.back();
    await getComplaintInitial();
  }
}
