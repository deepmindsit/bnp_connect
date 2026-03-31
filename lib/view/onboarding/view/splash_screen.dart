import 'package:bnpteam/utils/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final controller = getIt<OnboardingController>();
  String? token;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadPreferences();
    await Future.delayed(
      const Duration(seconds: 1),
    ).then((value) => setState(() => controller.expanded.value = true));
    await Future.delayed(const Duration(seconds: 1));
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      token != null
          ? Get.offAllNamed(Routes.mainScreen)
          : Get.offAllNamed(Routes.login);
    } else {
      noInternetDialog();
    }
  }

  Future<void> _loadPreferences() async {
    token = await LocalStorage.getString('auth_key');
  }

  // Future<void> _initialize() async {
  //   // Wait for the first frame to complete before navigating
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Future.delayed(const Duration(seconds: 3));
  //     controller.expanded = true;
  //
  //     final token = await LocalStorage.getString('auth_key');
  //     // print('token---->$token');
  //     token == null
  //         ? Get.offAllNamed(Routes.login)
  //         : Get.offAllNamed(Routes.mainScreen);
  //
  //     // Perform your navigation here
  //     // Get.offAll(() => LoginScreen());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              firstCurve: Curves.fastOutSlowIn,
              crossFadeState: !controller.expanded.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: controller.transitionDuration,
              firstChild: Container(),
              secondChild: _logoRemainder(),
              alignment: Alignment.centerLeft,
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Image.asset(Images.logoSplash, height: Get.width * 0.5.h);
  }
}
