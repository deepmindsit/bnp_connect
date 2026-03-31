import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../routes/routes_names.dart';
import 'all_url.dart';
import 'local_storage.dart';
import 'package:get/get.dart';

class DioClient {
  static Dio getInstance() {
    final options = BaseOptions(
      contentType: 'multipart/form-data',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    );

    final dio = Dio(options);
    //
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;
    //       return client;
    //     };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = options.uri == Uri.parse(AllUrl.legalPage)
              ? 'demo'
              : await LocalStorage.getString('auth_key') ?? 'demo';

          options.headers.clear();
          options.headers.addAll({
            'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
            'Accept': 'application/json',
          });

          // if (kDebugMode) {
          //   debugPrint('📤 Request: ${options.method} ${options.uri}');
          //   debugPrint('Headers: ${options.headers}');
          //   debugPrint('Body: ${options.data}');
          //   debugPrint('token: $token');
          // }

          return handler.next(options);
        },

        // onResponse: (response, handler) async {
        //   if (kDebugMode) {
        //     log('✅ Response: ${response.statusCode} → ${response.data}');
        //   }
        //   final requestPath = response.requestOptions.path;
        //   if (!requestPath.contains('sign-in') ||
        //       !requestPath.contains(AllUrl.legalPage)) {
        //     if (response.data['common']['user_login'] == false) {
        //       Get.snackbar(
        //         "Logged Out",
        //         "You have logged in on another device. Please login again.",
        //         snackPosition: SnackPosition.TOP,
        //         backgroundColor: Colors.red.shade100,
        //         colorText: Colors.black,
        //         duration: const Duration(seconds: 3),
        //       );
        //       await LocalStorage.clear();
        //       Get.offAllNamed(Routes.login);
        //     }
        //   }
        //
        //   return handler.next(response);
        // },
        onResponse: (response, handler) async {
          final requestPath = response.requestOptions.path;
          // if (kDebugMode) {
          //   log(
          //     '✅ Response:$requestPath ${response.statusCode} → ${response.data}',
          //   );
          // }

          // Exclude login and legal page APIs
          final isAuthOrLegal =
              requestPath.contains('sign-in') ||
              requestPath.contains(AllUrl.legalPage);

          if (!isAuthOrLegal) {
            final userLogin = response.data['common']['user_login'];

            if (userLogin == false) {
              Get.snackbar(
                "Logged Out",
                "You have logged in on another device. Please login again.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red.shade100,
                colorText: Colors.black,
                duration: const Duration(seconds: 3),
              );

              await LocalStorage.clear();
              Get.offAllNamed(Routes.login);
            }
          }

          return handler.next(response);
        },

        onError: (error, handler) {
          // if (kDebugMode) {
          //   debugPrint(
          //     '❌ Dio Error [${error.response?.statusCode}] → ${error.message}',
          //   );
          // }
          return handler.next(error);
        },
      ),
    );
    return dio;
  }
}
