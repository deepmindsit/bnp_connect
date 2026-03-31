import 'package:bnpteam/utils/exported_path.dart';

@lazySingleton
class KmsController extends GetxController {
  final ApiService _apiService = Get.find();
  final knowledgeList = [].obs;
  final articleList = [].obs;
  final isLoading = false.obs;
  late TabController tabController;
  var tabIndex = 0.obs;

  void setTabController(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    tabController.addListener(() {
      int newIndex = tabController.index;
      if (tabIndex.value != newIndex) {
        tabIndex.value = newIndex;
      }
    });
    getKMS();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // =================== FETCH KMS LIST ===================
  /// Fetches all kms
  Future<void> getKMS() async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res0 = await _apiService.getKms(userId, "0");
      final res1 = await _apiService.getKms(userId, "1");

      if (res0['common']['status'] == true) knowledgeList.value = res0['data'];
      if (res1['common']['status'] == true) articleList.value = res1['data'];
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
