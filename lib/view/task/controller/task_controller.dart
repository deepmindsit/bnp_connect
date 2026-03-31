import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';

@lazySingleton
class TaskController extends GetxController {
  final ApiService _apiService = Get.find();

  // Task Data
  final taskList = [].obs;
  final taskDetails = {}.obs;

  // Loaders
  final isLoading = false.obs;
  final isStatusLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isMainLoading = false.obs;
  final isAddingLoading = false.obs;

  // Dropdown Lists
  final priorityList = [].obs;
  final statusList = [].obs;
  final assigneeList = [].obs;

  // Form Selections
  final selectedStatus = RxnString();
  final selectedPriority = RxnString();
  final selectedAssignee = RxnString();
  final selectedAssigneeName = RxnString();
  final descriptionController = TextEditingController();
  final newAttachments = [].obs;

  //add Task
  final addTaskFormKey = GlobalKey<FormState>();
  final updateTaskFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final addTaskDescController = TextEditingController();
  Rxn<DateTime> endDate = Rxn<DateTime>();
  RxList<bool> isSelected = [true, false, false, false].obs;
  final selectedEndDate = RxnString();

  final showPriorityError = false.obs;
  final showAssigneeError = false.obs;

  @override
  void onClose() {
    descriptionController.dispose();
    newAttachments.clear();
    super.onClose();
  }

  /// Initializes the dropdown selections from task details
  void setInitialData() {
    selectedPriority.value = taskDetails['priority_id']?.toString() ?? '';
    selectedStatus.value = taskDetails['status_id']?.toString() ?? '';
    selectedAssignee.value = taskDetails['assignee_id']?.toString() ?? '';
    selectedAssigneeName.value = taskDetails['assignee']?.toString() ?? '';
    descriptionController.clear();
    newAttachments.clear();
  }

  /// Fetches all tasks for the logged-in user

  final page = 0.obs;
  final hasNextPage = true.obs;
  final isMoreLoading = false.obs;

  Future<void> getTaskInitial({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    page.value = 0;
    taskList.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getTask(
        userId,
        page.value.toString(),
        selectedStatus.value ?? '',
        getDateParam(),
      );

      if (res['common']['status'] == true) {
        taskList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Fetches getTaskLoadMore
  Future<void> getTaskLoadMore() async {
    isMoreLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      page.value += 1;
      final res = await _apiService.getTask(
        userId,
        page.value.toString(),
        selectedStatus.value ?? '',
        getDateParam(),
      );
      if (res['common']['status'] == true) {
        final List fetchedPosts = res['data'];
        if (fetchedPosts.isNotEmpty) {
          taskList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      } else {
        hasNextPage.value = false;
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  // Future<void> getTask() async {
  //   isLoading.value = true;
  //   final userId = await LocalStorage.getString('user_id') ?? '';
  //   try {
  //     final res = await _apiService.getTask(userId, page.value.toString());
  //     if (res['common']['status'] == true) {
  //       taskList.value = res['data'] ?? [];
  //     }
  //   } catch (e) {
  //     showToastNormal('Something went wrong. Please try again later.');
  //     debugPrint("Login error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Fetches task details by [taskId]
  Future<void> getTaskDetails(String taskId) async {
    isDetailsLoading.value = true;
    taskDetails.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getTaskDetails(userId, taskId);
      if (res['common']['status'] == true) {
        taskDetails.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// Fetches list of available priorities
  Future<void> getTaskPriority() async {
    await _fetchDropdownData(_apiService.getPriority, priorityList);
  }

  /// Fetches list of available statuses
  Future<void> getTaskStatus() async {
    isStatusLoading.value = true;
    await _fetchDropdownData(_apiService.getTaskStatus, statusList);
    isStatusLoading.value = false;
  }

  /// Fetches list of assignees
  Future<void> getTaskAssignee() async {
    await _fetchDropdownData(_apiService.getAssignee, assigneeList);
  }

  /// Adds a task comment with optional attachments
  Future<void> addTaskComment(String taskId) async {
    isAddingLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final attachment = await prepareDocuments(newAttachments);
      final res = await _apiService.addTaskComment(
        userId,
        taskId,
        selectedStatus.value!,
        descriptionController.text.trim(),
        attachment: attachment,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? 'Comment added');
        Get.back();
        await getTaskDetails(taskId);
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isAddingLoading.value = false;
    }
  }

  /// Utility to fetch dropdown list data
  Future<void> _fetchDropdownData(
    dynamic Function(String userId) fetchFn,
    RxList<dynamic> targetList,
  ) async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await fetchFn(userId);
      if (res['common']['status'] == true) {
        targetList.value = res['data'] ?? [];
      }
    } catch (e) {
      _handleError('Failed to fetch dropdown data', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds a task with optional attachments
  Future<void> addTask() async {
    isAddingLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final attachment = await prepareDocuments(newAttachments);
      final res = await _apiService.addNewTask(
        userId,
        titleController.text.trim(),
        selectedStatus.value!,
        selectedPriority.value!,
        selectedAssignee.value!,
        selectedEndDate.value!,
        addTaskDescController.text.trim(),
        attachment: attachment,
      );
      // print('res===============>$res');
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? 'New Task added');
        resetForm();
        await getTaskInitial();
        Get.back();
        // await getTaskDetails(taskId);
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isAddingLoading.value = false;
    }
  }

  void _handleError(String message, Object error) {
    showToastNormal('$message. Please try again later.');
    // debugPrint('$message: $error');
  }

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  String getDateParam() {
    if (customStart != null && customEnd != null) {
      return "${_dateFormat.format(customStart!)} - ${_dateFormat.format(customEnd!)}";
    }
    return ""; // blank if not selected
  }

  void resetForm() {
    // Clear text fields
    titleController.clear();
    addTaskDescController.clear();

    // Reset dropdown/selections
    selectedStatus.value = null;
    selectedPriority.value = null;
    selectedAssignee.value = null;
    selectedEndDate.value = null;
    endDate.value = null;

    // Clear attachments
    newAttachments.clear();

    // Reset form validation state
    addTaskFormKey.currentState?.reset();
  }

  //////////////////////////////filter//////////////////////////////////////
  // Date Range
  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;

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
    // applyFilters();
    selectedDateRange.value = null;
    selectedStatus.value = null;
    customStart = null;
    customEnd = null;
    Get.back();
    applyFilters();
  }

  void applyFilters() async {
    Get.back();
    await getTaskInitial();
  }
}

// Future<void> getTaskPriority() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getPriority(userId);
//     if (res['common']['status'] == true) {
//       priorityList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
//
// Future<void> getTaskStatus() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getTaskStatus(userId);
//     if (res['common']['status'] == true) {
//       statusList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
//
// Future<void> getTaskAssignee() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getAssignee(userId);
//     if (res['common']['status'] == true) {
//       assigneeList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
