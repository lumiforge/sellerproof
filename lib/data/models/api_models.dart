// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

Empty emptyFromJson(String str) => Empty.fromJson(json.decode(str));

String emptyToJson(Empty data) => json.encode(data.toJson());

class Empty {
  String swagger;
  Info info;
  String host;
  String basePath;
  Paths paths;
  Definitions definitions;
  SecurityDefinitions securityDefinitions;

  Empty({
    required this.swagger,
    required this.info,
    required this.host,
    required this.basePath,
    required this.paths,
    required this.definitions,
    required this.securityDefinitions,
  });

  factory Empty.fromJson(Map<String, dynamic> json) => Empty(
    swagger: json["swagger"],
    info: Info.fromJson(json["info"]),
    host: json["host"],
    basePath: json["basePath"],
    paths: Paths.fromJson(json["paths"]),
    definitions: Definitions.fromJson(json["definitions"]),
    securityDefinitions: SecurityDefinitions.fromJson(
      json["securityDefinitions"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "swagger": swagger,
    "info": info.toJson(),
    "host": host,
    "basePath": basePath,
    "paths": paths.toJson(),
    "definitions": definitions.toJson(),
    "securityDefinitions": securityDefinitions.toJson(),
  };
}

class Definitions {
  ModelsAcceptInvitationRequest modelsAcceptInvitationRequest;
  ModelsAcceptInvitationResponse modelsAcceptInvitationResponse;
  ModelsAuditLog modelsAuditLog;
  ModelsCompleteMultipartUploadRequest modelsCompleteMultipartUploadRequest;
  ModelsCompleteMultipartUploadResponse modelsCompleteMultipartUploadResponse;
  ModelsCompletedPart modelsCompletedPart;
  ModelsCreateOrganizationRequest modelsCreateOrganizationRequest;
  ModelsCreateOrganizationResponse modelsCreateOrganizationResponse;
  ModelsResponse modelsDeleteVideoResponse;
  ModelsDownloadUrlResult modelsDownloadUrlResult;
  ModelsErrorResponse modelsErrorResponse;
  ModelsForgotPasswordRequest modelsForgotPasswordRequest;
  ModelsResponse modelsForgotPasswordResponse;
  ModelsGetAuditLogsResponse modelsGetAuditLogsResponse;
  ModelsGetPartUploadUrLsRequest modelsGetPartUploadUrLsRequest;
  ModelsGetPartUploadUrLsResponse modelsGetPartUploadUrLsResponse;
  ModelsInitiateMultipartUploadRequest modelsInitiateMultipartUploadRequest;
  ModelsInitiateMultipartUploadResponse modelsInitiateMultipartUploadResponse;
  ModelsInvitationInfo modelsInvitationInfo;
  ModelsInviteUserRequest modelsInviteUserRequest;
  ModelsInviteUserResponse modelsInviteUserResponse;
  ModelsListInvitationsResponse modelsListInvitationsResponse;
  ModelsListMembersResponse modelsListMembersResponse;
  ModelsLoginRequest modelsLoginRequest;
  ModelsLoginResponse modelsLoginResponse;
  ModelsRequest modelsLogoutRequest;
  ModelsResponse modelsLogoutResponse;
  ModelsMemberInfo modelsMemberInfo;
  ModelsOrganizationInfo modelsOrganizationInfo;
  ModelsPublicVideoResponse modelsPublicVideoResponse;
  ModelsVideoRequest modelsPublishVideoRequest;
  ModelsPublishVideoResult modelsPublishVideoResult;
  ModelsRequest modelsRefreshTokenRequest;
  ModelsNResponse modelsRefreshTokenResponse;
  ModelsRegisterRequest modelsRegisterRequest;
  ModelsRegisterResponse modelsRegisterResponse;
  ModelsResetPasswordRequest modelsResetPasswordRequest;
  ModelsResponse modelsResetPasswordResponse;
  ModelsVideoRequest modelsRevokeVideoRequest;
  ModelsRevokeVideoResponse modelsRevokeVideoResponse;
  ModelsSearchVideosResponse modelsSearchVideosResponse;
  ModelsSwitchOrganizationRequest modelsSwitchOrganizationRequest;
  ModelsNResponse modelsSwitchOrganizationResponse;
  ModelsUpdateMemberRoleRequest modelsUpdateMemberRoleRequest;
  ModelsUpdateMemberStatusRequest modelsUpdateMemberStatusRequest;
  ModelsUpdateProfileRequest modelsUpdateProfileRequest;
  ModelsUserInfo modelsUserInfo;
  ModelsVerifyEmailRequest modelsVerifyEmailRequest;
  ModelsVerifyEmailResponse modelsVerifyEmailResponse;
  ModelsVideo modelsVideo;

  Definitions({
    required this.modelsAcceptInvitationRequest,
    required this.modelsAcceptInvitationResponse,
    required this.modelsAuditLog,
    required this.modelsCompleteMultipartUploadRequest,
    required this.modelsCompleteMultipartUploadResponse,
    required this.modelsCompletedPart,
    required this.modelsCreateOrganizationRequest,
    required this.modelsCreateOrganizationResponse,
    required this.modelsDeleteVideoResponse,
    required this.modelsDownloadUrlResult,
    required this.modelsErrorResponse,
    required this.modelsForgotPasswordRequest,
    required this.modelsForgotPasswordResponse,
    required this.modelsGetAuditLogsResponse,
    required this.modelsGetPartUploadUrLsRequest,
    required this.modelsGetPartUploadUrLsResponse,
    required this.modelsInitiateMultipartUploadRequest,
    required this.modelsInitiateMultipartUploadResponse,
    required this.modelsInvitationInfo,
    required this.modelsInviteUserRequest,
    required this.modelsInviteUserResponse,
    required this.modelsListInvitationsResponse,
    required this.modelsListMembersResponse,
    required this.modelsLoginRequest,
    required this.modelsLoginResponse,
    required this.modelsLogoutRequest,
    required this.modelsLogoutResponse,
    required this.modelsMemberInfo,
    required this.modelsOrganizationInfo,
    required this.modelsPublicVideoResponse,
    required this.modelsPublishVideoRequest,
    required this.modelsPublishVideoResult,
    required this.modelsRefreshTokenRequest,
    required this.modelsRefreshTokenResponse,
    required this.modelsRegisterRequest,
    required this.modelsRegisterResponse,
    required this.modelsResetPasswordRequest,
    required this.modelsResetPasswordResponse,
    required this.modelsRevokeVideoRequest,
    required this.modelsRevokeVideoResponse,
    required this.modelsSearchVideosResponse,
    required this.modelsSwitchOrganizationRequest,
    required this.modelsSwitchOrganizationResponse,
    required this.modelsUpdateMemberRoleRequest,
    required this.modelsUpdateMemberStatusRequest,
    required this.modelsUpdateProfileRequest,
    required this.modelsUserInfo,
    required this.modelsVerifyEmailRequest,
    required this.modelsVerifyEmailResponse,
    required this.modelsVideo,
  });

  factory Definitions.fromJson(Map<String, dynamic> json) => Definitions(
    modelsAcceptInvitationRequest: ModelsAcceptInvitationRequest.fromJson(
      json["models.AcceptInvitationRequest"],
    ),
    modelsAcceptInvitationResponse: ModelsAcceptInvitationResponse.fromJson(
      json["models.AcceptInvitationResponse"],
    ),
    modelsAuditLog: ModelsAuditLog.fromJson(json["models.AuditLog"]),
    modelsCompleteMultipartUploadRequest:
        ModelsCompleteMultipartUploadRequest.fromJson(
          json["models.CompleteMultipartUploadRequest"],
        ),
    modelsCompleteMultipartUploadResponse:
        ModelsCompleteMultipartUploadResponse.fromJson(
          json["models.CompleteMultipartUploadResponse"],
        ),
    modelsCompletedPart: ModelsCompletedPart.fromJson(
      json["models.CompletedPart"],
    ),
    modelsCreateOrganizationRequest: ModelsCreateOrganizationRequest.fromJson(
      json["models.CreateOrganizationRequest"],
    ),
    modelsCreateOrganizationResponse: ModelsCreateOrganizationResponse.fromJson(
      json["models.CreateOrganizationResponse"],
    ),
    modelsDeleteVideoResponse: ModelsResponse.fromJson(
      json["models.DeleteVideoResponse"],
    ),
    modelsDownloadUrlResult: ModelsDownloadUrlResult.fromJson(
      json["models.DownloadURLResult"],
    ),
    modelsErrorResponse: ModelsErrorResponse.fromJson(
      json["models.ErrorResponse"],
    ),
    modelsForgotPasswordRequest: ModelsForgotPasswordRequest.fromJson(
      json["models.ForgotPasswordRequest"],
    ),
    modelsForgotPasswordResponse: ModelsResponse.fromJson(
      json["models.ForgotPasswordResponse"],
    ),
    modelsGetAuditLogsResponse: ModelsGetAuditLogsResponse.fromJson(
      json["models.GetAuditLogsResponse"],
    ),
    modelsGetPartUploadUrLsRequest: ModelsGetPartUploadUrLsRequest.fromJson(
      json["models.GetPartUploadURLsRequest"],
    ),
    modelsGetPartUploadUrLsResponse: ModelsGetPartUploadUrLsResponse.fromJson(
      json["models.GetPartUploadURLsResponse"],
    ),
    modelsInitiateMultipartUploadRequest:
        ModelsInitiateMultipartUploadRequest.fromJson(
          json["models.InitiateMultipartUploadRequest"],
        ),
    modelsInitiateMultipartUploadResponse:
        ModelsInitiateMultipartUploadResponse.fromJson(
          json["models.InitiateMultipartUploadResponse"],
        ),
    modelsInvitationInfo: ModelsInvitationInfo.fromJson(
      json["models.InvitationInfo"],
    ),
    modelsInviteUserRequest: ModelsInviteUserRequest.fromJson(
      json["models.InviteUserRequest"],
    ),
    modelsInviteUserResponse: ModelsInviteUserResponse.fromJson(
      json["models.InviteUserResponse"],
    ),
    modelsListInvitationsResponse: ModelsListInvitationsResponse.fromJson(
      json["models.ListInvitationsResponse"],
    ),
    modelsListMembersResponse: ModelsListMembersResponse.fromJson(
      json["models.ListMembersResponse"],
    ),
    modelsLoginRequest: ModelsLoginRequest.fromJson(
      json["models.LoginRequest"],
    ),
    modelsLoginResponse: ModelsLoginResponse.fromJson(
      json["models.LoginResponse"],
    ),
    modelsLogoutRequest: ModelsRequest.fromJson(json["models.LogoutRequest"]),
    modelsLogoutResponse: ModelsResponse.fromJson(
      json["models.LogoutResponse"],
    ),
    modelsMemberInfo: ModelsMemberInfo.fromJson(json["models.MemberInfo"]),
    modelsOrganizationInfo: ModelsOrganizationInfo.fromJson(
      json["models.OrganizationInfo"],
    ),
    modelsPublicVideoResponse: ModelsPublicVideoResponse.fromJson(
      json["models.PublicVideoResponse"],
    ),
    modelsPublishVideoRequest: ModelsVideoRequest.fromJson(
      json["models.PublishVideoRequest"],
    ),
    modelsPublishVideoResult: ModelsPublishVideoResult.fromJson(
      json["models.PublishVideoResult"],
    ),
    modelsRefreshTokenRequest: ModelsRequest.fromJson(
      json["models.RefreshTokenRequest"],
    ),
    modelsRefreshTokenResponse: ModelsNResponse.fromJson(
      json["models.RefreshTokenResponse"],
    ),
    modelsRegisterRequest: ModelsRegisterRequest.fromJson(
      json["models.RegisterRequest"],
    ),
    modelsRegisterResponse: ModelsRegisterResponse.fromJson(
      json["models.RegisterResponse"],
    ),
    modelsResetPasswordRequest: ModelsResetPasswordRequest.fromJson(
      json["models.ResetPasswordRequest"],
    ),
    modelsResetPasswordResponse: ModelsResponse.fromJson(
      json["models.ResetPasswordResponse"],
    ),
    modelsRevokeVideoRequest: ModelsVideoRequest.fromJson(
      json["models.RevokeVideoRequest"],
    ),
    modelsRevokeVideoResponse: ModelsRevokeVideoResponse.fromJson(
      json["models.RevokeVideoResponse"],
    ),
    modelsSearchVideosResponse: ModelsSearchVideosResponse.fromJson(
      json["models.SearchVideosResponse"],
    ),
    modelsSwitchOrganizationRequest: ModelsSwitchOrganizationRequest.fromJson(
      json["models.SwitchOrganizationRequest"],
    ),
    modelsSwitchOrganizationResponse: ModelsNResponse.fromJson(
      json["models.SwitchOrganizationResponse"],
    ),
    modelsUpdateMemberRoleRequest: ModelsUpdateMemberRoleRequest.fromJson(
      json["models.UpdateMemberRoleRequest"],
    ),
    modelsUpdateMemberStatusRequest: ModelsUpdateMemberStatusRequest.fromJson(
      json["models.UpdateMemberStatusRequest"],
    ),
    modelsUpdateProfileRequest: ModelsUpdateProfileRequest.fromJson(
      json["models.UpdateProfileRequest"],
    ),
    modelsUserInfo: ModelsUserInfo.fromJson(json["models.UserInfo"]),
    modelsVerifyEmailRequest: ModelsVerifyEmailRequest.fromJson(
      json["models.VerifyEmailRequest"],
    ),
    modelsVerifyEmailResponse: ModelsVerifyEmailResponse.fromJson(
      json["models.VerifyEmailResponse"],
    ),
    modelsVideo: ModelsVideo.fromJson(json["models.Video"]),
  );

  Map<String, dynamic> toJson() => {
    "models.AcceptInvitationRequest": modelsAcceptInvitationRequest.toJson(),
    "models.AcceptInvitationResponse": modelsAcceptInvitationResponse.toJson(),
    "models.AuditLog": modelsAuditLog.toJson(),
    "models.CompleteMultipartUploadRequest":
        modelsCompleteMultipartUploadRequest.toJson(),
    "models.CompleteMultipartUploadResponse":
        modelsCompleteMultipartUploadResponse.toJson(),
    "models.CompletedPart": modelsCompletedPart.toJson(),
    "models.CreateOrganizationRequest": modelsCreateOrganizationRequest
        .toJson(),
    "models.CreateOrganizationResponse": modelsCreateOrganizationResponse
        .toJson(),
    "models.DeleteVideoResponse": modelsDeleteVideoResponse.toJson(),
    "models.DownloadURLResult": modelsDownloadUrlResult.toJson(),
    "models.ErrorResponse": modelsErrorResponse.toJson(),
    "models.ForgotPasswordRequest": modelsForgotPasswordRequest.toJson(),
    "models.ForgotPasswordResponse": modelsForgotPasswordResponse.toJson(),
    "models.GetAuditLogsResponse": modelsGetAuditLogsResponse.toJson(),
    "models.GetPartUploadURLsRequest": modelsGetPartUploadUrLsRequest.toJson(),
    "models.GetPartUploadURLsResponse": modelsGetPartUploadUrLsResponse
        .toJson(),
    "models.InitiateMultipartUploadRequest":
        modelsInitiateMultipartUploadRequest.toJson(),
    "models.InitiateMultipartUploadResponse":
        modelsInitiateMultipartUploadResponse.toJson(),
    "models.InvitationInfo": modelsInvitationInfo.toJson(),
    "models.InviteUserRequest": modelsInviteUserRequest.toJson(),
    "models.InviteUserResponse": modelsInviteUserResponse.toJson(),
    "models.ListInvitationsResponse": modelsListInvitationsResponse.toJson(),
    "models.ListMembersResponse": modelsListMembersResponse.toJson(),
    "models.LoginRequest": modelsLoginRequest.toJson(),
    "models.LoginResponse": modelsLoginResponse.toJson(),
    "models.LogoutRequest": modelsLogoutRequest.toJson(),
    "models.LogoutResponse": modelsLogoutResponse.toJson(),
    "models.MemberInfo": modelsMemberInfo.toJson(),
    "models.OrganizationInfo": modelsOrganizationInfo.toJson(),
    "models.PublicVideoResponse": modelsPublicVideoResponse.toJson(),
    "models.PublishVideoRequest": modelsPublishVideoRequest.toJson(),
    "models.PublishVideoResult": modelsPublishVideoResult.toJson(),
    "models.RefreshTokenRequest": modelsRefreshTokenRequest.toJson(),
    "models.RefreshTokenResponse": modelsRefreshTokenResponse.toJson(),
    "models.RegisterRequest": modelsRegisterRequest.toJson(),
    "models.RegisterResponse": modelsRegisterResponse.toJson(),
    "models.ResetPasswordRequest": modelsResetPasswordRequest.toJson(),
    "models.ResetPasswordResponse": modelsResetPasswordResponse.toJson(),
    "models.RevokeVideoRequest": modelsRevokeVideoRequest.toJson(),
    "models.RevokeVideoResponse": modelsRevokeVideoResponse.toJson(),
    "models.SearchVideosResponse": modelsSearchVideosResponse.toJson(),
    "models.SwitchOrganizationRequest": modelsSwitchOrganizationRequest
        .toJson(),
    "models.SwitchOrganizationResponse": modelsSwitchOrganizationResponse
        .toJson(),
    "models.UpdateMemberRoleRequest": modelsUpdateMemberRoleRequest.toJson(),
    "models.UpdateMemberStatusRequest": modelsUpdateMemberStatusRequest
        .toJson(),
    "models.UpdateProfileRequest": modelsUpdateProfileRequest.toJson(),
    "models.UserInfo": modelsUserInfo.toJson(),
    "models.VerifyEmailRequest": modelsVerifyEmailRequest.toJson(),
    "models.VerifyEmailResponse": modelsVerifyEmailResponse.toJson(),
    "models.Video": modelsVideo.toJson(),
  };
}

class ModelsAcceptInvitationRequest {
  String description;
  String type;
  ModelsAcceptInvitationRequestProperties properties;

  ModelsAcceptInvitationRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsAcceptInvitationRequest.fromJson(Map<String, dynamic> json) =>
      ModelsAcceptInvitationRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsAcceptInvitationRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsAcceptInvitationRequestProperties {
  InviteCode inviteCode;

  ModelsAcceptInvitationRequestProperties({required this.inviteCode});

  factory ModelsAcceptInvitationRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsAcceptInvitationRequestProperties(
    inviteCode: InviteCode.fromJson(json["invite_code"]),
  );

  Map<String, dynamic> toJson() => {"invite_code": inviteCode.toJson()};
}

class InviteCode {
  Type type;

  InviteCode({required this.type});

  factory InviteCode.fromJson(Map<String, dynamic> json) =>
      InviteCode(type: typeValues.map[json["type"]]!);

  Map<String, dynamic> toJson() => {"type": typeValues.reverse[type]};
}

enum Type { BOOLEAN, INTEGER, STRING }

final typeValues = EnumValues({
  "boolean": Type.BOOLEAN,
  "integer": Type.INTEGER,
  "string": Type.STRING,
});

class ModelsAcceptInvitationResponse {
  String description;
  String type;
  ModelsAcceptInvitationResponseProperties properties;

  ModelsAcceptInvitationResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsAcceptInvitationResponse.fromJson(Map<String, dynamic> json) =>
      ModelsAcceptInvitationResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsAcceptInvitationResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsAcceptInvitationResponseProperties {
  InviteCode accessToken;
  InviteCode expiresAt;
  InviteCode membershipId;
  InviteCode message;
  InviteCode orgId;
  InviteCode refreshToken;
  InviteCode role;

  ModelsAcceptInvitationResponseProperties({
    required this.accessToken,
    required this.expiresAt,
    required this.membershipId,
    required this.message,
    required this.orgId,
    required this.refreshToken,
    required this.role,
  });

  factory ModelsAcceptInvitationResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsAcceptInvitationResponseProperties(
    accessToken: InviteCode.fromJson(json["access_token"]),
    expiresAt: InviteCode.fromJson(json["expires_at"]),
    membershipId: InviteCode.fromJson(json["membership_id"]),
    message: InviteCode.fromJson(json["message"]),
    orgId: InviteCode.fromJson(json["org_id"]),
    refreshToken: InviteCode.fromJson(json["refresh_token"]),
    role: InviteCode.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken.toJson(),
    "expires_at": expiresAt.toJson(),
    "membership_id": membershipId.toJson(),
    "message": message.toJson(),
    "org_id": orgId.toJson(),
    "refresh_token": refreshToken.toJson(),
    "role": role.toJson(),
  };
}

class ModelsAuditLog {
  String description;
  String type;
  ModelsAuditLogProperties properties;

  ModelsAuditLog({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsAuditLog.fromJson(Map<String, dynamic> json) => ModelsAuditLog(
    description: json["description"],
    type: json["type"],
    properties: ModelsAuditLogProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsAuditLogProperties {
  InviteCode actionResult;
  InviteCode actionType;
  Details details;
  InviteCode id;
  InviteCode ipAddress;
  InviteCode orgId;
  InviteCode timestamp;
  InviteCode userAgent;
  InviteCode userId;

  ModelsAuditLogProperties({
    required this.actionResult,
    required this.actionType,
    required this.details,
    required this.id,
    required this.ipAddress,
    required this.orgId,
    required this.timestamp,
    required this.userAgent,
    required this.userId,
  });

  factory ModelsAuditLogProperties.fromJson(Map<String, dynamic> json) =>
      ModelsAuditLogProperties(
        actionResult: InviteCode.fromJson(json["action_result"]),
        actionType: InviteCode.fromJson(json["action_type"]),
        details: Details.fromJson(json["details"]),
        id: InviteCode.fromJson(json["id"]),
        ipAddress: InviteCode.fromJson(json["ip_address"]),
        orgId: InviteCode.fromJson(json["org_id"]),
        timestamp: InviteCode.fromJson(json["timestamp"]),
        userAgent: InviteCode.fromJson(json["user_agent"]),
        userId: InviteCode.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
    "action_result": actionResult.toJson(),
    "action_type": actionType.toJson(),
    "details": details.toJson(),
    "id": id.toJson(),
    "ip_address": ipAddress.toJson(),
    "org_id": orgId.toJson(),
    "timestamp": timestamp.toJson(),
    "user_agent": userAgent.toJson(),
    "user_id": userId.toJson(),
  };
}

class Details {
  String type;
  InviteCode items;

  Details({required this.type, required this.items});

  factory Details.fromJson(Map<String, dynamic> json) =>
      Details(type: json["type"], items: InviteCode.fromJson(json["items"]));

  Map<String, dynamic> toJson() => {"type": type, "items": items.toJson()};
}

class ModelsCompleteMultipartUploadRequest {
  String description;
  String type;
  ModelsCompleteMultipartUploadRequestProperties properties;

  ModelsCompleteMultipartUploadRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsCompleteMultipartUploadRequest.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCompleteMultipartUploadRequest(
    description: json["description"],
    type: json["type"],
    properties: ModelsCompleteMultipartUploadRequestProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsCompleteMultipartUploadRequestProperties {
  Parts parts;
  InviteCode videoId;

  ModelsCompleteMultipartUploadRequestProperties({
    required this.parts,
    required this.videoId,
  });

  factory ModelsCompleteMultipartUploadRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCompleteMultipartUploadRequestProperties(
    parts: Parts.fromJson(json["parts"]),
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {
    "parts": parts.toJson(),
    "video_id": videoId.toJson(),
  };
}

class Parts {
  String type;
  User items;

  Parts({required this.type, required this.items});

  factory Parts.fromJson(Map<String, dynamic> json) =>
      Parts(type: json["type"], items: User.fromJson(json["items"]));

  Map<String, dynamic> toJson() => {"type": type, "items": items.toJson()};
}

class User {
  String ref;

  User({required this.ref});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(ref: json["\u0024ref"]);

  Map<String, dynamic> toJson() => {"\u0024ref": ref};
}

class ModelsCompleteMultipartUploadResponse {
  String description;
  String type;
  ModelsCompleteMultipartUploadResponseProperties properties;

  ModelsCompleteMultipartUploadResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsCompleteMultipartUploadResponse.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCompleteMultipartUploadResponse(
    description: json["description"],
    type: json["type"],
    properties: ModelsCompleteMultipartUploadResponseProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsCompleteMultipartUploadResponseProperties {
  InviteCode message;
  InviteCode videoUrl;

  ModelsCompleteMultipartUploadResponseProperties({
    required this.message,
    required this.videoUrl,
  });

  factory ModelsCompleteMultipartUploadResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCompleteMultipartUploadResponseProperties(
    message: InviteCode.fromJson(json["message"]),
    videoUrl: InviteCode.fromJson(json["video_url"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "video_url": videoUrl.toJson(),
  };
}

class ModelsCompletedPart {
  String description;
  String type;
  ModelsCompletedPartProperties properties;

  ModelsCompletedPart({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsCompletedPart.fromJson(Map<String, dynamic> json) =>
      ModelsCompletedPart(
        description: json["description"],
        type: json["type"],
        properties: ModelsCompletedPartProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsCompletedPartProperties {
  InviteCode etag;
  InviteCode partNumber;

  ModelsCompletedPartProperties({required this.etag, required this.partNumber});

  factory ModelsCompletedPartProperties.fromJson(Map<String, dynamic> json) =>
      ModelsCompletedPartProperties(
        etag: InviteCode.fromJson(json["etag"]),
        partNumber: InviteCode.fromJson(json["part_number"]),
      );

  Map<String, dynamic> toJson() => {
    "etag": etag.toJson(),
    "part_number": partNumber.toJson(),
  };
}

class ModelsCreateOrganizationRequest {
  String description;
  String type;
  ModelsCreateOrganizationRequestProperties properties;

  ModelsCreateOrganizationRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsCreateOrganizationRequest.fromJson(Map<String, dynamic> json) =>
      ModelsCreateOrganizationRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsCreateOrganizationRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsCreateOrganizationRequestProperties {
  InviteCode description;
  InviteCode name;

  ModelsCreateOrganizationRequestProperties({
    required this.description,
    required this.name,
  });

  factory ModelsCreateOrganizationRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCreateOrganizationRequestProperties(
    description: InviteCode.fromJson(json["description"]),
    name: InviteCode.fromJson(json["name"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description.toJson(),
    "name": name.toJson(),
  };
}

class ModelsCreateOrganizationResponse {
  String description;
  String type;
  ModelsCreateOrganizationResponseProperties properties;

  ModelsCreateOrganizationResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsCreateOrganizationResponse.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCreateOrganizationResponse(
    description: json["description"],
    type: json["type"],
    properties: ModelsCreateOrganizationResponseProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsCreateOrganizationResponseProperties {
  InviteCode createdAt;
  InviteCode description;
  InviteCode message;
  InviteCode name;
  InviteCode orgId;

  ModelsCreateOrganizationResponseProperties({
    required this.createdAt,
    required this.description,
    required this.message,
    required this.name,
    required this.orgId,
  });

  factory ModelsCreateOrganizationResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsCreateOrganizationResponseProperties(
    createdAt: InviteCode.fromJson(json["created_at"]),
    description: InviteCode.fromJson(json["description"]),
    message: InviteCode.fromJson(json["message"]),
    name: InviteCode.fromJson(json["name"]),
    orgId: InviteCode.fromJson(json["org_id"]),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toJson(),
    "description": description.toJson(),
    "message": message.toJson(),
    "name": name.toJson(),
    "org_id": orgId.toJson(),
  };
}

class ModelsResponse {
  String description;
  String type;
  ModelsDeleteVideoResponseProperties properties;

  ModelsResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsResponse.fromJson(Map<String, dynamic> json) => ModelsResponse(
    description: json["description"],
    type: json["type"],
    properties: ModelsDeleteVideoResponseProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsDeleteVideoResponseProperties {
  InviteCode message;

  ModelsDeleteVideoResponseProperties({required this.message});

  factory ModelsDeleteVideoResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsDeleteVideoResponseProperties(
    message: InviteCode.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class ModelsDownloadUrlResult {
  String description;
  String type;
  ModelsDownloadUrlResultProperties properties;

  ModelsDownloadUrlResult({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsDownloadUrlResult.fromJson(Map<String, dynamic> json) =>
      ModelsDownloadUrlResult(
        description: json["description"],
        type: json["type"],
        properties: ModelsDownloadUrlResultProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsDownloadUrlResultProperties {
  InviteCode downloadUrl;
  InviteCode expiresAt;

  ModelsDownloadUrlResultProperties({
    required this.downloadUrl,
    required this.expiresAt,
  });

  factory ModelsDownloadUrlResultProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsDownloadUrlResultProperties(
    downloadUrl: InviteCode.fromJson(json["download_url"]),
    expiresAt: InviteCode.fromJson(json["expires_at"]),
  );

  Map<String, dynamic> toJson() => {
    "download_url": downloadUrl.toJson(),
    "expires_at": expiresAt.toJson(),
  };
}

class ModelsErrorResponse {
  String description;
  String type;
  ModelsErrorResponseProperties properties;

  ModelsErrorResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsErrorResponse.fromJson(Map<String, dynamic> json) =>
      ModelsErrorResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsErrorResponseProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsErrorResponseProperties {
  InviteCode code;
  InviteCode error;
  InviteCode message;

  ModelsErrorResponseProperties({
    required this.code,
    required this.error,
    required this.message,
  });

  factory ModelsErrorResponseProperties.fromJson(Map<String, dynamic> json) =>
      ModelsErrorResponseProperties(
        code: InviteCode.fromJson(json["code"]),
        error: InviteCode.fromJson(json["error"]),
        message: InviteCode.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
    "code": code.toJson(),
    "error": error.toJson(),
    "message": message.toJson(),
  };
}

class ModelsForgotPasswordRequest {
  String description;
  String type;
  ModelsForgotPasswordRequestProperties properties;

  ModelsForgotPasswordRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      ModelsForgotPasswordRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsForgotPasswordRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsForgotPasswordRequestProperties {
  InviteCode email;

  ModelsForgotPasswordRequestProperties({required this.email});

  factory ModelsForgotPasswordRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsForgotPasswordRequestProperties(
    email: InviteCode.fromJson(json["email"]),
  );

  Map<String, dynamic> toJson() => {"email": email.toJson()};
}

class ModelsGetAuditLogsResponse {
  String description;
  String type;
  ModelsGetAuditLogsResponseProperties properties;

  ModelsGetAuditLogsResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsGetAuditLogsResponse.fromJson(Map<String, dynamic> json) =>
      ModelsGetAuditLogsResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsGetAuditLogsResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsGetAuditLogsResponseProperties {
  InviteCode limit;
  Parts logs;
  InviteCode offset;
  InviteCode total;

  ModelsGetAuditLogsResponseProperties({
    required this.limit,
    required this.logs,
    required this.offset,
    required this.total,
  });

  factory ModelsGetAuditLogsResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsGetAuditLogsResponseProperties(
    limit: InviteCode.fromJson(json["limit"]),
    logs: Parts.fromJson(json["logs"]),
    offset: InviteCode.fromJson(json["offset"]),
    total: InviteCode.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "limit": limit.toJson(),
    "logs": logs.toJson(),
    "offset": offset.toJson(),
    "total": total.toJson(),
  };
}

class ModelsGetPartUploadUrLsRequest {
  String description;
  String type;
  ModelsGetPartUploadUrLsRequestProperties properties;

  ModelsGetPartUploadUrLsRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsGetPartUploadUrLsRequest.fromJson(Map<String, dynamic> json) =>
      ModelsGetPartUploadUrLsRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsGetPartUploadUrLsRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsGetPartUploadUrLsRequestProperties {
  InviteCode totalParts;
  InviteCode videoId;

  ModelsGetPartUploadUrLsRequestProperties({
    required this.totalParts,
    required this.videoId,
  });

  factory ModelsGetPartUploadUrLsRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsGetPartUploadUrLsRequestProperties(
    totalParts: InviteCode.fromJson(json["total_parts"]),
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {
    "total_parts": totalParts.toJson(),
    "video_id": videoId.toJson(),
  };
}

class ModelsGetPartUploadUrLsResponse {
  String description;
  String type;
  ModelsGetPartUploadUrLsResponseProperties properties;

  ModelsGetPartUploadUrLsResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsGetPartUploadUrLsResponse.fromJson(Map<String, dynamic> json) =>
      ModelsGetPartUploadUrLsResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsGetPartUploadUrLsResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsGetPartUploadUrLsResponseProperties {
  InviteCode expiresAt;
  Details partUrls;

  ModelsGetPartUploadUrLsResponseProperties({
    required this.expiresAt,
    required this.partUrls,
  });

  factory ModelsGetPartUploadUrLsResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsGetPartUploadUrLsResponseProperties(
    expiresAt: InviteCode.fromJson(json["expires_at"]),
    partUrls: Details.fromJson(json["part_urls"]),
  );

  Map<String, dynamic> toJson() => {
    "expires_at": expiresAt.toJson(),
    "part_urls": partUrls.toJson(),
  };
}

class ModelsInitiateMultipartUploadRequest {
  String description;
  String type;
  ModelsInitiateMultipartUploadRequestProperties properties;

  ModelsInitiateMultipartUploadRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsInitiateMultipartUploadRequest.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInitiateMultipartUploadRequest(
    description: json["description"],
    type: json["type"],
    properties: ModelsInitiateMultipartUploadRequestProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsInitiateMultipartUploadRequestProperties {
  InviteCode durationSeconds;
  InviteCode fileName;
  InviteCode fileSizeBytes;
  InviteCode title;

  ModelsInitiateMultipartUploadRequestProperties({
    required this.durationSeconds,
    required this.fileName,
    required this.fileSizeBytes,
    required this.title,
  });

  factory ModelsInitiateMultipartUploadRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInitiateMultipartUploadRequestProperties(
    durationSeconds: InviteCode.fromJson(json["duration_seconds"]),
    fileName: InviteCode.fromJson(json["file_name"]),
    fileSizeBytes: InviteCode.fromJson(json["file_size_bytes"]),
    title: InviteCode.fromJson(json["title"]),
  );

  Map<String, dynamic> toJson() => {
    "duration_seconds": durationSeconds.toJson(),
    "file_name": fileName.toJson(),
    "file_size_bytes": fileSizeBytes.toJson(),
    "title": title.toJson(),
  };
}

class ModelsInitiateMultipartUploadResponse {
  String description;
  String type;
  ModelsInitiateMultipartUploadResponseProperties properties;

  ModelsInitiateMultipartUploadResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsInitiateMultipartUploadResponse.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInitiateMultipartUploadResponse(
    description: json["description"],
    type: json["type"],
    properties: ModelsInitiateMultipartUploadResponseProperties.fromJson(
      json["properties"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsInitiateMultipartUploadResponseProperties {
  InviteCode recommendedPartSizeMb;
  InviteCode uploadId;
  InviteCode videoId;

  ModelsInitiateMultipartUploadResponseProperties({
    required this.recommendedPartSizeMb,
    required this.uploadId,
    required this.videoId,
  });

  factory ModelsInitiateMultipartUploadResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInitiateMultipartUploadResponseProperties(
    recommendedPartSizeMb: InviteCode.fromJson(
      json["recommended_part_size_mb"],
    ),
    uploadId: InviteCode.fromJson(json["upload_id"]),
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {
    "recommended_part_size_mb": recommendedPartSizeMb.toJson(),
    "upload_id": uploadId.toJson(),
    "video_id": videoId.toJson(),
  };
}

class ModelsInvitationInfo {
  String description;
  String type;
  ModelsInvitationInfoProperties properties;

  ModelsInvitationInfo({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsInvitationInfo.fromJson(Map<String, dynamic> json) =>
      ModelsInvitationInfo(
        description: json["description"],
        type: json["type"],
        properties: ModelsInvitationInfoProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsInvitationInfoProperties {
  InviteCode acceptedAt;
  InviteCode createdAt;
  InviteCode email;
  InviteCode expiresAt;
  InviteCode invitationId;
  InviteCode inviteCode;
  InviteCode invitedBy;
  InviteCode orgId;
  InviteCode role;
  Status status;

  ModelsInvitationInfoProperties({
    required this.acceptedAt,
    required this.createdAt,
    required this.email,
    required this.expiresAt,
    required this.invitationId,
    required this.inviteCode,
    required this.invitedBy,
    required this.orgId,
    required this.role,
    required this.status,
  });

  factory ModelsInvitationInfoProperties.fromJson(Map<String, dynamic> json) =>
      ModelsInvitationInfoProperties(
        acceptedAt: InviteCode.fromJson(json["accepted_at"]),
        createdAt: InviteCode.fromJson(json["created_at"]),
        email: InviteCode.fromJson(json["email"]),
        expiresAt: InviteCode.fromJson(json["expires_at"]),
        invitationId: InviteCode.fromJson(json["invitation_id"]),
        inviteCode: InviteCode.fromJson(json["invite_code"]),
        invitedBy: InviteCode.fromJson(json["invited_by"]),
        orgId: InviteCode.fromJson(json["org_id"]),
        role: InviteCode.fromJson(json["role"]),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
    "accepted_at": acceptedAt.toJson(),
    "created_at": createdAt.toJson(),
    "email": email.toJson(),
    "expires_at": expiresAt.toJson(),
    "invitation_id": invitationId.toJson(),
    "invite_code": inviteCode.toJson(),
    "invited_by": invitedBy.toJson(),
    "org_id": orgId.toJson(),
    "role": role.toJson(),
    "status": status.toJson(),
  };
}

class Status {
  String description;
  Type type;

  Status({required this.description, required this.type});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    description: json["description"],
    type: typeValues.map[json["type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": typeValues.reverse[type],
  };
}

class ModelsInviteUserRequest {
  String description;
  String type;
  ModelsInviteUserRequestProperties properties;

  ModelsInviteUserRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsInviteUserRequest.fromJson(Map<String, dynamic> json) =>
      ModelsInviteUserRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsInviteUserRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsInviteUserRequestProperties {
  InviteCode email;
  InviteCode orgId;
  InviteCode role;

  ModelsInviteUserRequestProperties({
    required this.email,
    required this.orgId,
    required this.role,
  });

  factory ModelsInviteUserRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInviteUserRequestProperties(
    email: InviteCode.fromJson(json["email"]),
    orgId: InviteCode.fromJson(json["org_id"]),
    role: InviteCode.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email.toJson(),
    "org_id": orgId.toJson(),
    "role": role.toJson(),
  };
}

class ModelsInviteUserResponse {
  String description;
  String type;
  ModelsInviteUserResponseProperties properties;

  ModelsInviteUserResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsInviteUserResponse.fromJson(Map<String, dynamic> json) =>
      ModelsInviteUserResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsInviteUserResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsInviteUserResponseProperties {
  InviteCode email;
  InviteCode expiresAt;
  InviteCode invitationId;
  InviteCode inviteCode;
  InviteCode role;

  ModelsInviteUserResponseProperties({
    required this.email,
    required this.expiresAt,
    required this.invitationId,
    required this.inviteCode,
    required this.role,
  });

  factory ModelsInviteUserResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsInviteUserResponseProperties(
    email: InviteCode.fromJson(json["email"]),
    expiresAt: InviteCode.fromJson(json["expires_at"]),
    invitationId: InviteCode.fromJson(json["invitation_id"]),
    inviteCode: InviteCode.fromJson(json["invite_code"]),
    role: InviteCode.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email.toJson(),
    "expires_at": expiresAt.toJson(),
    "invitation_id": invitationId.toJson(),
    "invite_code": inviteCode.toJson(),
    "role": role.toJson(),
  };
}

class ModelsListInvitationsResponse {
  String description;
  String type;
  ModelsListInvitationsResponseProperties properties;

  ModelsListInvitationsResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsListInvitationsResponse.fromJson(Map<String, dynamic> json) =>
      ModelsListInvitationsResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsListInvitationsResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsListInvitationsResponseProperties {
  Parts invitations;
  InviteCode total;

  ModelsListInvitationsResponseProperties({
    required this.invitations,
    required this.total,
  });

  factory ModelsListInvitationsResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsListInvitationsResponseProperties(
    invitations: Parts.fromJson(json["invitations"]),
    total: InviteCode.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "invitations": invitations.toJson(),
    "total": total.toJson(),
  };
}

class ModelsListMembersResponse {
  String description;
  String type;
  ModelsListMembersResponseProperties properties;

  ModelsListMembersResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsListMembersResponse.fromJson(Map<String, dynamic> json) =>
      ModelsListMembersResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsListMembersResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsListMembersResponseProperties {
  Parts members;
  InviteCode total;

  ModelsListMembersResponseProperties({
    required this.members,
    required this.total,
  });

  factory ModelsListMembersResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsListMembersResponseProperties(
    members: Parts.fromJson(json["members"]),
    total: InviteCode.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "members": members.toJson(),
    "total": total.toJson(),
  };
}

class ModelsLoginRequest {
  String description;
  String type;
  ModelsLoginRequestProperties properties;

  ModelsLoginRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsLoginRequest.fromJson(Map<String, dynamic> json) =>
      ModelsLoginRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsLoginRequestProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsLoginRequestProperties {
  InviteCode email;
  InviteCode password;

  ModelsLoginRequestProperties({required this.email, required this.password});

  factory ModelsLoginRequestProperties.fromJson(Map<String, dynamic> json) =>
      ModelsLoginRequestProperties(
        email: InviteCode.fromJson(json["email"]),
        password: InviteCode.fromJson(json["password"]),
      );

  Map<String, dynamic> toJson() => {
    "email": email.toJson(),
    "password": password.toJson(),
  };
}

class ModelsLoginResponse {
  String description;
  String type;
  ModelsLoginResponseProperties properties;

  ModelsLoginResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsLoginResponse.fromJson(Map<String, dynamic> json) =>
      ModelsLoginResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsLoginResponseProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsLoginResponseProperties {
  InviteCode accessToken;
  InviteCode expiresAt;
  Parts organizations;
  InviteCode refreshToken;
  User user;

  ModelsLoginResponseProperties({
    required this.accessToken,
    required this.expiresAt,
    required this.organizations,
    required this.refreshToken,
    required this.user,
  });

  factory ModelsLoginResponseProperties.fromJson(Map<String, dynamic> json) =>
      ModelsLoginResponseProperties(
        accessToken: InviteCode.fromJson(json["access_token"]),
        expiresAt: InviteCode.fromJson(json["expires_at"]),
        organizations: Parts.fromJson(json["organizations"]),
        refreshToken: InviteCode.fromJson(json["refresh_token"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken.toJson(),
    "expires_at": expiresAt.toJson(),
    "organizations": organizations.toJson(),
    "refresh_token": refreshToken.toJson(),
    "user": user.toJson(),
  };
}

class ModelsRequest {
  String description;
  String type;
  ModelsLogoutRequestProperties properties;

  ModelsRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsRequest.fromJson(Map<String, dynamic> json) => ModelsRequest(
    description: json["description"],
    type: json["type"],
    properties: ModelsLogoutRequestProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsLogoutRequestProperties {
  InviteCode refreshToken;

  ModelsLogoutRequestProperties({required this.refreshToken});

  factory ModelsLogoutRequestProperties.fromJson(Map<String, dynamic> json) =>
      ModelsLogoutRequestProperties(
        refreshToken: InviteCode.fromJson(json["refresh_token"]),
      );

  Map<String, dynamic> toJson() => {"refresh_token": refreshToken.toJson()};
}

class ModelsMemberInfo {
  String description;
  String type;
  ModelsMemberInfoProperties properties;

  ModelsMemberInfo({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsMemberInfo.fromJson(Map<String, dynamic> json) =>
      ModelsMemberInfo(
        description: json["description"],
        type: json["type"],
        properties: ModelsMemberInfoProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsMemberInfoProperties {
  InviteCode email;
  InviteCode fullName;
  InviteCode invitedBy;
  InviteCode joinedAt;
  InviteCode role;
  InviteCode status;
  InviteCode userId;

  ModelsMemberInfoProperties({
    required this.email,
    required this.fullName,
    required this.invitedBy,
    required this.joinedAt,
    required this.role,
    required this.status,
    required this.userId,
  });

  factory ModelsMemberInfoProperties.fromJson(Map<String, dynamic> json) =>
      ModelsMemberInfoProperties(
        email: InviteCode.fromJson(json["email"]),
        fullName: InviteCode.fromJson(json["full_name"]),
        invitedBy: InviteCode.fromJson(json["invited_by"]),
        joinedAt: InviteCode.fromJson(json["joined_at"]),
        role: InviteCode.fromJson(json["role"]),
        status: InviteCode.fromJson(json["status"]),
        userId: InviteCode.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
    "email": email.toJson(),
    "full_name": fullName.toJson(),
    "invited_by": invitedBy.toJson(),
    "joined_at": joinedAt.toJson(),
    "role": role.toJson(),
    "status": status.toJson(),
    "user_id": userId.toJson(),
  };
}

class ModelsOrganizationInfo {
  String description;
  String type;
  ModelsOrganizationInfoProperties properties;

  ModelsOrganizationInfo({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsOrganizationInfo.fromJson(Map<String, dynamic> json) =>
      ModelsOrganizationInfo(
        description: json["description"],
        type: json["type"],
        properties: ModelsOrganizationInfoProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsOrganizationInfoProperties {
  InviteCode name;
  InviteCode orgId;
  InviteCode role;

  ModelsOrganizationInfoProperties({
    required this.name,
    required this.orgId,
    required this.role,
  });

  factory ModelsOrganizationInfoProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsOrganizationInfoProperties(
    name: InviteCode.fromJson(json["name"]),
    orgId: InviteCode.fromJson(json["org_id"]),
    role: InviteCode.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name.toJson(),
    "org_id": orgId.toJson(),
    "role": role.toJson(),
  };
}

class ModelsPublicVideoResponse {
  String description;
  String type;
  ModelsPublicVideoResponseProperties properties;

  ModelsPublicVideoResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsPublicVideoResponse.fromJson(Map<String, dynamic> json) =>
      ModelsPublicVideoResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsPublicVideoResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsPublicVideoResponseProperties {
  InviteCode description;
  InviteCode durationSeconds;
  InviteCode expiresAt;
  InviteCode fileName;
  InviteCode fileSizeBytes;
  InviteCode streamUrl;
  InviteCode thumbnailUrl;
  InviteCode title;
  InviteCode uploadedAt;
  InviteCode videoId;

  ModelsPublicVideoResponseProperties({
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

  factory ModelsPublicVideoResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsPublicVideoResponseProperties(
    description: InviteCode.fromJson(json["description"]),
    durationSeconds: InviteCode.fromJson(json["duration_seconds"]),
    expiresAt: InviteCode.fromJson(json["expires_at"]),
    fileName: InviteCode.fromJson(json["file_name"]),
    fileSizeBytes: InviteCode.fromJson(json["file_size_bytes"]),
    streamUrl: InviteCode.fromJson(json["stream_url"]),
    thumbnailUrl: InviteCode.fromJson(json["thumbnail_url"]),
    title: InviteCode.fromJson(json["title"]),
    uploadedAt: InviteCode.fromJson(json["uploaded_at"]),
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description.toJson(),
    "duration_seconds": durationSeconds.toJson(),
    "expires_at": expiresAt.toJson(),
    "file_name": fileName.toJson(),
    "file_size_bytes": fileSizeBytes.toJson(),
    "stream_url": streamUrl.toJson(),
    "thumbnail_url": thumbnailUrl.toJson(),
    "title": title.toJson(),
    "uploaded_at": uploadedAt.toJson(),
    "video_id": videoId.toJson(),
  };
}

class ModelsVideoRequest {
  String description;
  String type;
  ModelsPublishVideoRequestProperties properties;

  ModelsVideoRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsVideoRequest.fromJson(Map<String, dynamic> json) =>
      ModelsVideoRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsPublishVideoRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsPublishVideoRequestProperties {
  InviteCode videoId;

  ModelsPublishVideoRequestProperties({required this.videoId});

  factory ModelsPublishVideoRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsPublishVideoRequestProperties(
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {"video_id": videoId.toJson()};
}

class ModelsPublishVideoResult {
  String description;
  String type;
  ModelsPublishVideoResultProperties properties;

  ModelsPublishVideoResult({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsPublishVideoResult.fromJson(Map<String, dynamic> json) =>
      ModelsPublishVideoResult(
        description: json["description"],
        type: json["type"],
        properties: ModelsPublishVideoResultProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsPublishVideoResultProperties {
  InviteCode message;
  InviteCode publicToken;
  InviteCode publicUrl;

  ModelsPublishVideoResultProperties({
    required this.message,
    required this.publicToken,
    required this.publicUrl,
  });

  factory ModelsPublishVideoResultProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsPublishVideoResultProperties(
    message: InviteCode.fromJson(json["message"]),
    publicToken: InviteCode.fromJson(json["public_token"]),
    publicUrl: InviteCode.fromJson(json["public_url"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "public_token": publicToken.toJson(),
    "public_url": publicUrl.toJson(),
  };
}

class ModelsNResponse {
  String description;
  String type;
  ModelsRefreshTokenResponseProperties properties;

  ModelsNResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsNResponse.fromJson(Map<String, dynamic> json) =>
      ModelsNResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsRefreshTokenResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsRefreshTokenResponseProperties {
  InviteCode accessToken;
  InviteCode expiresAt;
  InviteCode refreshToken;
  InviteCode? orgId;

  ModelsRefreshTokenResponseProperties({
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    this.orgId,
  });

  factory ModelsRefreshTokenResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsRefreshTokenResponseProperties(
    accessToken: InviteCode.fromJson(json["access_token"]),
    expiresAt: InviteCode.fromJson(json["expires_at"]),
    refreshToken: InviteCode.fromJson(json["refresh_token"]),
    orgId: json["org_id"] == null ? null : InviteCode.fromJson(json["org_id"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken.toJson(),
    "expires_at": expiresAt.toJson(),
    "refresh_token": refreshToken.toJson(),
    "org_id": orgId?.toJson(),
  };
}

class ModelsRegisterRequest {
  String description;
  String type;
  ModelsRegisterRequestProperties properties;

  ModelsRegisterRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsRegisterRequest.fromJson(Map<String, dynamic> json) =>
      ModelsRegisterRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsRegisterRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsRegisterRequestProperties {
  InviteCode email;
  InviteCode fullName;
  InviteCode inviteCode;
  InviteCode organizationName;
  InviteCode password;

  ModelsRegisterRequestProperties({
    required this.email,
    required this.fullName,
    required this.inviteCode,
    required this.organizationName,
    required this.password,
  });

  factory ModelsRegisterRequestProperties.fromJson(Map<String, dynamic> json) =>
      ModelsRegisterRequestProperties(
        email: InviteCode.fromJson(json["email"]),
        fullName: InviteCode.fromJson(json["full_name"]),
        inviteCode: InviteCode.fromJson(json["invite_code"]),
        organizationName: InviteCode.fromJson(json["organization_name"]),
        password: InviteCode.fromJson(json["password"]),
      );

  Map<String, dynamic> toJson() => {
    "email": email.toJson(),
    "full_name": fullName.toJson(),
    "invite_code": inviteCode.toJson(),
    "organization_name": organizationName.toJson(),
    "password": password.toJson(),
  };
}

class ModelsRegisterResponse {
  String description;
  String type;
  ModelsRegisterResponseProperties properties;

  ModelsRegisterResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsRegisterResponse.fromJson(Map<String, dynamic> json) =>
      ModelsRegisterResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsRegisterResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsRegisterResponseProperties {
  InviteCode message;
  InviteCode userId;

  ModelsRegisterResponseProperties({
    required this.message,
    required this.userId,
  });

  factory ModelsRegisterResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsRegisterResponseProperties(
    message: InviteCode.fromJson(json["message"]),
    userId: InviteCode.fromJson(json["user_id"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "user_id": userId.toJson(),
  };
}

class ModelsResetPasswordRequest {
  String description;
  String type;
  ModelsResetPasswordRequestProperties properties;

  ModelsResetPasswordRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      ModelsResetPasswordRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsResetPasswordRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsResetPasswordRequestProperties {
  InviteCode code;
  InviteCode email;
  InviteCode newPassword;

  ModelsResetPasswordRequestProperties({
    required this.code,
    required this.email,
    required this.newPassword,
  });

  factory ModelsResetPasswordRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsResetPasswordRequestProperties(
    code: InviteCode.fromJson(json["code"]),
    email: InviteCode.fromJson(json["email"]),
    newPassword: InviteCode.fromJson(json["new_password"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code.toJson(),
    "email": email.toJson(),
    "new_password": newPassword.toJson(),
  };
}

class ModelsRevokeVideoResponse {
  String description;
  String type;
  ModelsRevokeVideoResponseProperties properties;

  ModelsRevokeVideoResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsRevokeVideoResponse.fromJson(Map<String, dynamic> json) =>
      ModelsRevokeVideoResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsRevokeVideoResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsRevokeVideoResponseProperties {
  InviteCode message;
  InviteCode status;
  InviteCode videoId;

  ModelsRevokeVideoResponseProperties({
    required this.message,
    required this.status,
    required this.videoId,
  });

  factory ModelsRevokeVideoResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsRevokeVideoResponseProperties(
    message: InviteCode.fromJson(json["message"]),
    status: InviteCode.fromJson(json["status"]),
    videoId: InviteCode.fromJson(json["video_id"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "status": status.toJson(),
    "video_id": videoId.toJson(),
  };
}

class ModelsSearchVideosResponse {
  String description;
  String type;
  ModelsSearchVideosResponseProperties properties;

  ModelsSearchVideosResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsSearchVideosResponse.fromJson(Map<String, dynamic> json) =>
      ModelsSearchVideosResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsSearchVideosResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsSearchVideosResponseProperties {
  InviteCode totalCount;
  Parts videos;

  ModelsSearchVideosResponseProperties({
    required this.totalCount,
    required this.videos,
  });

  factory ModelsSearchVideosResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsSearchVideosResponseProperties(
    totalCount: InviteCode.fromJson(json["total_count"]),
    videos: Parts.fromJson(json["videos"]),
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount.toJson(),
    "videos": videos.toJson(),
  };
}

class ModelsSwitchOrganizationRequest {
  String description;
  String type;
  ModelsSwitchOrganizationRequestProperties properties;

  ModelsSwitchOrganizationRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsSwitchOrganizationRequest.fromJson(Map<String, dynamic> json) =>
      ModelsSwitchOrganizationRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsSwitchOrganizationRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsSwitchOrganizationRequestProperties {
  InviteCode orgId;
  InviteCode refreshToken;

  ModelsSwitchOrganizationRequestProperties({
    required this.orgId,
    required this.refreshToken,
  });

  factory ModelsSwitchOrganizationRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsSwitchOrganizationRequestProperties(
    orgId: InviteCode.fromJson(json["org_id"]),
    refreshToken: InviteCode.fromJson(json["refresh_token"]),
  );

  Map<String, dynamic> toJson() => {
    "org_id": orgId.toJson(),
    "refresh_token": refreshToken.toJson(),
  };
}

class ModelsUpdateMemberRoleRequest {
  String description;
  String type;
  ModelsUpdateMemberRoleRequestProperties properties;

  ModelsUpdateMemberRoleRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsUpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) =>
      ModelsUpdateMemberRoleRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsUpdateMemberRoleRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsUpdateMemberRoleRequestProperties {
  InviteCode newRole;

  ModelsUpdateMemberRoleRequestProperties({required this.newRole});

  factory ModelsUpdateMemberRoleRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsUpdateMemberRoleRequestProperties(
    newRole: InviteCode.fromJson(json["new_role"]),
  );

  Map<String, dynamic> toJson() => {"new_role": newRole.toJson()};
}

class ModelsUpdateMemberStatusRequest {
  String description;
  String type;
  ModelsUpdateMemberStatusRequestProperties properties;

  ModelsUpdateMemberStatusRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsUpdateMemberStatusRequest.fromJson(Map<String, dynamic> json) =>
      ModelsUpdateMemberStatusRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsUpdateMemberStatusRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsUpdateMemberStatusRequestProperties {
  Status status;

  ModelsUpdateMemberStatusRequestProperties({required this.status});

  factory ModelsUpdateMemberStatusRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsUpdateMemberStatusRequestProperties(
    status: Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {"status": status.toJson()};
}

class ModelsUpdateProfileRequest {
  String description;
  String type;
  ModelsUpdateProfileRequestProperties properties;

  ModelsUpdateProfileRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsUpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      ModelsUpdateProfileRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsUpdateProfileRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsUpdateProfileRequestProperties {
  InviteCode fullName;

  ModelsUpdateProfileRequestProperties({required this.fullName});

  factory ModelsUpdateProfileRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsUpdateProfileRequestProperties(
    fullName: InviteCode.fromJson(json["full_name"]),
  );

  Map<String, dynamic> toJson() => {"full_name": fullName.toJson()};
}

class ModelsUserInfo {
  String description;
  String type;
  ModelsUserInfoProperties properties;

  ModelsUserInfo({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsUserInfo.fromJson(Map<String, dynamic> json) => ModelsUserInfo(
    description: json["description"],
    type: json["type"],
    properties: ModelsUserInfoProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsUserInfoProperties {
  InviteCode createdAt;
  InviteCode email;
  InviteCode emailVerified;
  InviteCode fullName;
  InviteCode orgId;
  InviteCode role;
  InviteCode updatedAt;
  InviteCode userId;

  ModelsUserInfoProperties({
    required this.createdAt,
    required this.email,
    required this.emailVerified,
    required this.fullName,
    required this.orgId,
    required this.role,
    required this.updatedAt,
    required this.userId,
  });

  factory ModelsUserInfoProperties.fromJson(Map<String, dynamic> json) =>
      ModelsUserInfoProperties(
        createdAt: InviteCode.fromJson(json["created_at"]),
        email: InviteCode.fromJson(json["email"]),
        emailVerified: InviteCode.fromJson(json["email_verified"]),
        fullName: InviteCode.fromJson(json["full_name"]),
        orgId: InviteCode.fromJson(json["org_id"]),
        role: InviteCode.fromJson(json["role"]),
        updatedAt: InviteCode.fromJson(json["updated_at"]),
        userId: InviteCode.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toJson(),
    "email": email.toJson(),
    "email_verified": emailVerified.toJson(),
    "full_name": fullName.toJson(),
    "org_id": orgId.toJson(),
    "role": role.toJson(),
    "updated_at": updatedAt.toJson(),
    "user_id": userId.toJson(),
  };
}

class ModelsVerifyEmailRequest {
  String description;
  String type;
  ModelsVerifyEmailRequestProperties properties;

  ModelsVerifyEmailRequest({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsVerifyEmailRequest.fromJson(Map<String, dynamic> json) =>
      ModelsVerifyEmailRequest(
        description: json["description"],
        type: json["type"],
        properties: ModelsVerifyEmailRequestProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsVerifyEmailRequestProperties {
  InviteCode code;
  InviteCode email;

  ModelsVerifyEmailRequestProperties({required this.code, required this.email});

  factory ModelsVerifyEmailRequestProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsVerifyEmailRequestProperties(
    code: InviteCode.fromJson(json["code"]),
    email: InviteCode.fromJson(json["email"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code.toJson(),
    "email": email.toJson(),
  };
}

class ModelsVerifyEmailResponse {
  String description;
  String type;
  ModelsVerifyEmailResponseProperties properties;

  ModelsVerifyEmailResponse({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsVerifyEmailResponse.fromJson(Map<String, dynamic> json) =>
      ModelsVerifyEmailResponse(
        description: json["description"],
        type: json["type"],
        properties: ModelsVerifyEmailResponseProperties.fromJson(
          json["properties"],
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsVerifyEmailResponseProperties {
  InviteCode message;
  InviteCode success;

  ModelsVerifyEmailResponseProperties({
    required this.message,
    required this.success,
  });

  factory ModelsVerifyEmailResponseProperties.fromJson(
    Map<String, dynamic> json,
  ) => ModelsVerifyEmailResponseProperties(
    message: InviteCode.fromJson(json["message"]),
    success: InviteCode.fromJson(json["success"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "success": success.toJson(),
  };
}

class ModelsVideo {
  String description;
  String type;
  ModelsVideoProperties properties;

  ModelsVideo({
    required this.description,
    required this.type,
    required this.properties,
  });

  factory ModelsVideo.fromJson(Map<String, dynamic> json) => ModelsVideo(
    description: json["description"],
    type: json["type"],
    properties: ModelsVideoProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ModelsVideoProperties {
  InviteCode durationSeconds;
  InviteCode fileName;
  InviteCode fileSizeBytes;
  InviteCode title;
  InviteCode uploadStatus;
  InviteCode uploadedAt;
  InviteCode videoId;

  ModelsVideoProperties({
    required this.durationSeconds,
    required this.fileName,
    required this.fileSizeBytes,
    required this.title,
    required this.uploadStatus,
    required this.uploadedAt,
    required this.videoId,
  });

  factory ModelsVideoProperties.fromJson(Map<String, dynamic> json) =>
      ModelsVideoProperties(
        durationSeconds: InviteCode.fromJson(json["duration_seconds"]),
        fileName: InviteCode.fromJson(json["file_name"]),
        fileSizeBytes: InviteCode.fromJson(json["file_size_bytes"]),
        title: InviteCode.fromJson(json["title"]),
        uploadStatus: InviteCode.fromJson(json["upload_status"]),
        uploadedAt: InviteCode.fromJson(json["uploaded_at"]),
        videoId: InviteCode.fromJson(json["video_id"]),
      );

  Map<String, dynamic> toJson() => {
    "duration_seconds": durationSeconds.toJson(),
    "file_name": fileName.toJson(),
    "file_size_bytes": fileSizeBytes.toJson(),
    "title": title.toJson(),
    "upload_status": uploadStatus.toJson(),
    "uploaded_at": uploadedAt.toJson(),
    "video_id": videoId.toJson(),
  };
}

class Info {
  String description;
  String title;
  String termsOfService;
  Contact contact;
  License license;
  String version;

  Info({
    required this.description,
    required this.title,
    required this.termsOfService,
    required this.contact,
    required this.license,
    required this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    description: json["description"],
    title: json["title"],
    termsOfService: json["termsOfService"],
    contact: Contact.fromJson(json["contact"]),
    license: License.fromJson(json["license"]),
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "title": title,
    "termsOfService": termsOfService,
    "contact": contact.toJson(),
    "license": license.toJson(),
    "version": version,
  };
}

class Contact {
  String name;
  String url;
  String email;

  Contact({required this.name, required this.url, required this.email});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(name: json["name"], url: json["url"], email: json["email"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url, "email": email};
}

class License {
  String name;
  String url;

  License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) =>
      License(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class Paths {
  AdminAuditLogs adminAuditLogs;
  Auth authForgotPassword;
  Auth authLogin;
  AuthLogout authLogout;
  AuthProfile authProfile;
  Auth authRefresh;
  Auth authRegister;
  Auth authResetPassword;
  AuthLogout authSwitchOrganization;
  Auth authVerifyEmail;
  Organization organizationCreate;
  AdminAuditLogs organizationInvitations;
  AuthLogout organizationInvitationsAccept;
  OrganizationId organizationInvitationsInvitationId;
  Organization organizationInvite;
  AdminAuditLogs organizationMembers;
  OrganizationId organizationMembersUserId;
  OrganizationMembersUserId organizationMembersUserIdRole;
  OrganizationMembersUserId organizationMembersUserIdStatus;
  Video video;
  Video videoDownload;
  VideoPublic videoPublic;
  VideoPublish videoPublish;
  AuthLogout videoRevoke;
  VideoSearch videoSearch;
  AuthLogout videoUploadComplete;
  AuthLogout videoUploadInitiate;
  AuthLogout videoUploadUrls;
  VideoId videoId;

  Paths({
    required this.adminAuditLogs,
    required this.authForgotPassword,
    required this.authLogin,
    required this.authLogout,
    required this.authProfile,
    required this.authRefresh,
    required this.authRegister,
    required this.authResetPassword,
    required this.authSwitchOrganization,
    required this.authVerifyEmail,
    required this.organizationCreate,
    required this.organizationInvitations,
    required this.organizationInvitationsAccept,
    required this.organizationInvitationsInvitationId,
    required this.organizationInvite,
    required this.organizationMembers,
    required this.organizationMembersUserId,
    required this.organizationMembersUserIdRole,
    required this.organizationMembersUserIdStatus,
    required this.video,
    required this.videoDownload,
    required this.videoPublic,
    required this.videoPublish,
    required this.videoRevoke,
    required this.videoSearch,
    required this.videoUploadComplete,
    required this.videoUploadInitiate,
    required this.videoUploadUrls,
    required this.videoId,
  });

  factory Paths.fromJson(Map<String, dynamic> json) => Paths(
    adminAuditLogs: AdminAuditLogs.fromJson(json["/admin/audit-logs"]),
    authForgotPassword: Auth.fromJson(json["/auth/forgot-password"]),
    authLogin: Auth.fromJson(json["/auth/login"]),
    authLogout: AuthLogout.fromJson(json["/auth/logout"]),
    authProfile: AuthProfile.fromJson(json["/auth/profile"]),
    authRefresh: Auth.fromJson(json["/auth/refresh"]),
    authRegister: Auth.fromJson(json["/auth/register"]),
    authResetPassword: Auth.fromJson(json["/auth/reset-password"]),
    authSwitchOrganization: AuthLogout.fromJson(
      json["/auth/switch-organization"],
    ),
    authVerifyEmail: Auth.fromJson(json["/auth/verify-email"]),
    organizationCreate: Organization.fromJson(json["/organization/create"]),
    organizationInvitations: AdminAuditLogs.fromJson(
      json["/organization/invitations"],
    ),
    organizationInvitationsAccept: AuthLogout.fromJson(
      json["/organization/invitations/accept"],
    ),
    organizationInvitationsInvitationId: OrganizationId.fromJson(
      json["/organization/invitations/{invitation_id}"],
    ),
    organizationInvite: Organization.fromJson(json["/organization/invite"]),
    organizationMembers: AdminAuditLogs.fromJson(json["/organization/members"]),
    organizationMembersUserId: OrganizationId.fromJson(
      json["/organization/members/{user_id}"],
    ),
    organizationMembersUserIdRole: OrganizationMembersUserId.fromJson(
      json["/organization/members/{user_id}/role"],
    ),
    organizationMembersUserIdStatus: OrganizationMembersUserId.fromJson(
      json["/organization/members/{user_id}/status"],
    ),
    video: Video.fromJson(json["/video"]),
    videoDownload: Video.fromJson(json["/video/download"]),
    videoPublic: VideoPublic.fromJson(json["/video/public"]),
    videoPublish: VideoPublish.fromJson(json["/video/publish"]),
    videoRevoke: AuthLogout.fromJson(json["/video/revoke"]),
    videoSearch: VideoSearch.fromJson(json["/video/search"]),
    videoUploadComplete: AuthLogout.fromJson(json["/video/upload/complete"]),
    videoUploadInitiate: AuthLogout.fromJson(json["/video/upload/initiate"]),
    videoUploadUrls: AuthLogout.fromJson(json["/video/upload/urls"]),
    videoId: VideoId.fromJson(json["/video/{id}"]),
  );

  Map<String, dynamic> toJson() => {
    "/admin/audit-logs": adminAuditLogs.toJson(),
    "/auth/forgot-password": authForgotPassword.toJson(),
    "/auth/login": authLogin.toJson(),
    "/auth/logout": authLogout.toJson(),
    "/auth/profile": authProfile.toJson(),
    "/auth/refresh": authRefresh.toJson(),
    "/auth/register": authRegister.toJson(),
    "/auth/reset-password": authResetPassword.toJson(),
    "/auth/switch-organization": authSwitchOrganization.toJson(),
    "/auth/verify-email": authVerifyEmail.toJson(),
    "/organization/create": organizationCreate.toJson(),
    "/organization/invitations": organizationInvitations.toJson(),
    "/organization/invitations/accept": organizationInvitationsAccept.toJson(),
    "/organization/invitations/{invitation_id}":
        organizationInvitationsInvitationId.toJson(),
    "/organization/invite": organizationInvite.toJson(),
    "/organization/members": organizationMembers.toJson(),
    "/organization/members/{user_id}": organizationMembersUserId.toJson(),
    "/organization/members/{user_id}/role": organizationMembersUserIdRole
        .toJson(),
    "/organization/members/{user_id}/status": organizationMembersUserIdStatus
        .toJson(),
    "/video": video.toJson(),
    "/video/download": videoDownload.toJson(),
    "/video/public": videoPublic.toJson(),
    "/video/publish": videoPublish.toJson(),
    "/video/revoke": videoRevoke.toJson(),
    "/video/search": videoSearch.toJson(),
    "/video/upload/complete": videoUploadComplete.toJson(),
    "/video/upload/initiate": videoUploadInitiate.toJson(),
    "/video/upload/urls": videoUploadUrls.toJson(),
    "/video/{id}": videoId.toJson(),
  };
}

class AdminAuditLogs {
  AdminAuditLogsGet adminAuditLogsGet;

  AdminAuditLogs({required this.adminAuditLogsGet});

  factory AdminAuditLogs.fromJson(Map<String, dynamic> json) => AdminAuditLogs(
    adminAuditLogsGet: AdminAuditLogsGet.fromJson(json["get"]),
  );

  Map<String, dynamic> toJson() => {"get": adminAuditLogsGet.toJson()};
}

class AdminAuditLogsGet {
  List<Security> security;
  String description;
  List<String> produces;
  List<String> tags;
  String summary;
  List<PurpleParameter> parameters;
  Map<String, GetResponse> responses;

  AdminAuditLogsGet({
    required this.security,
    required this.description,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory AdminAuditLogsGet.fromJson(Map<String, dynamic> json) =>
      AdminAuditLogsGet(
        security: List<Security>.from(
          json["security"].map((x) => Security.fromJson(x)),
        ),
        description: json["description"],
        produces: List<String>.from(json["produces"].map((x) => x)),
        tags: List<String>.from(json["tags"].map((x) => x)),
        summary: json["summary"],
        parameters: List<PurpleParameter>.from(
          json["parameters"].map((x) => PurpleParameter.fromJson(x)),
        ),
        responses: Map.from(json["responses"]).map(
          (k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class PurpleParameter {
  Type? type;
  String description;
  String name;
  PurpleIn parameterIn;
  bool? required;
  User? schema;
  int? parameterDefault;

  PurpleParameter({
    this.type,
    required this.description,
    required this.name,
    required this.parameterIn,
    this.required,
    this.schema,
    this.parameterDefault,
  });

  factory PurpleParameter.fromJson(Map<String, dynamic> json) =>
      PurpleParameter(
        type: typeValues.map[json["type"]]!,
        description: json["description"],
        name: json["name"],
        parameterIn: purpleInValues.map[json["in"]]!,
        required: json["required"],
        schema: json["schema"] == null ? null : User.fromJson(json["schema"]),
        parameterDefault: json["default"],
      );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "description": description,
    "name": name,
    "in": purpleInValues.reverse[parameterIn],
    "required": required,
    "schema": schema?.toJson(),
    "default": parameterDefault,
  };
}

enum PurpleIn { BODY, PATH, QUERY }

final purpleInValues = EnumValues({
  "body": PurpleIn.BODY,
  "path": PurpleIn.PATH,
  "query": PurpleIn.QUERY,
});

class GetResponse {
  String description;
  User schema;

  GetResponse({required this.description, required this.schema});

  factory GetResponse.fromJson(Map<String, dynamic> json) => GetResponse(
    description: json["description"],
    schema: User.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "schema": schema.toJson(),
  };
}

class Security {
  List<dynamic> bearerAuth;

  Security({required this.bearerAuth});

  factory Security.fromJson(Map<String, dynamic> json) => Security(
    bearerAuth: List<dynamic>.from(json["BearerAuth"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "BearerAuth": List<dynamic>.from(bearerAuth.map((x) => x)),
  };
}

class Auth {
  AuthForgotPasswordPost post;

  Auth({required this.post});

  factory Auth.fromJson(Map<String, dynamic> json) =>
      Auth(post: AuthForgotPasswordPost.fromJson(json["post"]));

  Map<String, dynamic> toJson() => {"post": post.toJson()};
}

class AuthForgotPasswordPost {
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<BearerAuth> parameters;
  Map<String, GetResponse> responses;

  AuthForgotPasswordPost({
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory AuthForgotPasswordPost.fromJson(Map<String, dynamic> json) =>
      AuthForgotPasswordPost(
        description: json["description"],
        consumes: List<String>.from(json["consumes"].map((x) => x)),
        produces: List<String>.from(json["produces"].map((x) => x)),
        tags: List<String>.from(json["tags"].map((x) => x)),
        summary: json["summary"],
        parameters: List<BearerAuth>.from(
          json["parameters"].map((x) => BearerAuth.fromJson(x)),
        ),
        responses: Map.from(json["responses"]).map(
          (k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class BearerAuth {
  String description;
  Name name;
  BearerAuthIn bearerAuthIn;
  bool? required;
  User? schema;
  String? type;

  BearerAuth({
    required this.description,
    required this.name,
    required this.bearerAuthIn,
    this.required,
    this.schema,
    this.type,
  });

  factory BearerAuth.fromJson(Map<String, dynamic> json) => BearerAuth(
    description: json["description"],
    name: nameValues.map[json["name"]]!,
    bearerAuthIn: bearerAuthInValues.map[json["in"]]!,
    required: json["required"],
    schema: json["schema"] == null ? null : User.fromJson(json["schema"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "name": nameValues.reverse[name],
    "in": bearerAuthInValues.reverse[bearerAuthIn],
    "required": required,
    "schema": schema?.toJson(),
    "type": type,
  };
}

enum BearerAuthIn { BODY, HEADER, PATH }

final bearerAuthInValues = EnumValues({
  "body": BearerAuthIn.BODY,
  "header": BearerAuthIn.HEADER,
  "path": BearerAuthIn.PATH,
});

enum Name { AUTHORIZATION, ID, REQUEST, USER_ID }

final nameValues = EnumValues({
  "Authorization": Name.AUTHORIZATION,
  "id": Name.ID,
  "request": Name.REQUEST,
  "user_id": Name.USER_ID,
});

class AuthLogout {
  AuthLogoutPost post;

  AuthLogout({required this.post});

  factory AuthLogout.fromJson(Map<String, dynamic> json) =>
      AuthLogout(post: AuthLogoutPost.fromJson(json["post"]));

  Map<String, dynamic> toJson() => {"post": post.toJson()};
}

class AuthLogoutPost {
  List<Security> security;
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<FluffyParameter> parameters;
  Map<String, GetResponse> responses;

  AuthLogoutPost({
    required this.security,
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory AuthLogoutPost.fromJson(Map<String, dynamic> json) => AuthLogoutPost(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<FluffyParameter>.from(
      json["parameters"].map((x) => FluffyParameter.fromJson(x)),
    ),
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class FluffyParameter {
  String description;
  Name name;
  PurpleIn parameterIn;
  bool required;
  User schema;

  FluffyParameter({
    required this.description,
    required this.name,
    required this.parameterIn,
    required this.required,
    required this.schema,
  });

  factory FluffyParameter.fromJson(Map<String, dynamic> json) =>
      FluffyParameter(
        description: json["description"],
        name: nameValues.map[json["name"]]!,
        parameterIn: purpleInValues.map[json["in"]]!,
        required: json["required"],
        schema: User.fromJson(json["schema"]),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "name": nameValues.reverse[name],
    "in": purpleInValues.reverse[parameterIn],
    "required": required,
    "schema": schema.toJson(),
  };
}

class AuthProfile {
  AuthProfileGet authProfileGet;
  PostClass put;

  AuthProfile({required this.authProfileGet, required this.put});

  factory AuthProfile.fromJson(Map<String, dynamic> json) => AuthProfile(
    authProfileGet: AuthProfileGet.fromJson(json["get"]),
    put: PostClass.fromJson(json["put"]),
  );

  Map<String, dynamic> toJson() => {
    "get": authProfileGet.toJson(),
    "put": put.toJson(),
  };
}

class AuthProfileGet {
  List<Security> security;
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  Map<String, GetResponse> responses;

  AuthProfileGet({
    required this.security,
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.responses,
  });

  factory AuthProfileGet.fromJson(Map<String, dynamic> json) => AuthProfileGet(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class PostClass {
  List<Security> security;
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<BearerAuth> parameters;
  Map<String, GetResponse> responses;

  PostClass({
    required this.security,
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory PostClass.fromJson(Map<String, dynamic> json) => PostClass(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<BearerAuth>.from(
      json["parameters"].map((x) => BearerAuth.fromJson(x)),
    ),
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Organization {
  PostClass post;

  Organization({required this.post});

  factory Organization.fromJson(Map<String, dynamic> json) =>
      Organization(post: PostClass.fromJson(json["post"]));

  Map<String, dynamic> toJson() => {"post": post.toJson()};
}

class OrganizationId {
  Delete delete;

  OrganizationId({required this.delete});

  factory OrganizationId.fromJson(Map<String, dynamic> json) =>
      OrganizationId(delete: Delete.fromJson(json["delete"]));

  Map<String, dynamic> toJson() => {"delete": delete.toJson()};
}

class Delete {
  List<Security> security;
  String description;
  List<String> produces;
  List<String> tags;
  String summary;
  List<PurpleParameter> parameters;
  Map<String, PurpleResponse> responses;

  Delete({
    required this.security,
    required this.description,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory Delete.fromJson(Map<String, dynamic> json) => Delete(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<PurpleParameter>.from(
      json["parameters"].map((x) => PurpleParameter.fromJson(x)),
    ),
    responses: Map.from(json["responses"]).map(
      (k, v) => MapEntry<String, PurpleResponse>(k, PurpleResponse.fromJson(v)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class PurpleResponse {
  String description;
  Schema schema;

  PurpleResponse({required this.description, required this.schema});

  factory PurpleResponse.fromJson(Map<String, dynamic> json) => PurpleResponse(
    description: json["description"],
    schema: Schema.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "schema": schema.toJson(),
  };
}

class Schema {
  String? type;
  InviteCode? additionalProperties;
  String? ref;

  Schema({this.type, this.additionalProperties, this.ref});

  factory Schema.fromJson(Map<String, dynamic> json) => Schema(
    type: json["type"],
    additionalProperties: json["additionalProperties"] == null
        ? null
        : InviteCode.fromJson(json["additionalProperties"]),
    ref: json["\u0024ref"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "additionalProperties": additionalProperties?.toJson(),
    "\u0024ref": ref,
  };
}

class OrganizationMembersUserId {
  OrganizationMembersUserIdRolePut put;

  OrganizationMembersUserId({required this.put});

  factory OrganizationMembersUserId.fromJson(Map<String, dynamic> json) =>
      OrganizationMembersUserId(
        put: OrganizationMembersUserIdRolePut.fromJson(json["put"]),
      );

  Map<String, dynamic> toJson() => {"put": put.toJson()};
}

class OrganizationMembersUserIdRolePut {
  List<Security> security;
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<BearerAuth> parameters;
  Map<String, PurpleResponse> responses;

  OrganizationMembersUserIdRolePut({
    required this.security,
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory OrganizationMembersUserIdRolePut.fromJson(
    Map<String, dynamic> json,
  ) => OrganizationMembersUserIdRolePut(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<BearerAuth>.from(
      json["parameters"].map((x) => BearerAuth.fromJson(x)),
    ),
    responses: Map.from(json["responses"]).map(
      (k, v) => MapEntry<String, PurpleResponse>(k, PurpleResponse.fromJson(v)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Video {
  DeleteClass videoGet;

  Video({required this.videoGet});

  factory Video.fromJson(Map<String, dynamic> json) =>
      Video(videoGet: DeleteClass.fromJson(json["get"]));

  Map<String, dynamic> toJson() => {"get": videoGet.toJson()};
}

class DeleteClass {
  List<Security> security;
  String description;
  List<String>? consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<TentacledParameter> parameters;
  Map<String, GetResponse> responses;

  DeleteClass({
    required this.security,
    required this.description,
    this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory DeleteClass.fromJson(Map<String, dynamic> json) => DeleteClass(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: json["consumes"] == null
        ? []
        : List<String>.from(json["consumes"]!.map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<TentacledParameter>.from(
      json["parameters"].map((x) => TentacledParameter.fromJson(x)),
    ),
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": consumes == null
        ? []
        : List<dynamic>.from(consumes!.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class TentacledParameter {
  Type type;
  String description;
  String name;
  PurpleIn parameterIn;
  bool required;

  TentacledParameter({
    required this.type,
    required this.description,
    required this.name,
    required this.parameterIn,
    required this.required,
  });

  factory TentacledParameter.fromJson(Map<String, dynamic> json) =>
      TentacledParameter(
        type: typeValues.map[json["type"]]!,
        description: json["description"],
        name: json["name"],
        parameterIn: purpleInValues.map[json["in"]]!,
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "description": description,
    "name": name,
    "in": purpleInValues.reverse[parameterIn],
    "required": required,
  };
}

class VideoId {
  DeleteClass delete;

  VideoId({required this.delete});

  factory VideoId.fromJson(Map<String, dynamic> json) =>
      VideoId(delete: DeleteClass.fromJson(json["delete"]));

  Map<String, dynamic> toJson() => {"delete": delete.toJson()};
}

class VideoPublic {
  VideoPublicGet videoPublicGet;

  VideoPublic({required this.videoPublicGet});

  factory VideoPublic.fromJson(Map<String, dynamic> json) =>
      VideoPublic(videoPublicGet: VideoPublicGet.fromJson(json["get"]));

  Map<String, dynamic> toJson() => {"get": videoPublicGet.toJson()};
}

class VideoPublicGet {
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<PurpleParameter> parameters;
  Map<String, GetResponse> responses;

  VideoPublicGet({
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory VideoPublicGet.fromJson(Map<String, dynamic> json) => VideoPublicGet(
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<PurpleParameter>.from(
      json["parameters"].map((x) => PurpleParameter.fromJson(x)),
    ),
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class VideoPublish {
  GetClass post;

  VideoPublish({required this.post});

  factory VideoPublish.fromJson(Map<String, dynamic> json) =>
      VideoPublish(post: GetClass.fromJson(json["post"]));

  Map<String, dynamic> toJson() => {"post": post.toJson()};
}

class GetClass {
  List<Security> security;
  String description;
  List<String> consumes;
  List<String> produces;
  List<String> tags;
  String summary;
  List<PurpleParameter> parameters;
  Map<String, GetResponse> responses;

  GetClass({
    required this.security,
    required this.description,
    required this.consumes,
    required this.produces,
    required this.tags,
    required this.summary,
    required this.parameters,
    required this.responses,
  });

  factory GetClass.fromJson(Map<String, dynamic> json) => GetClass(
    security: List<Security>.from(
      json["security"].map((x) => Security.fromJson(x)),
    ),
    description: json["description"],
    consumes: List<String>.from(json["consumes"].map((x) => x)),
    produces: List<String>.from(json["produces"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summary: json["summary"],
    parameters: List<PurpleParameter>.from(
      json["parameters"].map((x) => PurpleParameter.fromJson(x)),
    ),
    responses: Map.from(
      json["responses"],
    ).map((k, v) => MapEntry<String, GetResponse>(k, GetResponse.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "security": List<dynamic>.from(security.map((x) => x.toJson())),
    "description": description,
    "consumes": List<dynamic>.from(consumes.map((x) => x)),
    "produces": List<dynamic>.from(produces.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "summary": summary,
    "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
    "responses": Map.from(
      responses,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class VideoSearch {
  GetClass videoSearchGet;

  VideoSearch({required this.videoSearchGet});

  factory VideoSearch.fromJson(Map<String, dynamic> json) =>
      VideoSearch(videoSearchGet: GetClass.fromJson(json["get"]));

  Map<String, dynamic> toJson() => {"get": videoSearchGet.toJson()};
}

class SecurityDefinitions {
  BearerAuth bearerAuth;

  SecurityDefinitions({required this.bearerAuth});

  factory SecurityDefinitions.fromJson(Map<String, dynamic> json) =>
      SecurityDefinitions(bearerAuth: BearerAuth.fromJson(json["BearerAuth"]));

  Map<String, dynamic> toJson() => {"BearerAuth": bearerAuth.toJson()};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
