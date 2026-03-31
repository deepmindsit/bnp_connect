import 'package:bnpteam/utils/exported_path.dart';

class ScreenUtilConfig {
  static Widget init({required Widget child, required BuildContext context}) {
    return ScreenUtilInit(
      designSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, __) => child,
    );
  }
}
