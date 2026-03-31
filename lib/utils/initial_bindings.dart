import 'exported_path.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    final dio = DioClient.getInstance();
    // Get.put<NetworkController>(getIt<NetworkController>(), permanent: true);
    //
    Get.put<ApiService>(ApiService(dio), permanent: true);
  }
}
