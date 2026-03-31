import 'package:bnpteam/utils/exported_path.dart';

class CustomButton extends StatelessWidget {
  final RxBool isLoading;
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.text = 'Login',
    this.backgroundColor = Colors.blue,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: isLoading.isTrue ? null : onPressed,
          child:
              isLoading.isTrue
                  ? LoadingWidget(color: Colors.white)
                  : CustomText(
                    title: text,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
        ),
      ),
    );
  }
}
