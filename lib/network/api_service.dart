import 'dart:io';
import 'package:bnpteam/network/all_url.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @POST(AllUrl.login)
  Future<dynamic> loginUser(
    @Part(name: "username") String userName,
    @Part(name: "password") String password,
  );

  @POST(AllUrl.getStatus)
  Future<dynamic> getStatus(@Part(name: "user_id") String userId);

  @POST(AllUrl.getComplaint)
  Future<dynamic> getComplaint(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
    @Part(name: "department[]") List<String> deptIds,
    @Part(name: "status") String status,
    @Part(name: "type") String source,
    @Part(name: "date") String date,
    @Part(name: "lang") String lang,
  );

  @POST(AllUrl.getComplaintDetails)
  Future<dynamic> getComplaintDetails(
    @Part(name: "user_id") String userId,
    @Part(name: "complaint_id") String complaintId,
  );

  @POST(AllUrl.getDepartment)
  Future<dynamic> getDepartment(@Part(name: "user_id") String userId);

  @POST(AllUrl.getWard)
  Future<dynamic> getWard(@Part(name: "user_id") String userId);

  @POST(AllUrl.addComplaintComment)
  @MultiPart()
  Future<dynamic> addComplaintComment(
    @Part(name: "user_id") String userId,
    @Part(name: "complaint_id") String complaintId,
    @Part(name: "status_id") String statusId,
    @Part(name: "field_officer_id") String officerId,
    @Part(name: "hod_id") String hodId,
    @Part(name: "department_id") String deptId,
    @Part(name: "description") String description, {
    @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  });

  @POST(AllUrl.getTask)
  Future<dynamic> getTask(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
    @Part(name: "status_id") String status,
    @Part(name: "date") String date,
  );

  @POST(AllUrl.getTaskDetails)
  Future<dynamic> getTaskDetails(
    @Part(name: "user_id") String userId,
    @Part(name: "task_id") String taskId,
  );

  @POST(AllUrl.getPriority)
  Future<dynamic> getPriority(@Part(name: "user_id") String userId);

  @POST(AllUrl.getTaskStatus)
  Future<dynamic> getTaskStatus(@Part(name: "user_id") String userId);

  @POST(AllUrl.getAssignee)
  Future<dynamic> getAssignee(@Part(name: "user_id") String userId);

  @POST(AllUrl.addTaskComment)
  @MultiPart()
  Future<dynamic> addTaskComment(
    @Part(name: "user_id") String userId,
    @Part(name: "task_id") String taskId,
    @Part(name: "status_id") String statusId,
    @Part(name: "description") String description, {
    @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  });

  @POST(AllUrl.addNewTask)
  @MultiPart()
  Future<dynamic> addNewTask(
    @Part(name: "user_id") String userId,
    @Part(name: "name") String name,
    @Part(name: "status_id") String statusId,
    @Part(name: "priority_id") String priorityId,
    @Part(name: "assignee_id") String assigneeId,
    @Part(name: "last_date") String lastDate,
    @Part(name: "description") String description, {
    @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  });

  @POST(AllUrl.helpAndSupport)
  Future<dynamic> helpAndSupport(@Part(name: "user_id") String userId);

  @POST(AllUrl.legalPage)
  Future<dynamic> legalPage(
    @Part(name: "user_id") String userId,
    @Part(name: "slug") String slug,
  );

  @POST(AllUrl.getProfile)
  Future<dynamic> getProfile(@Part(name: "user_id") String userId);

  @POST(AllUrl.updateProfile)
  @MultiPart()
  Future<dynamic> updateProfile(
    @Part(name: "user_id") String userId,
    @Part(name: "name") String name, {
    @Part(name: 'profile_image') File? profileImage,
  });

  @POST(AllUrl.deleteAccount)
  Future<dynamic> deleteAccount(@Part(name: "user_id") String userId);

  @POST(AllUrl.getPublicService)
  Future<dynamic> getPublicService(@Part(name: "user_id") String userId);

  @POST(AllUrl.getFiles)
  Future<dynamic> getFiles(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
    @Part(name: "status") String status,
    @Part(name: "date") String date,
    @Part(name: "public_service_id") String fileTypeId,
  );

  @POST(AllUrl.getFileDetails)
  Future<dynamic> getFileDetails(
    @Part(name: "user_id") String userId,
    @Part(name: "file_id") String fileId,
  );

  @POST(AllUrl.addFileComment)
  @MultiPart()
  Future<dynamic> addFileComment(
    @Part(name: "user_id") String userId,
    @Part(name: "file_id") String fileId,
    @Part(name: "status_id") String statusId,
    @Part(name: "description") String description, {
    @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  });

  @POST(AllUrl.getDashboard)
  Future<dynamic> getDashboard(@Part(name: "user_id") String userId);

  @POST(AllUrl.getKms)
  Future<dynamic> getKms(
    @Part(name: "user_id") String userId,
    @Part(name: "type") String type,
  );

  @POST(AllUrl.updateFirebaseToken)
  Future<dynamic> updateFirebaseToken(
    @Part(name: "user_id") String userId,
    @Part(name: "token") String token,
  );

  @POST(AllUrl.getNotification)
  Future<dynamic> getNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
  );

  @POST(AllUrl.readNotification)
  Future<dynamic> readNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "notification_id") String notificationId,
  );
}

//
// @GET("/comments")
// @Headers(<String, dynamic>{ //Static header
//   "Content-Type" : "application/json",
//   "Custom-Header" : "Your header"
// })
// Future<List<Comment>> getAllComments();

// @Path- To update the URL dynamically replacement block surrounded by { } must be annotated with @Path using the same string.
// @Body- Sends dart object as the request body.
// @Query- used to append the URL.
// @Headers- to pass the headers dynamically.
