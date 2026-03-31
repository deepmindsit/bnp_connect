import 'package:bnpteam/utils/exported_path.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropdownSearchComponent extends StatelessWidget {
  final String? preselectedValue;
  final String hintText;
  final String searchHintText;
  final bool showSearchBox;
  final double dropdownHeight;
  final List items;
  final ValueChanged<dynamic> onChanged;
  final dynamic validator;

  const DropdownSearchComponent({
    super.key,
    this.preselectedValue,
    this.showSearchBox = true,
    required this.hintText,
    required this.searchHintText,
    required this.items,
    required this.onChanged,
    required this.dropdownHeight,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      selectedItem: preselectedValue,
      compareFn: (item1, item2) => item1 == item2,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: borderStyle(),
          focusedBorder: borderStyle(),
          enabledBorder: borderStyle(),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      validator: validator,
      items:
          (filter, infiniteScrollProps) =>
              items.map((item) => item['name'] as String).toList(),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
      ),
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        itemBuilder: (context, item, _, isSelected) {
          final value = items.firstWhere(
            (e) => e['name'] == item,
            orElse: () => {},
          );
          return ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(value['profile_image'] ?? ''),
            ),
            title: CustomText(
              title: value['name'] ?? '',
              fontSize: 14.sp,
              textAlign: TextAlign.start,
            ),
            subtitle: CustomText(
              title: value['role_name'] ?? '',
              fontSize: 12.sp,
              color: Colors.grey,
              textAlign: TextAlign.start,
            ),
          );
        },
        menuProps: const MenuProps(backgroundColor: Colors.white),
        constraints: BoxConstraints.tightFor(height: dropdownHeight),
        showSearchBox: showSearchBox,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            border: _borderStyle(),
            hintText: searchHintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    );
  }
}
