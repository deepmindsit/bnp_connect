import '../utils/exported_path.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = Get.put(ProfileController());
  late final WebViewController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .getLegalPage(widget.slug)
          .then(
            (value) =>
                setController('${controller.privacyData['url']}?key=demo'),
          );
    });
    super.initState();
  }

  setController(String link) {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                final p = progress / 100;
                Center(
                  child: CircularProgressIndicator(
                    value: double.parse(p.toString()),
                    strokeWidth: 2.0,
                  ),
                );
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(link));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isPolicyLoading.isTrue
              ? Container(
                color: Colors.white,
                child: LoadingWidget(color: primaryColor),
              )
              : Scaffold(
                appBar: CustomAppBar(
                  title: controller.privacyData['page_name'] ?? '',
                  showBackButton: true,
                  titleSpacing: 0,
                ),
                //
                // AppBar(
                //   surfaceTintColor: Colors.white,
                //   backgroundColor: Colors.white,
                //   titleSpacing: 0,
                //   title: CustomText(
                //     title:
                //     controller.privacyData['page_name'] ?? '',
                //     fontSize: 22.sp,
                //     fontWeight: FontWeight.bold,
                //
                //   ),
                // ),
                body: WebViewWidget(controller: _controller),
              ),
    );
  }
}
