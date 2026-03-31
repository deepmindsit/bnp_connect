import 'package:bnpteam/utils/exported_path.dart';

@lazySingleton
class FirebaseTokenController extends GetxController {
  final ApiService _apiService = Get.find();

  Future<void> updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
     await _apiService.updateFirebaseToken(userId, token.toString());
    } catch (e) {
      debugPrint("Login error: $e");
    }
  }
}
