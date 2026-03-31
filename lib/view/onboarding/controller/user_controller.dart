import '../../../utils/exported_path.dart';

@lazySingleton
class UserService {
  final RxString rollId = ''.obs;

  Future<void> loadRollId() async {
    rollId.value = await LocalStorage.getString('roll_id') ?? '';
  }

  Future<void> setRollId(String id) async {
    await LocalStorage.setString('roll_id', id);
    rollId.value = id;
  }

  Future<void> clearRollId() async {
    await LocalStorage.remove('roll_id');
    rollId.value = '';
  }
}

// final rollId = getIt<UserService>().rollId.value;
// await getIt<UserService>().setRollId('12345');
// await getIt<UserService>().clearRollId();
// Obx(() => Text('Roll ID: ${getIt<UserService>().rollId.value}'))
