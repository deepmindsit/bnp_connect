import 'package:bnpteam/utils/exported_path.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  NotificationService().handleNotificationNavigation(data, '');
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().init();
  await configureDependencies();
  Get.put(DeepLinkController());
  await getIt<UserService>().loadRollId();
  // Get.put(getIt<NetworkController>(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilConfig.init(
      context: context,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final textScaler = TextScaler.linear(
            mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.0),
          );
          final newMediaQueryData = mediaQueryData.copyWith(
            boldText: false,
            textScaler: textScaler,
          );
          return MediaQuery(data: newMediaQueryData, child: child!);
        },
        title: 'BNP Connect',
        initialBinding: InitialBindings(),
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        initialRoute: Routes.splash,
        getPages: AppRoutes.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),
      ),
    );
  }
}
