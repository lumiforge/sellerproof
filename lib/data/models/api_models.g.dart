// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
        RefreshTokenRequest instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

InitiateMultipartUploadRequest _$InitiateMultipartUploadRequestFromJson(
        Map<String, dynamic> json) =>
    InitiateMultipartUploadRequest(
      fileName: json['file_name'] as String,
      fileSizeBytes: (json['file_size_bytes'] as num).toInt(),
    );

Map<String, dynamic> _$InitiateMultipartUploadRequestToJson(
        InitiateMultipartUploadRequest instance) =>
    <String, dynamic>{
      'file_name': instance.fileName,
      'file_size_bytes': instance.fileSizeBytes,
    };

InitiateMultipartUploadResponse _$InitiateMultipartUploadResponseFromJson(
        Map<String, dynamic> json) =>
    InitiateMultipartUploadResponse(
      uploadId: json['upload_id'] as String,
      videoId: json['video_id'] as String,
      recommendedPartSizeMb: (json['recommended_part_size_mb'] as num).toInt(),
    );

Map<String, dynamic> _$InitiateMultipartUploadResponseToJson(
        InitiateMultipartUploadResponse instance) =>
    <String, dynamic>{
      'upload_id': instance.uploadId,
      'video_id': instance.videoId,
      'recommended_part_size_mb': instance.recommendedPartSizeMb,
    };

GetPartUploadURLsRequest _$GetPartUploadURLsRequestFromJson(
        Map<String, dynamic> json) =>
    GetPartUploadURLsRequest(
      videoId: json['video_id'] as String,
      totalParts: (json['total_parts'] as num).toInt(),
    );

Map<String, dynamic> _$GetPartUploadURLsRequestToJson(
        GetPartUploadURLsRequest instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
      'total_parts': instance.totalParts,
    };

GetPartUploadURLsResponse _$GetPartUploadURLsResponseFromJson(
        Map<String, dynamic> json) =>
    GetPartUploadURLsResponse(
      partUrls:
          (json['part_urls'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GetPartUploadURLsResponseToJson(
        GetPartUploadURLsResponse instance) =>
    <String, dynamic>{
      'part_urls': instance.partUrls,
    };

CompletedPart _$CompletedPartFromJson(Map<String, dynamic> json) =>
    CompletedPart(
      partNumber: (json['part_number'] as num).toInt(),
      etag: json['etag'] as String,
    );

Map<String, dynamic> _$CompletedPartToJson(CompletedPart instance) =>
    <String, dynamic>{
      'part_number': instance.partNumber,
      'etag': instance.etag,
    };

CompleteMultipartUploadRequest _$CompleteMultipartUploadRequestFromJson(
        Map<String, dynamic> json) =>
    CompleteMultipartUploadRequest(
      videoId: json['video_id'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => CompletedPart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompleteMultipartUploadRequestToJson(
        CompleteMultipartUploadRequest instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
      'parts': instance.parts,
    };

CompleteMultipartUploadResponse _$CompleteMultipartUploadResponseFromJson(
        Map<String, dynamic> json) =>
    CompleteMultipartUploadResponse(
      message: json['message'] as String,
      videoUrl: json['video_url'] as String,
    );

Map<String, dynamic> _$CompleteMultipartUploadResponseToJson(
        CompleteMultipartUploadResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'video_url': instance.videoUrl,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

UpdateProfileRequest _$UpdateProfileRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileRequest(
      fullName: json['full_name'] as String,
    );

Map<String, dynamic> _$UpdateProfileRequestToJson(
        UpdateProfileRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      organizations: (json['organizations'] as List<dynamic>?)
          ?.map((e) => OrganizationInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
      'organizations': instance.organizations,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['full_name'] as String,
      inviteCode: json['invite_code'] as String?,
      organizationName: json['organization_name'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'full_name': instance.fullName,
      'invite_code': instance.inviteCode,
      'organization_name': instance.organizationName,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      userId: json['user_id'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'message': instance.message,
    };

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) =>
    LogoutRequest(
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$LogoutRequestToJson(LogoutRequest instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      orgId: json['org_id'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'full_name': instance.fullName,
      'role': instance.role,
      'org_id': instance.orgId,
    };

OrganizationInfo _$OrganizationInfoFromJson(Map<String, dynamic> json) =>
    OrganizationInfo(
      orgId: json['org_id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$OrganizationInfoToJson(OrganizationInfo instance) =>
    <String, dynamic>{
      'org_id': instance.orgId,
      'name': instance.name,
      'role': instance.role,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      videoId: json['video_id'] as String,
      title: json['title'] as String,
      fileName: json['file_name'] as String,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      uploadedAt: (json['uploaded_at'] as num).toInt(),
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'video_id': instance.videoId,
      'title': instance.title,
      'file_name': instance.fileName,
      'duration_seconds': instance.durationSeconds,
      'uploaded_at': instance.uploadedAt,
    };

SearchVideosResponse _$SearchVideosResponseFromJson(
        Map<String, dynamic> json) =>
    SearchVideosResponse(
      totalCount: (json['total_count'] as num).toInt(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchVideosResponseToJson(
        SearchVideosResponse instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'videos': instance.videos,
    };

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$ForgotPasswordResponseToJson(
        ForgotPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequest(
      email: json['email'] as String,
      code: json['code'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
        ResetPasswordRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
      'new_password': instance.newPassword,
    };

ResetPasswordResponse _$ResetPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$ResetPasswordResponseToJson(
        ResetPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

VerifyEmailRequest _$VerifyEmailRequestFromJson(Map<String, dynamic> json) =>
    VerifyEmailRequest(
      email: json['email'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$VerifyEmailRequestToJson(VerifyEmailRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
    };

VerifyEmailResponse _$VerifyEmailResponseFromJson(Map<String, dynamic> json) =>
    VerifyEmailResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$VerifyEmailResponseToJson(
        VerifyEmailResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
    };

SwitchOrganizationRequest _$SwitchOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    SwitchOrganizationRequest(
      orgId: json['org_id'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$SwitchOrganizationRequestToJson(
        SwitchOrganizationRequest instance) =>
    <String, dynamic>{
      'org_id': instance.orgId,
      'refresh_token': instance.refreshToken,
    };

SwitchOrganizationResponse _$SwitchOrganizationResponseFromJson(
        Map<String, dynamic> json) =>
    SwitchOrganizationResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$SwitchOrganizationResponseToJson(
        SwitchOrganizationResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

CreateOrganizationRequest _$CreateOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateOrganizationRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateOrganizationRequestToJson(
        CreateOrganizationRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

CreateOrganizationResponse _$CreateOrganizationResponseFromJson(
        Map<String, dynamic> json) =>
    CreateOrganizationResponse(
      orgId: json['org_id'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CreateOrganizationResponseToJson(
        CreateOrganizationResponse instance) =>
    <String, dynamic>{
      'org_id': instance.orgId,
      'message': instance.message,
    };

InvitationInfo _$InvitationInfoFromJson(Map<String, dynamic> json) =>
    InvitationInfo(
      invitationId: json['invitation_id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvitationInfoToJson(InvitationInfo instance) =>
    <String, dynamic>{
      'invitation_id': instance.invitationId,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
    };

ListInvitationsResponse _$ListInvitationsResponseFromJson(
        Map<String, dynamic> json) =>
    ListInvitationsResponse(
      invitations: (json['invitations'] as List<dynamic>)
          .map((e) => InvitationInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ListInvitationsResponseToJson(
        ListInvitationsResponse instance) =>
    <String, dynamic>{
      'invitations': instance.invitations,
      'total': instance.total,
    };

AcceptInvitationRequest _$AcceptInvitationRequestFromJson(
        Map<String, dynamic> json) =>
    AcceptInvitationRequest(
      inviteCode: json['invite_code'] as String,
    );

Map<String, dynamic> _$AcceptInvitationRequestToJson(
        AcceptInvitationRequest instance) =>
    <String, dynamic>{
      'invite_code': instance.inviteCode,
    };

AcceptInvitationResponse _$AcceptInvitationResponseFromJson(
        Map<String, dynamic> json) =>
    AcceptInvitationResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$AcceptInvitationResponseToJson(
        AcceptInvitationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

InviteUserRequest _$InviteUserRequestFromJson(Map<String, dynamic> json) =>
    InviteUserRequest(
      email: json['email'] as String,
      orgId: json['org_id'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$InviteUserRequestToJson(InviteUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'org_id': instance.orgId,
      'role': instance.role,
    };

InviteUserResponse _$InviteUserResponseFromJson(Map<String, dynamic> json) =>
    InviteUserResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$InviteUserResponseToJson(InviteUserResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ListMembersResponse _$ListMembersResponseFromJson(Map<String, dynamic> json) =>
    ListMembersResponse(
      members: (json['members'] as List<dynamic>)
          .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ListMembersResponseToJson(
        ListMembersResponse instance) =>
    <String, dynamic>{
      'members': instance.members,
      'total': instance.total,
    };

DeleteVideoResponse _$DeleteVideoResponseFromJson(Map<String, dynamic> json) =>
    DeleteVideoResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteVideoResponseToJson(
        DeleteVideoResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

PublishVideoRequest _$PublishVideoRequestFromJson(Map<String, dynamic> json) =>
    PublishVideoRequest(
      videoId: json['video_id'] as String,
    );

Map<String, dynamic> _$PublishVideoRequestToJson(
        PublishVideoRequest instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
    };

PublishVideoResult _$PublishVideoResultFromJson(Map<String, dynamic> json) =>
    PublishVideoResult(
      publicUrl: json['public_url'] as String,
    );

Map<String, dynamic> _$PublishVideoResultToJson(PublishVideoResult instance) =>
    <String, dynamic>{
      'public_url': instance.publicUrl,
    };

RevokeVideoRequest _$RevokeVideoRequestFromJson(Map<String, dynamic> json) =>
    RevokeVideoRequest(
      videoId: json['video_id'] as String,
    );

Map<String, dynamic> _$RevokeVideoRequestToJson(RevokeVideoRequest instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
    };

RevokeVideoResponse _$RevokeVideoResponseFromJson(Map<String, dynamic> json) =>
    RevokeVideoResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$RevokeVideoResponseToJson(
        RevokeVideoResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
      actionResult: json['action_result'] as String,
      actionType: json['action_type'] as String,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      id: json['id'] as String,
      ipAddress: json['ip_address'] as String,
      orgId: json['org_id'] as String,
      timestamp: json['timestamp'] as String,
      userAgent: json['user_agent'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
      'action_result': instance.actionResult,
      'action_type': instance.actionType,
      'details': instance.details,
      'id': instance.id,
      'ip_address': instance.ipAddress,
      'org_id': instance.orgId,
      'timestamp': instance.timestamp,
      'user_agent': instance.userAgent,
      'user_id': instance.userId,
    };

GetAuditLogsResponse _$GetAuditLogsResponseFromJson(
        Map<String, dynamic> json) =>
    GetAuditLogsResponse(
      limit: (json['limit'] as num).toInt(),
      logs: (json['logs'] as List<dynamic>)
          .map((e) => AuditLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$GetAuditLogsResponseToJson(
        GetAuditLogsResponse instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'logs': instance.logs,
      'offset': instance.offset,
      'total': instance.total,
    };

UpdateMemberRoleRequest _$UpdateMemberRoleRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateMemberRoleRequest(
      newRole: json['new_role'] as String,
    );

Map<String, dynamic> _$UpdateMemberRoleRequestToJson(
        UpdateMemberRoleRequest instance) =>
    <String, dynamic>{
      'new_role': instance.newRole,
    };

UpdateMemberStatusRequest _$UpdateMemberStatusRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateMemberStatusRequest(
      status: json['status'] as String,
    );

Map<String, dynamic> _$UpdateMemberStatusRequestToJson(
        UpdateMemberStatusRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

DownloadURLResult _$DownloadURLResultFromJson(Map<String, dynamic> json) =>
    DownloadURLResult(
      downloadUrl: json['download_url'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
    );

Map<String, dynamic> _$DownloadURLResultToJson(DownloadURLResult instance) =>
    <String, dynamic>{
      'download_url': instance.downloadUrl,
      'expires_at': instance.expiresAt,
    };

PublicVideoResponse _$PublicVideoResponseFromJson(Map<String, dynamic> json) =>
    PublicVideoResponse(
      description: json['description'] as String,
      durationSeconds: (json['duration_seconds'] as num).toInt(),
      expiresAt: (json['expires_at'] as num).toInt(),
      fileName: json['file_name'] as String,
      fileSizeBytes: (json['file_size_bytes'] as num).toInt(),
      streamUrl: json['stream_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      title: json['title'] as String,
      uploadedAt: (json['uploaded_at'] as num).toInt(),
      videoId: json['video_id'] as String,
    );

Map<String, dynamic> _$PublicVideoResponseToJson(
        PublicVideoResponse instance) =>
    <String, dynamic>{
      'description': instance.description,
      'duration_seconds': instance.durationSeconds,
      'expires_at': instance.expiresAt,
      'file_name': instance.fileName,
      'file_size_bytes': instance.fileSizeBytes,
      'stream_url': instance.streamUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'title': instance.title,
      'uploaded_at': instance.uploadedAt,
      'video_id': instance.videoId,
    };
