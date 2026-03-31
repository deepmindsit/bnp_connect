import 'package:bnpteam/utils/exported_path.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen>
    with SingleTickerProviderStateMixin {
  final controller = getIt<KmsController>();

  @override
  void initState() {
    controller.setTabController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: CustomText(
          title: 'Knowledge Management System',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: controller.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: primaryColor,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                border: Border(bottom: BorderSide.none),
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: const [Tab(text: 'Knowledge'), Tab(text: 'Article')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [ Knowledge(), Article()],
      ),
    );
  }
}
