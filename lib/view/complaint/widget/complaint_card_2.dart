import 'package:bnpteam/utils/exported_path.dart';

class ComplaintCard2 extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String status;
  final String statusColor;
  final String ticketNo;
  final String source;

  const ComplaintCard2({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.ticketNo,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        decoration: _buildCardDecoration(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 4.h),
                  _buildLocationSection(),
                  // SizedBox(height: 16.h),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12.r,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6.r,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(int.parse(statusColor)).withValues(alpha: 0.15),
                Color(int.parse(statusColor)).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.description_outlined,
            color: Color(int.parse(statusColor)),
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 4.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      title: title,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                    if (location.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedLocation01,
                            size: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TranslatedText(
                              title: location,
                              fontSize: 13.sp,
                              color: Colors.grey.shade700,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              StatusBadge(
                status: status,
                color: int.tryParse(statusColor) ?? 0xFF898989,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Complaint ID',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: CustomText(
              title: ticketNo,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Source',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: CustomText(
              title: source,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chevron_right,
            color: Colors.grey.shade700,
            size: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                HugeIcons.strokeRoundedCalendar03,
                size: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              title: date,
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        if (status == 'Pending' || status == 'Inprogress')
          LoadingAnimatedButton(
            height: 30,
            borderWidth: 5,
            color: Color(
              int.tryParse(statusColor) ?? 0xFF898989,
            ).withValues(alpha: 0.7),
            child: CustomText(
              title: getRelativeDate(date),
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
            onTap: () {},
          )
        // HighlightAnimatedText(
        //   text: getRelativeDate(date),
        //   color: Color(int.tryParse(statusColor) ?? 0xFF898989),
        // )
        else
          CustomText(
            title: getRelativeDate(date),
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
      ],
    );
  }
}
