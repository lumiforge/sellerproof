import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sellerproof/data/models/api_models.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // auth
  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/refresh')
  Future<RefreshTokenResponse> refreshToken(
    @Body() RefreshTokenRequest request,
  );

  @POST('/auth/verify-email')
  Future<VerifyEmailResponse> verifyEmail(@Body() VerifyEmailRequest request);

  @POST('/auth/logout')
  Future<void> logout(@Body() LogoutRequest request);

  @GET('/auth/profile')
  Future<UserInfo> getProfile();

  @PUT('/auth/profile')
  Future<UserInfo> updateProfile(@Body() UpdateProfileRequest request);

  @POST('/auth/forgot-password')
  Future<ForgotPasswordResponse> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST('/auth/reset-password')
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );

  @POST('/auth/switch-organization')
  Future<SwitchOrganizationResponse> switchOrganization(
    @Body() SwitchOrganizationRequest request,
  );

  // Admin
  @GET('/admin/audit-logs')
  Future<GetAuditLogsResponse> getAuditLogs(
    @Query('user_id') String? userId,
    @Query('org_id') String? orgId,
    @Query('action_type') String? actionType,
    @Query('result') String? result,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  // Organization
  @POST('/organization/create')
  Future<CreateOrganizationResponse> createOrganization(
    @Body() CreateOrganizationRequest request,
  );

  @GET('/organization/invitations')
  Future<ListInvitationsResponse> getInvitations(@Query('org_id') String orgId);

  @POST('/organization/invite')
  Future<InviteUserResponse> inviteUser(@Body() InviteUserRequest request);

  @POST('/organization/invitations/accept')
  Future<AcceptInvitationResponse> acceptInvitation(
    @Body() AcceptInvitationRequest request,
  );

  @GET('/organization/members')
  Future<ListMembersResponse> getMembers(@Query('org_id') String orgId);

  @DELETE('/organization/members/{user_id}')
  Future<void> removeMember(
    @Path('user_id') String userId,
    @Query('org_id') String orgId,
  );
  @PUT('/organization/members/{user_id}/role')
  Future<void> updateMemberRole(
    @Path('user_id') String userId,
    @Body() UpdateMemberRoleRequest request,
  );
  @PUT('/organization/members/{user_id}/status')
  Future<void> updateMemberStatus(
    @Path('user_id') String userId,
    @Body() UpdateMemberStatusRequest request,
  );

  @DELETE('/organization/invitations/{invitation_id}')
  Future<void> cancelInvitation(@Path('invitation_id') String invitationId);

  // Video
  @POST('/video/upload/initiate')
  Future<InitiateMultipartUploadResponse> initiateUpload(
    @Body() InitiateMultipartUploadRequest request,
  );

  @POST('/video/upload/urls')
  Future<GetPartUploadURLsResponse> getUploadUrls(
    @Body() GetPartUploadURLsRequest request,
  );

  @POST('/video/upload/complete')
  Future<CompleteMultipartUploadResponse> completeUpload(
    @Body() CompleteMultipartUploadRequest request,
  );

  @GET('/video/search')
  Future<SearchVideosResponse> searchVideos(
    @Query('query') String? query,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  );

  @POST('/video/publish')
  Future<PublishVideoResult> publishVideo(@Body() PublishVideoRequest request);

  @DELETE('/video/{id}')
  Future<DeleteVideoResponse> deleteVideo(@Path('id') String id);

  @POST('/video/revoke')
  Future<RevokeVideoResponse> revokeVideo(@Body() RevokeVideoRequest request);

  @GET('/video')
  Future<Video> getVideo(@Query('video_id') String videoId);

  @GET('/video/download')
  Future<DownloadURLResult> downloadVideo(@Query('video_id') String videoId);

  @GET('/video/public')
  Future<PublicVideoResponse> getPublicVideo(@Query('token') String token);
}
