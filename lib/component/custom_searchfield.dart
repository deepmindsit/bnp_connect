import 'package:bnpteam/utils/exported_path.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSuffixTap;
  final String hintText;

  const SearchField({
    super.key,
    required this.controller,
    this.onSuffixTap,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return buildTextField(
      prefixIcon: HugeIcon(
        size: 20,
        icon: HugeIcons.strokeRoundedSearch01,
        color: primaryGrey,
      ),
      controller: controller,
      suffixIcon: GestureDetector(
        onTap: onSuffixTap,
        child: HugeIcon(
          size: 20,
          icon: HugeIcons.strokeRoundedCancelCircle,
          color: primaryGrey,
        ),
      ),
      validator: (value) => null,
      hintText: hintText,
    );
  }
}
