import 'package:bnpteam/utils/exported_path.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class OnboardingController extends GetxController {
  final isLoading = false.obs;
  final expanded = false.obs;
  final transitionDuration = const Duration(seconds: 1);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final isObscure = true.obs;
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    isLoading.value = true;
    try {
      final url = Uri.parse(AllUrl.login);
      // final client = await getHttpClient();
      final response = await http.post(
        //   final response = await client.post(
        url,
        headers: {'Authorization': 'Bearer demo'},
        body: {
          'username': userNameController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final Map<String, dynamic> res = json.decode(response.body);
      if (res['common']['status'] == true) {
        final user = res['user'];
        await LocalStorage.setString(
          'auth_key',
          user['auth_key']?.toString() ?? 'demo',
        );
        await LocalStorage.setString('user_id', user['id']?.toString() ?? '');
        await getIt<UserService>().setRollId(user['role_id']?.toString() ?? '');
        showToastNormal(res['common']['message'] ?? 'Login successful');
        Get.offAllNamed(Routes.mainScreen);
        userNameController.clear();
        passwordController.clear();
      } else {
        showToastNormal(res['common']['message'] ?? 'Login failed');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
