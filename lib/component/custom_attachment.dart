import 'package:bnpteam/utils/exported_path.dart';

class AttachmentList extends StatelessWidget {
  final List attachments;

  const AttachmentList({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      children: [
        sectionTitleWithIcon('📎 Attachments'),
        AttachmentPreviewList(
          attachments: attachments,
          onDownload: (path) => downloadFile(path),
        ),
      ],
    );
  }
}
