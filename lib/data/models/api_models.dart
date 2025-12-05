import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

@JsonSerializable()
class RefreshTokenRequest {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  RefreshTokenRequest({required this.refreshToken});
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class RefreshTokenResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  RefreshTokenResponse({required this.accessToken, required this.refreshToken});
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@JsonSerializable()
class InitiateMultipartUploadRequest {
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_size_bytes')
  final int fileSizeBytes;
  InitiateMultipartUploadRequest({
    required this.fileName,
    required this.fileSizeBytes,
  });
  Map<String, dynamic> toJson() => _$InitiateMultipartUploadRequestToJson(this);
}

@JsonSerializable()
class InitiateMultipartUploadResponse {
  @JsonKey(name: 'upload_id')
  final String uploadId;
  @JsonKey(name: 'video_id')
  final String videoId;
  @JsonKey(name: 'recommended_part_size_mb')
  final int recommendedPartSizeMb;
  InitiateMultipartUploadResponse({
    required this.uploadId,
    required this.videoId,
    required this.recommendedPartSizeMb,
  });
  factory InitiateMultipartUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$InitiateMultipartUploadResponseFromJson(json);
}

@JsonSerializable()
class GetPartUploadURLsRequest {
  @JsonKey(name: 'video_id')
  final String videoId;
  @JsonKey(name: 'total_parts')
  final int totalParts;
  GetPartUploadURLsRequest({required this.videoId, required this.totalParts});
  Map<String, dynamic> toJson() => _$GetPartUploadURLsRequestToJson(this);
}

@JsonSerializable()
class GetPartUploadURLsResponse {
  @JsonKey(name: 'part_urls')
  final List<String> partUrls;
  GetPartUploadURLsResponse({required this.partUrls});
  factory GetPartUploadURLsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPartUploadURLsResponseFromJson(json);
}

@JsonSerializable()
class CompletedPart {
  @JsonKey(name: 'part_number')
  final int partNumber;
  @JsonKey(name: 'etag')
  final String etag;
  CompletedPart({required this.partNumber, required this.etag});
  factory CompletedPart.fromJson(Map<String, dynamic> json) =>
      _$CompletedPartFromJson(json);
  Map<String, dynamic> toJson() => _$CompletedPartToJson(this);
}

@JsonSerializable()
class CompleteMultipartUploadRequest {
  @JsonKey(name: 'video_id')
  final String videoId;
  final List<CompletedPart> parts;
  CompleteMultipartUploadRequest({required this.videoId, required this.parts});
  factory CompleteMultipartUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteMultipartUploadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteMultipartUploadRequestToJson(this);
}

@JsonSerializable()
class CompleteMultipartUploadResponse {
  final String message;
  @JsonKey(name: 'video_url')
  final String videoUrl;
  CompleteMultipartUploadResponse({
    required this.message,
    required this.videoUrl,
  });
  factory CompleteMultipartUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$CompleteMultipartUploadResponseFromJson(json);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class UpdateProfileRequest {
  @JsonKey(name: 'full_name')
  final String fullName;
  UpdateProfileRequest({required this.fullName});
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final UserInfo user;
  final List<OrganizationInfo>? organizations;
  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.organizations,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'invite_code', includeIfNull: false)
  final String? inviteCode;
  @JsonKey(name: 'organization_name', includeIfNull: false)
  final String? organizationName;
  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    this.inviteCode,
    this.organizationName,
  });
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'user_id')
  final String userId;
  final String message;
  RegisterResponse({required this.userId, required this.message});
  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

@JsonSerializable()
class LogoutRequest {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  LogoutRequest({required this.refreshToken});
  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);
}

@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'user_id')
  final String userId;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String role;
  @JsonKey(name: 'org_id')
  final String? orgId;
  UserInfo({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
    this.orgId,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class OrganizationInfo {
  @JsonKey(name: 'org_id')
  final String orgId;
  final String name;
  final String role;
  OrganizationInfo({
    required this.orgId,
    required this.name,
    required this.role,
  });
  factory OrganizationInfo.fromJson(Map<String, dynamic> json) =>
      _$OrganizationInfoFromJson(json);
}

@JsonSerializable()
class Video {
  @JsonKey(name: 'video_id')
  final String videoId;
  final String title;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  @JsonKey(name: 'uploaded_at')
  final int uploadedAt;
  Video({
    required this.videoId,
    required this.title,
    required this.fileName,
    this.durationSeconds,
    required this.uploadedAt,
  });
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}

@JsonSerializable()
class SearchVideosResponse {
  @JsonKey(name: 'total_count')
  final int totalCount;
  final List<Video> videos;
  SearchVideosResponse({required this.totalCount, required this.videos});
  factory SearchVideosResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchVideosResponseFromJson(json);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;
  ForgotPasswordRequest({required this.email});
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordResponse {
  final String message;
  ForgotPasswordResponse({required this.message});
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String code;
  @JsonKey(name: 'new_password')
  final String newPassword;
  ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordResponse {
  final String message;
  ResetPasswordResponse({required this.message});
  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}

@JsonSerializable()
class VerifyEmailRequest {
  final String email;
  final String code;
  VerifyEmailRequest({required this.email, required this.code});
  Map<String, dynamic> toJson() => _$VerifyEmailRequestToJson(this);
}

@JsonSerializable()
class VerifyEmailResponse {
  final String message;
  final bool success;
  VerifyEmailResponse({required this.message, required this.success});
  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailResponseFromJson(json);
}

@JsonSerializable()
class SwitchOrganizationRequest {
  @JsonKey(name: 'org_id')
  final String orgId;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  SwitchOrganizationRequest({required this.orgId, required this.refreshToken});
  Map<String, dynamic> toJson() => _$SwitchOrganizationRequestToJson(this);
}

@JsonSerializable()
class SwitchOrganizationResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  SwitchOrganizationResponse({
    required this.accessToken,
    required this.refreshToken,
  });
  factory SwitchOrganizationResponse.fromJson(Map<String, dynamic> json) =>
      _$SwitchOrganizationResponseFromJson(json);
}

@JsonSerializable()
class CreateOrganizationRequest {
  final String name;
  final String? description;
  CreateOrganizationRequest({required this.name, this.description});
  Map<String, dynamic> toJson() => _$CreateOrganizationRequestToJson(this);
}

@JsonSerializable()
class CreateOrganizationResponse {
  @JsonKey(name: 'org_id')
  final String orgId;
  final String message;
  CreateOrganizationResponse({required this.orgId, required this.message});
  factory CreateOrganizationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrganizationResponseFromJson(json);
}

@JsonSerializable()
class InvitationInfo {
  @JsonKey(name: 'invitation_id')
  final String invitationId;
  final String email;
  final String role;
  final String status;
  InvitationInfo({
    required this.invitationId,
    required this.email,
    required this.role,
    required this.status,
  });
  factory InvitationInfo.fromJson(Map<String, dynamic> json) =>
      _$InvitationInfoFromJson(json);
}

@JsonSerializable()
class ListInvitationsResponse {
  final List<InvitationInfo> invitations;
  final int total;
  ListInvitationsResponse({required this.invitations, required this.total});
  factory ListInvitationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListInvitationsResponseFromJson(json);
}

@JsonSerializable()
class AcceptInvitationRequest {
  @JsonKey(name: 'invite_code')
  final String inviteCode;
  AcceptInvitationRequest({required this.inviteCode});
  Map<String, dynamic> toJson() => _$AcceptInvitationRequestToJson(this);
}

@JsonSerializable()
class AcceptInvitationResponse {
  final String message;
  AcceptInvitationResponse({required this.message});
  factory AcceptInvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptInvitationResponseFromJson(json);
}

@JsonSerializable()
class InviteUserRequest {
  final String email;
  @JsonKey(name: 'org_id')
  final String orgId;
  final String role;
  InviteUserRequest({
    required this.email,
    required this.orgId,
    required this.role,
  });
  Map<String, dynamic> toJson() => _$InviteUserRequestToJson(this);
}

@JsonSerializable()
class InviteUserResponse {
  final String message;
  InviteUserResponse({required this.message});
  factory InviteUserResponse.fromJson(Map<String, dynamic> json) =>
      _$InviteUserResponseFromJson(json);
}

@JsonSerializable()
class ListMembersResponse {
  final List<UserInfo> members;
  final int total;
  ListMembersResponse({required this.members, required this.total});
  factory ListMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$ListMembersResponseFromJson(json);
}

@JsonSerializable()
class DeleteVideoResponse {
  final String message;
  DeleteVideoResponse({required this.message});
  factory DeleteVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteVideoResponseFromJson(json);
}

@JsonSerializable()
class PublishVideoRequest {
  @JsonKey(name: 'video_id')
  final String videoId;
  PublishVideoRequest({required this.videoId});
  Map<String, dynamic> toJson() => _$PublishVideoRequestToJson(this);
}

@JsonSerializable()
class PublishVideoResult {
  @JsonKey(name: 'public_url')
  final String publicUrl;
  PublishVideoResult({required this.publicUrl});
  factory PublishVideoResult.fromJson(Map<String, dynamic> json) =>
      _$PublishVideoResultFromJson(json);
}

@JsonSerializable()
class RevokeVideoRequest {
  @JsonKey(name: 'video_id')
  final String videoId;
  RevokeVideoRequest({required this.videoId});
  Map<String, dynamic> toJson() => _$RevokeVideoRequestToJson(this);
}

@JsonSerializable()
class RevokeVideoResponse {
  final String message;
  RevokeVideoResponse({required this.message});
  factory RevokeVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$RevokeVideoResponseFromJson(json);
}

@JsonSerializable()
class AuditLog {
  @JsonKey(name: 'action_result')
  final String actionResult;
  @JsonKey(name: 'action_type')
  final String actionType;
  final List<int>? details;
  final String id;
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  @JsonKey(name: 'org_id')
  final String orgId;
  final String timestamp;
  @JsonKey(name: 'user_agent')
  final String userAgent;
  @JsonKey(name: 'user_id')
  final String userId;

  AuditLog({
    required this.actionResult,
    required this.actionType,
    this.details,
    required this.id,
    required this.ipAddress,
    required this.orgId,
    required this.timestamp,
    required this.userAgent,
    required this.userId,
  });
  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}

@JsonSerializable()
class GetAuditLogsResponse {
  final int limit;
  final List<AuditLog> logs;
  final int offset;
  final int total;
  GetAuditLogsResponse({
    required this.limit,
    required this.logs,
    required this.offset,
    required this.total,
  });
  factory GetAuditLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAuditLogsResponseFromJson(json);
}

@JsonSerializable()
class UpdateMemberRoleRequest {
  @JsonKey(name: 'new_role')
  final String newRole;
  UpdateMemberRoleRequest({required this.newRole});
  Map<String, dynamic> toJson() => _$UpdateMemberRoleRequestToJson(this);
}

@JsonSerializable()
class UpdateMemberStatusRequest {
  final String status;
  UpdateMemberStatusRequest({required this.status});
  Map<String, dynamic> toJson() => _$UpdateMemberStatusRequestToJson(this);
}

@JsonSerializable()
class DownloadURLResult {
  @JsonKey(name: 'download_url')
  final String downloadUrl;
  @JsonKey(name: 'expires_at')
  final int expiresAt;
  DownloadURLResult({required this.downloadUrl, required this.expiresAt});
  factory DownloadURLResult.fromJson(Map<String, dynamic> json) =>
      _$DownloadURLResultFromJson(json);
}

@JsonSerializable()
class PublicVideoResponse {
  final String description;
  @JsonKey(name: 'duration_seconds')
  final int durationSeconds;
  @JsonKey(name: 'expires_at')
  final int expiresAt;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_size_bytes')
  final int fileSizeBytes;
  @JsonKey(name: 'stream_url')
  final String streamUrl;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  final String title;
  @JsonKey(name: 'uploaded_at')
  final int uploadedAt;
  @JsonKey(name: 'video_id')
  final String videoId;

  PublicVideoResponse({
    required this.description,
    required this.durationSeconds,
    required this.expiresAt,
    required this.fileName,
    required this.fileSizeBytes,
    required this.streamUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.uploadedAt,
    required this.videoId,
  });
  factory PublicVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicVideoResponseFromJson(json);
}
