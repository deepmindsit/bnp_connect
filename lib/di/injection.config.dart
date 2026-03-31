// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bnpteam/common/update_app.dart' as _i324;
import 'package:bnpteam/network/api_service.dart' as _i15;
import 'package:bnpteam/network/register_module.dart' as _i356;
import 'package:bnpteam/utils/translate_controller.dart' as _i776;
import 'package:bnpteam/view/complaint/controller/complaint_controller.dart'
    as _i520;
import 'package:bnpteam/view/dashboard/controller/dashboard_controller.dart'
    as _i116;
import 'package:bnpteam/view/dashboard/controller/notification_controller.dart'
    as _i1034;
import 'package:bnpteam/view/dashboard/controller/profile_controller.dart'
    as _i203;
import 'package:bnpteam/view/dashboard/controller/update_firebase_token.dart'
    as _i599;
import 'package:bnpteam/view/home/controller/add_file_controller.dart' as _i153;
import 'package:bnpteam/view/knowledge/controller/kms_controller.dart' as _i411;
import 'package:bnpteam/view/navigation/controller/navigation_controller.dart'
    as _i175;
import 'package:bnpteam/view/onboarding/controller/onboarding_controller.dart'
    as _i333;
import 'package:bnpteam/view/onboarding/controller/user_controller.dart'
    as _i201;
import 'package:bnpteam/view/task/controller/task_controller.dart' as _i292;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i324.UpdateController>(() => _i324.UpdateController());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i776.TranslateController>(
      () => _i776.TranslateController(),
    );
    gh.lazySingleton<_i520.ComplaintController>(
      () => _i520.ComplaintController(),
    );
    gh.lazySingleton<_i116.DashboardController>(
      () => _i116.DashboardController(),
    );
    gh.lazySingleton<_i1034.NotificationController>(
      () => _i1034.NotificationController(),
    );
    gh.lazySingleton<_i203.ProfileController>(() => _i203.ProfileController());
    gh.lazySingleton<_i599.FirebaseTokenController>(
      () => _i599.FirebaseTokenController(),
    );
    gh.lazySingleton<_i153.AddFileController>(() => _i153.AddFileController());
    gh.lazySingleton<_i411.KmsController>(() => _i411.KmsController());
    gh.lazySingleton<_i175.NavigationController>(
      () => _i175.NavigationController(),
    );
    gh.lazySingleton<_i333.OnboardingController>(
      () => _i333.OnboardingController(),
    );
    gh.lazySingleton<_i201.UserService>(() => _i201.UserService());
    gh.lazySingleton<_i292.TaskController>(() => _i292.TaskController());
    gh.factory<_i15.ApiService>(() => _i15.ApiService(gh<_i361.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i356.RegisterModule {}
