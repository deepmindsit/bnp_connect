import 'package:bnpteam/utils/exported_path.dart';

class ComplaintCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String status;
  final String statusColor;
  final String ticketNo;

  const ComplaintCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.ticketNo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Container(
        decoration: _buildCardDecoration(),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(),
              SizedBox(height: 6.h),
              _buildLocationDateRow(),
              Divider(height: 16.h, thickness: 0.5.h),
              _buildTicketNumberRow(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 8.r,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TranslatedText(
            maxLines: 2,
            textAlign: TextAlign.start,
            title: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        StatusBadge(status: status, color: int.parse(statusColor)),
      ],
    );
  }

  Widget _buildLocationDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (location.isNotEmpty) _buildLocationText(),
        _buildDateRow(),
      ],
    );
  }

  Widget _buildLocationText() {
    return Expanded(
      child: TranslatedText(
        textAlign: TextAlign.start,
        maxLines: 2,
        title: location,
        color: Colors.grey,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Icon(
          HugeIcons.strokeRoundedCalendar03,
          size: 14.sp,
          color: Colors.grey,
        ),
        SizedBox(width: 4.w),
        CustomText(title: date, color: Colors.grey, fontSize: 12.sp),
      ],
    );
  }

  Widget _buildTicketNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title: "Ticket No: $ticketNo",
          color: Colors.grey,
          fontSize: 12.sp,
        ),
        Icon(Icons.chevron_right, color: Colors.grey, size: 20.sp),
      ],
    );
  }
}
