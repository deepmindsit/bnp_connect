import 'package:bnpteam/utils/exported_path.dart';

class MessageInputBox extends StatelessWidget {
  final TextEditingController remarkController;
  final String selectedStatus;
  final bool isSending;
  final List<String> statusOptions;
  final VoidCallback onAttachPressed;
  final VoidCallback onSendPressed;
  final ValueChanged<String?> onStatusChanged;

  const MessageInputBox({
    super.key,
    required this.remarkController,
    required this.selectedStatus,
    required this.statusOptions,
    this.isSending = false,
    required this.onAttachPressed,
    required this.onSendPressed,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 6, left: 10, right: 10),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: remarkController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        icon: Icon(Icons.arrow_drop_down, size: 14.sp),
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        dropdownColor: Colors.white,
                        items:
                            statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor: getStatusColor(status),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(title: status, fontSize: 12.sp),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: onStatusChanged,
                      ),
                    ),
                    GestureDetector(
                      onTap: onAttachPressed,
                      child: const Icon(Icons.attach_file),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: isSending ? Colors.grey : primaryColor,
            child: IconButton(
              icon:
                  isSending
                      ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 0.5,
                      )
                      : const Icon(Icons.send, color: Colors.white),
              onPressed: onSendPressed,
            ),
          ),
        ],
      ),
    );
  }
}
