import 'dart:io';
import 'package:bnpteam/utils/exported_path.dart';
import 'package:intl/intl.dart';
import '../utils/color.dart' as app_color;

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.orange;
    case 'Approved':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

dynamic getIcon(String status) {
  switch (status) {
    case 'Pending':
      return HugeIcons.strokeRoundedHourglass;
    case 'In Progress':
      return HugeIcons.strokeRoundedTimeSchedule;
    case 'Completed':
      return HugeIcons.strokeRoundedCheckmarkBadge02;
    case 'Rejected':
      return HugeIcons.strokeRoundedCancelCircle;
    default:
      return HugeIcons.strokeRoundedHourglass;
  }
}

OutlineInputBorder buildOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.grey,
      width: 0.2,
    ), // Replace with AppColors.primaryColor
    borderRadius: BorderRadius.circular(10.r),
  );
}

IconData getIconForFile(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  if (['jpg', 'jpeg', 'png'].contains(ext)) return Icons.image;
  if (['pdf'].contains(ext)) return Icons.picture_as_pdf;
  if (['xls', 'xlsx'].contains(ext)) return Icons.grid_on;
  return Icons.insert_drive_file;
}

Widget sectionTitleWithIcon(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: CustomText(
      title: title,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

Widget infoItem({
  required IconData icon,
  required String text,
  double iconSize = 16,
  double fontSize = 13,
  Color iconColor = Colors.grey,
  Color textColor = Colors.black87,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: iconSize.sp, color: iconColor),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomText(
            title: text,
            fontSize: fontSize.sp,
            color: textColor,
            fontWeight: fontWeight,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}

Widget priorityBadge(String label, var color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Color(color).withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: CustomText(
      title: label,
      fontSize: 12.sp,
      color: Color(color),
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget buildRowTile(IconData icon, String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20, color: primaryColor),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value ?? '-',
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}

Widget buildKeyValue(String key, String? value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        SizedBox(
          width: 0.3.sw,
          child: CustomText(
            title: "$key: ",
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: CustomText(
            title: value ?? '-',
            fontSize: 14.sp,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}

void showToastNormal(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: app_color.primaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

void sendingMails(String mail) async {
  final Uri params = Uri(scheme: 'mailto', path: mail);
  var url = Uri.parse(params.toString());
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> downloadFile(String url) async {
  final fileName = Uri.parse(url).pathSegments.last;

  // Notify user about download start
  // Get.snackbar(
  //   'File Download',
  //   'Starting download for "$fileName"...',
  //   snackPosition: SnackPosition.BOTTOM,
  //   backgroundColor: Colors.white,
  //   colorText: Colors.black,
  // );

  showToastNormal('Starting download for "$fileName"...');

  // Start file download
  FileDownloader.downloadFile(
    url: url,
    name: fileName,
    onDownloadCompleted: (String filePath) async {
      final file = File(filePath);
      // print(file);
      // Try to open the downloaded file
      await OpenFilex.open(file.path);
    },
    onDownloadError: (String errorMessage) {
      // Notify user about download failure
      Get.snackbar(
        'Download Failed',
        'Could not download "$fileName". Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    },
  );
}

Color getFileTypeColor(String extension) {
  switch (extension) {
    case 'pdf':
      return Colors.red.shade400;
    case 'doc':
    case 'docx':
      return Colors.blue.shade400;
    case 'xls':
    case 'xlsx':
      return Colors.green.shade400;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Colors.purple.shade400;
    case 'zip':
    case 'rar':
      return Colors.orange.shade400;
    default:
      return primaryColor;
  }
}

bool isDeadlinePassed(String? deadline) {
  if (deadline == null) return false;
  try {
    final deadlineDate = DateFormat('yyyy-MM-dd').parse(deadline);
    return deadlineDate.isBefore(DateTime.now());
  } catch (e) {
    return false;
  }
}

String formatDate(String? date) {
  if (date == null) return '';
  try {
    final parsed = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(parsed);
  } catch (e) {
    return date;
  }
}

int daysUntilDeadline(String? deadline) {
  if (deadline == null) return 0;
  try {
    final now = DateTime.now();
    final due = DateTime.parse(deadline);
    return due.difference(now).inDays.clamp(0, 9999);
  } catch (e) {
    return 0;
  }
}

String deadlineLabel(String? deadline) {
  if (deadline == null) return "No deadline";
  try {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime.parse(deadline);
    final dueDate = DateTime(due.year, due.month, due.day);

    final diff = dueDate.difference(today).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Tomorrow";
    if (diff < 0) return "Expired";
    return "$diff days left";
  } catch (e) {
    return "Invalid date";
  }
}

bool isDueSoon(String? deadline) {
  return daysUntilDeadline(deadline) < 3;
}

double calculateTimelineProgress(String? startDate, String? endDate) {
  if (startDate == null || endDate == null) return 0;
  try {
    final now = DateTime.now();
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);

    if (now.isAfter(end)) return 1.0;
    if (now.isBefore(start)) return 0.0;

    final total = end.difference(start).inMilliseconds;
    final elapsed = now.difference(start).inMilliseconds;
    return (elapsed / total).clamp(0.0, 1.0);
  } catch (e) {
    return 0.0;
  }
}

Color getTimelineColor(String? startDate, String? endDate) {
  final progress = calculateTimelineProgress(startDate, endDate);
  if (progress > 0.9) return Colors.red.shade400;
  if (progress > 0.7) return Colors.orange.shade400;
  return Colors.green.shade400;
}

Color getColor(String key) {
  switch (key) {
    case 'Web':
      return Colors.blue;
    case 'Android':
      return Colors.green;
    case 'WhatsApp Chatbot':
      return Colors.teal;
    case 'InWard':
      return Colors.orange;
    case 'Toll Free':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

Widget tableCell(String text, {bool isHeader = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

void showMoreData(String desc) {
  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      height: Get.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          /// 🔹 Top Header with Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                /// ❌ Close Button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.close, size: 22, color: Colors.black),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CustomText(
                title: desc,
                fontSize: 14.sp,
                textAlign: TextAlign.start,
                maxLines: 500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String getRelativeDate(String dateString) {
  DateFormat format = DateFormat("dd-MM-yyyy hh:mm:ss a");
  DateTime dateTime = format.parse(dateString);

  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return "Today";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} weeks ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} months ago";
  } else {
    return "${(difference.inDays / 365).floor()} years ago";
  }
}

Future<void> openMap(String latlng) async {
  Uri url;

  if (Platform.isIOS) {
    /// Apple Maps
    url = Uri.parse('https://maps.apple.com/?q=$latlng');
  } else {
    /// Google Maps (Android)
    url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latlng&directionsmode=driving',
    );
  }

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Widget legend(String text, Color color) {
  return Row(
    spacing: 5,
    children: [
      Container(height: 10, width: 10, color: color),
      TranslatedText(title: text, fontSize: 12.sp, textAlign: TextAlign.start),
    ],
  );
}


Color hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 7 || hex.length == 6) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}