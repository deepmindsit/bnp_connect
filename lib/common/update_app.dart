import 'package:bnpteam/utils/exported_path.dart';

@lazySingleton
class UpdateController extends GetxController {
  var currentVersion = ''.obs;
  var latestVersion = ''.obs;
  var updateData = {}.obs;
  final ApiService _apiService = Get.find();
  final controller = getIt<ProfileController>();

  /// Fetches profile data and initializes package info.
  Future<void> checkForUpdate() async {
    await _getProfileData();
    await _initPackageInfo();
  }

  /// Fetch latest version from API
  Future<void> _getProfileData() async {
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final res = await _apiService.getProfile(userId);
      res['common']['status'] == true
          ? updateData.value = res['android']
          : updateData.value = {};
    } finally {}
  }

  /// Get system app version and compare with latest API version.
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    currentVersion.value = info.version;
    latestVersion.value = updateData['version'];

    int apiVersion = _versionToInt(latestVersion.value);
    int systemVersion = _versionToInt(currentVersion.value);

    if (apiVersion > systemVersion && updateData['show_popup'] == true) {
      _showUpdateDialog();
    }
  }

  /// Convert version `x.y.z` to integer for comparison.
  int _versionToInt(String version) {
    List<String> parts = version.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    int patch = int.parse(parts[2]);
    return major * 1000000 + minor * 1000 + patch;
  }

  /// Show Update Dialog
  void _showUpdateDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Text('Update Available'),
          content: const Text(
            'A new version of the app is available. Please update to continue.',
          ),
          actions: [
            if (updateData['force_update'] == true)
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'Exit App',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (updateData['force_update'] == false)
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Skip', style: TextStyle(color: Colors.grey)),
              ),
            TextButton(
              onPressed: () => launchURL(updateData['url']),
              child: Text('Update', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
