import 'package:bnpteam/utils/exported_path.dart';

class AttachmentPreviewList extends StatelessWidget {
  final List attachments;
  final Function(String path) onDownload;

  const AttachmentPreviewList({
    super.key,
    required this.attachments,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.17.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final file = attachments[index];
          final name = file['name'] ?? 'Attachment';
          final path = file['path'];
          final extension = name.split('.').last.toLowerCase();
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
          ].contains(extension);

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              width: 0.45.sw,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      if (isImage)
                        WidgetZoom(
                          heroAnimationTag: 'tag $path',
                          zoomWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              path,
                              height: 80.w,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (_, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return SizedBox(
                                      height: 80.w,
                                      child: LoadingWidget(color: primaryColor),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  height: 80.w,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      // WidgetZoom(
                      //   heroAnimationTag: 'tag $path',
                      //   zoomWidget: ClipRRect(
                      //     borderRadius: BorderRadius.circular(12),
                      //     child: FadeInImage(
                      //       placeholder: AssetImage(Images.fevicon),
                      //       image: NetworkImage(path),
                      //       imageErrorBuilder: (context, error, stackTrace) {
                      //         return LoadingWidget(color: primaryColor);
                      //       },
                      //       height: 80.w,
                      //       width: double.infinity,
                      //       fit: BoxFit.contain,
                      //       fadeInDuration: const Duration(milliseconds: 300),
                      //     ),
                      //   ),
                      // )
                      else
                        Container(
                          height: 80.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: getFileTypeColor(extension),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            getIconForFile(name),
                            size: 36.w,
                            color: Colors.white,
                          ),
                        ),
                      Positioned(
                        bottom: 6.w,
                        right: 6.w,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: InkWell(
                            onTap: () => onDownload(path),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              child: Icon(
                                Icons.download,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    title: name.length > 20
                        ? '${name.substring(0, 20)}...'
                        : name,
                    fontSize: 13.sp,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
