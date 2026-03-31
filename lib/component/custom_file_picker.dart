import 'dart:io';
import 'package:bnpteam/component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class CustomFilePicker {
  static Future<File?> pickCamera() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 800,
      maxHeight: 800,
    );
    return photo != null ? File(photo.path) : null;
  }

  static Future<File?> pickGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 800,
      maxHeight: 800,
    );
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  static Future<void> showPickerBottomSheet({
    required Function(File file) onFilePicked,
  }) async {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      SafeArea(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Wrap(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedCamera02),
                title: CustomText(
                  title: 'Camera',
                  textAlign: TextAlign.start,
                  fontSize: 14.sp,
                ),
                onTap: () async {
                  Get.back();
                  File? file = await pickCamera();
                  if (file != null) onFilePicked(file);
                },
              ),
              Divider(height: 5, thickness: 0.5),
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedImage02),
                title: CustomText(
                  title: 'Gallery',
                  textAlign: TextAlign.start,
                  fontSize: 14.sp,
                ),
                onTap: () async {
                  Get.back();
                  File? file = await pickGallery();
                  if (file != null) onFilePicked(file);
                },
              ),
              Divider(height: 5, thickness: 0.5),
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedDocumentValidation),
                title: CustomText(
                  title: 'Document',
                  textAlign: TextAlign.start,
                  fontSize: 14.sp,
                ),
                onTap: () async {
                  Get.back();
                  File? file = await pickDocument();
                  if (file != null) onFilePicked(file);
                },
              ),
            ],
          ),
        ),
      ),
    );

    //
    // showModalBottomSheet(
    //   context: context,
    //   builder: (_) => SafeArea(
    //     child: Wrap(
    //       children: [
    //         ListTile(
    //           leading: Icon(Icons.camera_alt),
    //           title: Text('Camera'),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             File? file = await pickCamera(context);
    //             if (file != null) onFilePicked(file);
    //           },
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.photo),
    //           title: Text('Gallery'),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             File? file = await pickGallery(context);
    //             if (file != null) onFilePicked(file);
    //           },
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.insert_drive_file),
    //           title: Text('Document'),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             File? file = await pickDocument(context);
    //             if (file != null) onFilePicked(file);
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
