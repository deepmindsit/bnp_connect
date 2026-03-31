import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final fromDashboard = false.obs;
  static final List<Widget> widgetOptions = <Widget>[
    DashboardPage(),
    // HomeScreen(),
    // TaskScreen(),
    ComplaintScreen(),
    // KnowledgeScreen(),
  ];

  void updateIndex(int index, {bool isFromDashboard = false}) {
    fromDashboard.value = isFromDashboard;
    currentIndex.value = index;
  }
}
