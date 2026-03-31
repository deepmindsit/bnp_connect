import 'package:dio/dio.dart';
import '../utils/exported_path.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();
}
