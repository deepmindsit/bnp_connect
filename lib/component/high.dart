import 'package:bnpteam/utils/exported_path.dart';

class HighlightAnimatedText extends StatefulWidget {
  final String text;
  final Color color;
  const HighlightAnimatedText({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  State<HighlightAnimatedText> createState() => _HighlightAnimatedTextState();
}

class _HighlightAnimatedTextState extends State<HighlightAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.color.withValues(alpha: 0.5),
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: colorAnimation.value!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomText(
            title: widget.text,
            fontSize: 12.sp,
            color: Colors.grey.shade800,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
