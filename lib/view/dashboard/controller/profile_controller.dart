import 'dart:io';
import 'package:bnpteam/common/helper.dart' show showToastNormal;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:get/get.dart';
import '../../../network/api_service.dart';
import '../../../network/local_storage.dart' show LocalStorage;
import '../../../routes/routes_names.dart';

@lazySingleton
class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  final helpSupport = {}.obs;
  final privacyData = {}.obs;
  final userData = {}.obs;

  final isProfileLoading = false.obs;
  final isUpdateLoading = false.obs;
  final isHelpLoading = false.obs;
  final isDeleteLoading = false.obs;
  final isPolicyLoading = false.obs;

  setPrevData() {
    nameController.text = userData['name'] ?? '';
    emailController.text = userData['email'] ?? '';
    phoneController.text = userData['mobile_no'] ?? '';
  }

  //edit profile
  var profileImage = Rx<File?>(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> getHelpSupport() async {
    isHelpLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.helpAndSupport(userId);
      if (res['common']['status'] == true) {
        helpSupport.value = res['data'] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isHelpLoading.value = false;
    }
  }

  Future<void> getLegalPage(String slug) async {
    isPolicyLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.legalPage(userId, slug);
      if (res['common']['status'] == true) {
        privacyData.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isPolicyLoading.value = false;
    }
  }

  Future<void> getProfile() async {
    isProfileLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getProfile(userId);
      if (res['common']['status'] == true) {
        userData.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getProfile2() async {
    final userId = await LocalStorage.getString('user_id') ?? '';
    final res = await _apiService.getProfile(userId);

    return res;
  }

  Future<void> updateProfile() async {
    isUpdateLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.updateProfile(
        userId,
        nameController.text.trim(),
        profileImage: profileImage.value,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? '');
        Get.back();
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isUpdateLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    isDeleteLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.deleteAccount(userId);
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? '');
        LocalStorage.clear();
        Get.offAllNamed(Routes.login);
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isDeleteLoading.value = false;
    }
  }
}
