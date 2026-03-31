import '../../../utils/exported_path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    controller.setPrevData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Obx(
          () => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6.r),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Stack(
                        children: [

                          // CircleAvatar(
                          //   backgroundColor: Colors.grey,
                          //   radius: 51.r,
                          //   child: CircleAvatar(
                          //     radius: 50.r,
                          //     backgroundColor: Colors.white,
                          //
                          //     // backgroundImage:
                          //     //     controller.profileImage.value != null
                          //     //         ? FileImage(
                          //     //           controller.profileImage.value!,
                          //     //         )
                          //     //         : AssetImage(Images.fevicon)
                          //     //             as ImageProvider,
                          //     child: ClipOval(
                          //       child: FadeInImage(
                          //         placeholder: AssetImage(Images.fevicon),
                          //         image:
                          //             controller.profileImage.value != null
                          //                 ? FileImage(
                          //                   controller.profileImage.value!,
                          //                 )
                          //                 : controller.userData['profile_image']
                          //                     .toString()
                          //                     .isNotEmpty
                          //                 ? NetworkImage(
                          //                   controller
                          //                       .userData['profile_image'],
                          //                 )
                          //                 : AssetImage(Images.fevicon)
                          //                     as ImageProvider,
                          //         imageErrorBuilder: (
                          //           context,
                          //           error,
                          //           stackTrace,
                          //         ) {
                          //           return Image.asset(
                          //             Images.fevicon,
                          //             width: 50.w,
                          //             height: 50.h,
                          //             fit: BoxFit.cover,
                          //           );
                          //         },
                          //         fit: BoxFit.cover,
                          //         fadeInDuration: const Duration(
                          //           milliseconds: 300,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 51.r,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: FadeInImage(
                                  placeholder: AssetImage(Images.fevicon),
                                  image: controller.profileImage.value != null
                                      ? FileImage(controller.profileImage.value!)
                                      : (controller.userData['profile_image'] != null &&
                                      controller.userData['profile_image'].toString().isNotEmpty)
                                      ? NetworkImage(controller.userData['profile_image'])
                                      : AssetImage(Images.fevicon),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      Images.fevicon,
                                      width: 100.w,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.edit,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller.nameController,
                      'Full Name',
                      true,
                      Icons.person,
                    ),
                    _buildTextField(
                      controller.emailController,
                      'Email',
                      false,
                      Icons.email,
                    ),
                    _buildTextField(
                      controller.phoneController,
                      'Phone Number',
                      false,
                      Icons.phone,
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      backgroundColor: primaryColor,
                      text: 'Save Changes',
                      isLoading: controller.isUpdateLoading,
                      onPressed: controller.updateProfile,
                    ),

                    TextButton.icon(
                      onPressed: () => Get.toNamed(Routes.deleteAccount),
                      icon: Icon(
                        HugeIcons.strokeRoundedDelete03,
                        color: Colors.black,
                        size: 22.sp,
                      ),
                      label: CustomText(
                        title: 'Delete Account',
                        fontSize: 14.sp,
                        color: primaryBlack,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.save, color: Colors.white, size: 20.sp),
                    //   label: Text(
                    //     'Save Changes',
                    //     style: TextStyle(fontSize: 16.sp),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: primaryColor,
                    //     foregroundColor: Colors.white,
                    //     surfaceTintColor: Colors.white,
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 32.w,
                    //       vertical: 12.h,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.r),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isEnabled,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextField(
        enabled: isEnabled,
        controller: controller,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20.sp),
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          filled: true,
          fillColor: const Color(0xFFF2F3F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
