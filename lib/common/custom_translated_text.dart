import 'package:bnpteam/utils/exported_path.dart';

class TranslatedText extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int maxLines;
  final TextAlign textAlign;

  const TranslatedText({
    required this.title,
    this.style,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final service = getIt<TranslateController>();
    // final service = Get.put(TranslateController());
    return Obx(() {
      // Create the future whenever lang.value changes
      return FutureBuilder<String>(
        key: ValueKey(
          service.lang.value + title,
        ), // force FutureBuilder to rebuild when lang changes
        future: service.translate(title, service.lang.value),
        builder: (context, snapshot) {
          final translated = snapshot.data ?? title;

          return CustomText(
            title: translated,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            maxLines: maxLines,
            textAlign: textAlign,
            style: style,
          );
        },
      );
    });
  }
}
