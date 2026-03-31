import 'package:bnpteam/utils/exported_path.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.mainScreen, page: () => NavigationScreen()),
    GetPage(name: Routes.addFile, page: () => AddFile()),
    GetPage(name: Routes.fileDetails, page: () => FileDetails()),
    GetPage(name: Routes.taskDetails, page: () => TaskDetails()),
    GetPage(name: Routes.updateTask, page: () => UpdateTask()),
    GetPage(name: Routes.complaintDetails, page: () => ComplaintDetails()),
    GetPage(name: Routes.addTask, page: () => AddTask()),
    GetPage(name: Routes.updateComplaint, page: () => UpdateComplaint()),
    GetPage(name: Routes.editProfile, page: () => EditProfile()),
    GetPage(name: Routes.helpSupport, page: () => HelpSupport()),
    GetPage(name: Routes.deleteAccount, page: () => DeleteAccount()),
    GetPage(name: Routes.notificationList, page: () => NotificationList()),
  ];
}
