// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'bloco_na_rua.enums.swagger.dart' as enums;

part 'bloco_na_rua.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class CarnivalBlockCreate {
  const CarnivalBlockCreate({this.name, this.ownerId, this.carnivalBlockImage});

  factory CarnivalBlockCreate.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockCreateFromJson(json);

  static const toJsonFactory = _$CarnivalBlockCreateToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockCreateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'ownerId', includeIfNull: false)
  final int? ownerId;
  @JsonKey(name: 'carnivalBlockImage', includeIfNull: false)
  final String? carnivalBlockImage;
  static const fromJsonFactory = _$CarnivalBlockCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockCreate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality().equals(
                  other.ownerId,
                  ownerId,
                )) &&
            (identical(other.carnivalBlockImage, carnivalBlockImage) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockImage,
                  carnivalBlockImage,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(carnivalBlockImage) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockCreateExtension on CarnivalBlockCreate {
  CarnivalBlockCreate copyWith({
    String? name,
    int? ownerId,
    String? carnivalBlockImage,
  }) {
    return CarnivalBlockCreate(
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      carnivalBlockImage: carnivalBlockImage ?? this.carnivalBlockImage,
    );
  }

  CarnivalBlockCreate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<int?>? ownerId,
    Wrapped<String?>? carnivalBlockImage,
  }) {
    return CarnivalBlockCreate(
      name: (name != null ? name.value : this.name),
      ownerId: (ownerId != null ? ownerId.value : this.ownerId),
      carnivalBlockImage: (carnivalBlockImage != null
          ? carnivalBlockImage.value
          : this.carnivalBlockImage),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CarnivalBlockMemberCreate {
  const CarnivalBlockMemberCreate({this.carnivalBlockId, this.role});

  factory CarnivalBlockMemberCreate.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockMemberCreateFromJson(json);

  static const toJsonFactory = _$CarnivalBlockMemberCreateToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockMemberCreateToJson(this);

  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(
    name: 'role',
    includeIfNull: false,
    toJson: rolesEnumNullableToJson,
    fromJson: rolesEnumNullableFromJson,
  )
  final enums.RolesEnum? role;
  static const fromJsonFactory = _$CarnivalBlockMemberCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockMemberCreate &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockMemberCreateExtension on CarnivalBlockMemberCreate {
  CarnivalBlockMemberCreate copyWith({
    int? carnivalBlockId,
    enums.RolesEnum? role,
  }) {
    return CarnivalBlockMemberCreate(
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      role: role ?? this.role,
    );
  }

  CarnivalBlockMemberCreate copyWithWrapped({
    Wrapped<int?>? carnivalBlockId,
    Wrapped<enums.RolesEnum?>? role,
  }) {
    return CarnivalBlockMemberCreate(
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      role: (role != null ? role.value : this.role),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CarnivalBlockMemberResponse {
  const CarnivalBlockMemberResponse({
    this.id,
    this.carnivalBlockId,
    this.memberId,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory CarnivalBlockMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockMemberResponseFromJson(json);

  static const toJsonFactory = _$CarnivalBlockMemberResponseToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockMemberResponseToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final int? id;
  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(name: 'memberId', includeIfNull: false)
  final int? memberId;
  @JsonKey(
    name: 'role',
    includeIfNull: false,
    toJson: rolesEnumNullableToJson,
    fromJson: rolesEnumNullableFromJson,
  )
  final enums.RolesEnum? role;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$CarnivalBlockMemberResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockMemberResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.memberId, memberId) ||
                const DeepCollectionEquality().equals(
                  other.memberId,
                  memberId,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(memberId) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockMemberResponseExtension on CarnivalBlockMemberResponse {
  CarnivalBlockMemberResponse copyWith({
    int? id,
    int? carnivalBlockId,
    int? memberId,
    enums.RolesEnum? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarnivalBlockMemberResponse(
      id: id ?? this.id,
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      memberId: memberId ?? this.memberId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CarnivalBlockMemberResponse copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? carnivalBlockId,
    Wrapped<int?>? memberId,
    Wrapped<enums.RolesEnum?>? role,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return CarnivalBlockMemberResponse(
      id: (id != null ? id.value : this.id),
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      memberId: (memberId != null ? memberId.value : this.memberId),
      role: (role != null ? role.value : this.role),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CarnivalBlockMemberUpdate {
  const CarnivalBlockMemberUpdate({this.carnivalBlockId, this.role});

  factory CarnivalBlockMemberUpdate.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockMemberUpdateFromJson(json);

  static const toJsonFactory = _$CarnivalBlockMemberUpdateToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockMemberUpdateToJson(this);

  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(
    name: 'role',
    includeIfNull: false,
    toJson: rolesEnumNullableToJson,
    fromJson: rolesEnumNullableFromJson,
  )
  final enums.RolesEnum? role;
  static const fromJsonFactory = _$CarnivalBlockMemberUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockMemberUpdate &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockMemberUpdateExtension on CarnivalBlockMemberUpdate {
  CarnivalBlockMemberUpdate copyWith({
    int? carnivalBlockId,
    enums.RolesEnum? role,
  }) {
    return CarnivalBlockMemberUpdate(
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      role: role ?? this.role,
    );
  }

  CarnivalBlockMemberUpdate copyWithWrapped({
    Wrapped<int?>? carnivalBlockId,
    Wrapped<enums.RolesEnum?>? role,
  }) {
    return CarnivalBlockMemberUpdate(
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      role: (role != null ? role.value : this.role),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CarnivalBlockResponse {
  const CarnivalBlockResponse({
    this.id,
    this.ownerId,
    this.name,
    this.inviteCode,
    this.managersInviteCode,
    this.carnivalBlockImage,
    this.createdAt,
    this.updatedAt,
  });

  factory CarnivalBlockResponse.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockResponseFromJson(json);

  static const toJsonFactory = _$CarnivalBlockResponseToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockResponseToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final int? id;
  @JsonKey(name: 'ownerId', includeIfNull: false)
  final int? ownerId;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'inviteCode', includeIfNull: false)
  final String? inviteCode;
  @JsonKey(name: 'managersInviteCode', includeIfNull: false)
  final String? managersInviteCode;
  @JsonKey(name: 'carnivalBlockImage', includeIfNull: false)
  final String? carnivalBlockImage;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$CarnivalBlockResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality().equals(
                  other.ownerId,
                  ownerId,
                )) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.inviteCode, inviteCode) ||
                const DeepCollectionEquality().equals(
                  other.inviteCode,
                  inviteCode,
                )) &&
            (identical(other.managersInviteCode, managersInviteCode) ||
                const DeepCollectionEquality().equals(
                  other.managersInviteCode,
                  managersInviteCode,
                )) &&
            (identical(other.carnivalBlockImage, carnivalBlockImage) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockImage,
                  carnivalBlockImage,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(inviteCode) ^
      const DeepCollectionEquality().hash(managersInviteCode) ^
      const DeepCollectionEquality().hash(carnivalBlockImage) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockResponseExtension on CarnivalBlockResponse {
  CarnivalBlockResponse copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? inviteCode,
    String? managersInviteCode,
    String? carnivalBlockImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarnivalBlockResponse(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      managersInviteCode: managersInviteCode ?? this.managersInviteCode,
      carnivalBlockImage: carnivalBlockImage ?? this.carnivalBlockImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CarnivalBlockResponse copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? ownerId,
    Wrapped<String?>? name,
    Wrapped<String?>? inviteCode,
    Wrapped<String?>? managersInviteCode,
    Wrapped<String?>? carnivalBlockImage,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return CarnivalBlockResponse(
      id: (id != null ? id.value : this.id),
      ownerId: (ownerId != null ? ownerId.value : this.ownerId),
      name: (name != null ? name.value : this.name),
      inviteCode: (inviteCode != null ? inviteCode.value : this.inviteCode),
      managersInviteCode: (managersInviteCode != null
          ? managersInviteCode.value
          : this.managersInviteCode),
      carnivalBlockImage: (carnivalBlockImage != null
          ? carnivalBlockImage.value
          : this.carnivalBlockImage),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CarnivalBlockUpdate {
  const CarnivalBlockUpdate({this.name, this.carnivalBlockImage});

  factory CarnivalBlockUpdate.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockUpdateFromJson(json);

  static const toJsonFactory = _$CarnivalBlockUpdateToJson;
  Map<String, dynamic> toJson() => _$CarnivalBlockUpdateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'carnivalBlockImage', includeIfNull: false)
  final String? carnivalBlockImage;
  static const fromJsonFactory = _$CarnivalBlockUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CarnivalBlockUpdate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.carnivalBlockImage, carnivalBlockImage) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockImage,
                  carnivalBlockImage,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(carnivalBlockImage) ^
      runtimeType.hashCode;
}

extension $CarnivalBlockUpdateExtension on CarnivalBlockUpdate {
  CarnivalBlockUpdate copyWith({String? name, String? carnivalBlockImage}) {
    return CarnivalBlockUpdate(
      name: name ?? this.name,
      carnivalBlockImage: carnivalBlockImage ?? this.carnivalBlockImage,
    );
  }

  CarnivalBlockUpdate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? carnivalBlockImage,
  }) {
    return CarnivalBlockUpdate(
      name: (name != null ? name.value : this.name),
      carnivalBlockImage: (carnivalBlockImage != null
          ? carnivalBlockImage.value
          : this.carnivalBlockImage),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  static const toJsonFactory = _$LoginResponseToJson;
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @JsonKey(name: 'accessToken', includeIfNull: false)
  final String? accessToken;
  @JsonKey(name: 'refreshToken', includeIfNull: false)
  final String? refreshToken;
  @JsonKey(name: 'expiresIn', includeIfNull: false)
  final int? expiresIn;
  @JsonKey(name: 'tokenType', includeIfNull: false)
  final String? tokenType;
  @JsonKey(name: 'userId', includeIfNull: false)
  final String? userId;
  static const fromJsonFactory = _$LoginResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )) &&
            (identical(other.expiresIn, expiresIn) ||
                const DeepCollectionEquality().equals(
                  other.expiresIn,
                  expiresIn,
                )) &&
            (identical(other.tokenType, tokenType) ||
                const DeepCollectionEquality().equals(
                  other.tokenType,
                  tokenType,
                )) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      const DeepCollectionEquality().hash(expiresIn) ^
      const DeepCollectionEquality().hash(tokenType) ^
      const DeepCollectionEquality().hash(userId) ^
      runtimeType.hashCode;
}

extension $LoginResponseExtension on LoginResponse {
  LoginResponse copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    String? tokenType,
    String? userId,
  }) {
    return LoginResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
      userId: userId ?? this.userId,
    );
  }

  LoginResponse copyWithWrapped({
    Wrapped<String?>? accessToken,
    Wrapped<String?>? refreshToken,
    Wrapped<int?>? expiresIn,
    Wrapped<String?>? tokenType,
    Wrapped<String?>? userId,
  }) {
    return LoginResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
      expiresIn: (expiresIn != null ? expiresIn.value : this.expiresIn),
      tokenType: (tokenType != null ? tokenType.value : this.tokenType),
      userId: (userId != null ? userId.value : this.userId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingCreate {
  const MeetingCreate({
    this.name,
    this.description,
    this.location,
    this.meetingDateTime,
    this.carnivalBlockId,
  });

  factory MeetingCreate.fromJson(Map<String, dynamic> json) =>
      _$MeetingCreateFromJson(json);

  static const toJsonFactory = _$MeetingCreateToJson;
  Map<String, dynamic> toJson() => _$MeetingCreateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'location', includeIfNull: false)
  final String? location;
  @JsonKey(name: 'meetingDateTime', includeIfNull: false)
  final DateTime? meetingDateTime;
  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  static const fromJsonFactory = _$MeetingCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingCreate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.meetingDateTime, meetingDateTime) ||
                const DeepCollectionEquality().equals(
                  other.meetingDateTime,
                  meetingDateTime,
                )) &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(meetingDateTime) ^
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      runtimeType.hashCode;
}

extension $MeetingCreateExtension on MeetingCreate {
  MeetingCreate copyWith({
    String? name,
    String? description,
    String? location,
    DateTime? meetingDateTime,
    int? carnivalBlockId,
  }) {
    return MeetingCreate(
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      meetingDateTime: meetingDateTime ?? this.meetingDateTime,
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
    );
  }

  MeetingCreate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? location,
    Wrapped<DateTime?>? meetingDateTime,
    Wrapped<int?>? carnivalBlockId,
  }) {
    return MeetingCreate(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      meetingDateTime: (meetingDateTime != null
          ? meetingDateTime.value
          : this.meetingDateTime),
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingPresenceCreate {
  const MeetingPresenceCreate({
    this.meetingId,
    this.carnivalBlockId,
    this.isPresent,
  });

  factory MeetingPresenceCreate.fromJson(Map<String, dynamic> json) =>
      _$MeetingPresenceCreateFromJson(json);

  static const toJsonFactory = _$MeetingPresenceCreateToJson;
  Map<String, dynamic> toJson() => _$MeetingPresenceCreateToJson(this);

  @JsonKey(name: 'meetingId', includeIfNull: false)
  final int? meetingId;
  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(name: 'isPresent', includeIfNull: false)
  final bool? isPresent;
  static const fromJsonFactory = _$MeetingPresenceCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingPresenceCreate &&
            (identical(other.meetingId, meetingId) ||
                const DeepCollectionEquality().equals(
                  other.meetingId,
                  meetingId,
                )) &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.isPresent, isPresent) ||
                const DeepCollectionEquality().equals(
                  other.isPresent,
                  isPresent,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(meetingId) ^
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(isPresent) ^
      runtimeType.hashCode;
}

extension $MeetingPresenceCreateExtension on MeetingPresenceCreate {
  MeetingPresenceCreate copyWith({
    int? meetingId,
    int? carnivalBlockId,
    bool? isPresent,
  }) {
    return MeetingPresenceCreate(
      meetingId: meetingId ?? this.meetingId,
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  MeetingPresenceCreate copyWithWrapped({
    Wrapped<int?>? meetingId,
    Wrapped<int?>? carnivalBlockId,
    Wrapped<bool?>? isPresent,
  }) {
    return MeetingPresenceCreate(
      meetingId: (meetingId != null ? meetingId.value : this.meetingId),
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      isPresent: (isPresent != null ? isPresent.value : this.isPresent),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingPresenceResponse {
  const MeetingPresenceResponse({
    this.id,
    this.memberId,
    this.meetingId,
    this.carnivalBlockId,
    this.isPresent,
    this.createdAt,
    this.updatedAt,
  });

  factory MeetingPresenceResponse.fromJson(Map<String, dynamic> json) =>
      _$MeetingPresenceResponseFromJson(json);

  static const toJsonFactory = _$MeetingPresenceResponseToJson;
  Map<String, dynamic> toJson() => _$MeetingPresenceResponseToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final int? id;
  @JsonKey(name: 'memberId', includeIfNull: false)
  final int? memberId;
  @JsonKey(name: 'meetingId', includeIfNull: false)
  final int? meetingId;
  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(name: 'isPresent', includeIfNull: false)
  final bool? isPresent;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$MeetingPresenceResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingPresenceResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.memberId, memberId) ||
                const DeepCollectionEquality().equals(
                  other.memberId,
                  memberId,
                )) &&
            (identical(other.meetingId, meetingId) ||
                const DeepCollectionEquality().equals(
                  other.meetingId,
                  meetingId,
                )) &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.isPresent, isPresent) ||
                const DeepCollectionEquality().equals(
                  other.isPresent,
                  isPresent,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(memberId) ^
      const DeepCollectionEquality().hash(meetingId) ^
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(isPresent) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $MeetingPresenceResponseExtension on MeetingPresenceResponse {
  MeetingPresenceResponse copyWith({
    int? id,
    int? memberId,
    int? meetingId,
    int? carnivalBlockId,
    bool? isPresent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeetingPresenceResponse(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      meetingId: meetingId ?? this.meetingId,
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      isPresent: isPresent ?? this.isPresent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  MeetingPresenceResponse copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<int?>? memberId,
    Wrapped<int?>? meetingId,
    Wrapped<int?>? carnivalBlockId,
    Wrapped<bool?>? isPresent,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return MeetingPresenceResponse(
      id: (id != null ? id.value : this.id),
      memberId: (memberId != null ? memberId.value : this.memberId),
      meetingId: (meetingId != null ? meetingId.value : this.meetingId),
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      isPresent: (isPresent != null ? isPresent.value : this.isPresent),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingPresenceUpdate {
  const MeetingPresenceUpdate({this.isPresent});

  factory MeetingPresenceUpdate.fromJson(Map<String, dynamic> json) =>
      _$MeetingPresenceUpdateFromJson(json);

  static const toJsonFactory = _$MeetingPresenceUpdateToJson;
  Map<String, dynamic> toJson() => _$MeetingPresenceUpdateToJson(this);

  @JsonKey(name: 'isPresent', includeIfNull: false)
  final bool? isPresent;
  static const fromJsonFactory = _$MeetingPresenceUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingPresenceUpdate &&
            (identical(other.isPresent, isPresent) ||
                const DeepCollectionEquality().equals(
                  other.isPresent,
                  isPresent,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(isPresent) ^ runtimeType.hashCode;
}

extension $MeetingPresenceUpdateExtension on MeetingPresenceUpdate {
  MeetingPresenceUpdate copyWith({bool? isPresent}) {
    return MeetingPresenceUpdate(isPresent: isPresent ?? this.isPresent);
  }

  MeetingPresenceUpdate copyWithWrapped({Wrapped<bool?>? isPresent}) {
    return MeetingPresenceUpdate(
      isPresent: (isPresent != null ? isPresent.value : this.isPresent),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingResponse {
  const MeetingResponse({
    this.id,
    this.name,
    this.description,
    this.location,
    this.meetingCode,
    this.meetingDateTime,
    this.carnivalBlockId,
    this.createdAt,
    this.updatedAt,
  });

  factory MeetingResponse.fromJson(Map<String, dynamic> json) =>
      _$MeetingResponseFromJson(json);

  static const toJsonFactory = _$MeetingResponseToJson;
  Map<String, dynamic> toJson() => _$MeetingResponseToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final int? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'location', includeIfNull: false)
  final String? location;
  @JsonKey(name: 'meetingCode', includeIfNull: false)
  final String? meetingCode;
  @JsonKey(name: 'meetingDateTime', includeIfNull: false)
  final DateTime? meetingDateTime;
  @JsonKey(name: 'carnivalBlockId', includeIfNull: false)
  final int? carnivalBlockId;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$MeetingResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.meetingCode, meetingCode) ||
                const DeepCollectionEquality().equals(
                  other.meetingCode,
                  meetingCode,
                )) &&
            (identical(other.meetingDateTime, meetingDateTime) ||
                const DeepCollectionEquality().equals(
                  other.meetingDateTime,
                  meetingDateTime,
                )) &&
            (identical(other.carnivalBlockId, carnivalBlockId) ||
                const DeepCollectionEquality().equals(
                  other.carnivalBlockId,
                  carnivalBlockId,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(meetingCode) ^
      const DeepCollectionEquality().hash(meetingDateTime) ^
      const DeepCollectionEquality().hash(carnivalBlockId) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $MeetingResponseExtension on MeetingResponse {
  MeetingResponse copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    String? meetingCode,
    DateTime? meetingDateTime,
    int? carnivalBlockId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeetingResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      meetingCode: meetingCode ?? this.meetingCode,
      meetingDateTime: meetingDateTime ?? this.meetingDateTime,
      carnivalBlockId: carnivalBlockId ?? this.carnivalBlockId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  MeetingResponse copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? location,
    Wrapped<String?>? meetingCode,
    Wrapped<DateTime?>? meetingDateTime,
    Wrapped<int?>? carnivalBlockId,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return MeetingResponse(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      meetingCode: (meetingCode != null ? meetingCode.value : this.meetingCode),
      meetingDateTime: (meetingDateTime != null
          ? meetingDateTime.value
          : this.meetingDateTime),
      carnivalBlockId: (carnivalBlockId != null
          ? carnivalBlockId.value
          : this.carnivalBlockId),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MeetingUpdate {
  const MeetingUpdate({
    this.name,
    this.description,
    this.location,
    this.meetingDateTime,
  });

  factory MeetingUpdate.fromJson(Map<String, dynamic> json) =>
      _$MeetingUpdateFromJson(json);

  static const toJsonFactory = _$MeetingUpdateToJson;
  Map<String, dynamic> toJson() => _$MeetingUpdateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'location', includeIfNull: false)
  final String? location;
  @JsonKey(name: 'meetingDateTime', includeIfNull: false)
  final DateTime? meetingDateTime;
  static const fromJsonFactory = _$MeetingUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MeetingUpdate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.meetingDateTime, meetingDateTime) ||
                const DeepCollectionEquality().equals(
                  other.meetingDateTime,
                  meetingDateTime,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(meetingDateTime) ^
      runtimeType.hashCode;
}

extension $MeetingUpdateExtension on MeetingUpdate {
  MeetingUpdate copyWith({
    String? name,
    String? description,
    String? location,
    DateTime? meetingDateTime,
  }) {
    return MeetingUpdate(
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      meetingDateTime: meetingDateTime ?? this.meetingDateTime,
    );
  }

  MeetingUpdate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? location,
    Wrapped<DateTime?>? meetingDateTime,
  }) {
    return MeetingUpdate(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      meetingDateTime: (meetingDateTime != null
          ? meetingDateTime.value
          : this.meetingDateTime),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MemberCreate {
  const MemberCreate({
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.uuid,
  });

  factory MemberCreate.fromJson(Map<String, dynamic> json) =>
      _$MemberCreateFromJson(json);

  static const toJsonFactory = _$MemberCreateToJson;
  Map<String, dynamic> toJson() => _$MemberCreateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;
  @JsonKey(name: 'phone', includeIfNull: false)
  final String? phone;
  @JsonKey(name: 'profileImage', includeIfNull: false)
  final String? profileImage;
  @JsonKey(name: 'uuid', includeIfNull: false)
  final String? uuid;
  static const fromJsonFactory = _$MemberCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MemberCreate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.profileImage, profileImage) ||
                const DeepCollectionEquality().equals(
                  other.profileImage,
                  profileImage,
                )) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(profileImage) ^
      const DeepCollectionEquality().hash(uuid) ^
      runtimeType.hashCode;
}

extension $MemberCreateExtension on MemberCreate {
  MemberCreate copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? uuid,
  }) {
    return MemberCreate(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      uuid: uuid ?? this.uuid,
    );
  }

  MemberCreate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
    Wrapped<String?>? profileImage,
    Wrapped<String?>? uuid,
  }) {
    return MemberCreate(
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
      profileImage: (profileImage != null
          ? profileImage.value
          : this.profileImage),
      uuid: (uuid != null ? uuid.value : this.uuid),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MemberResponse {
  const MemberResponse({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.uuid,
    this.createdAt,
    this.updatedAt,
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseFromJson(json);

  static const toJsonFactory = _$MemberResponseToJson;
  Map<String, dynamic> toJson() => _$MemberResponseToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final int? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;
  @JsonKey(name: 'phone', includeIfNull: false)
  final String? phone;
  @JsonKey(name: 'profileImage', includeIfNull: false)
  final String? profileImage;
  @JsonKey(name: 'uuid', includeIfNull: false)
  final String? uuid;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$MemberResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MemberResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.profileImage, profileImage) ||
                const DeepCollectionEquality().equals(
                  other.profileImage,
                  profileImage,
                )) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(profileImage) ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $MemberResponseExtension on MemberResponse {
  MemberResponse copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? uuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemberResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  MemberResponse copyWithWrapped({
    Wrapped<int?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
    Wrapped<String?>? profileImage,
    Wrapped<String?>? uuid,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return MemberResponse(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
      profileImage: (profileImage != null
          ? profileImage.value
          : this.profileImage),
      uuid: (uuid != null ? uuid.value : this.uuid),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MemberUpdate {
  const MemberUpdate({this.name, this.email, this.phone, this.profileImage});

  factory MemberUpdate.fromJson(Map<String, dynamic> json) =>
      _$MemberUpdateFromJson(json);

  static const toJsonFactory = _$MemberUpdateToJson;
  Map<String, dynamic> toJson() => _$MemberUpdateToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;
  @JsonKey(name: 'phone', includeIfNull: false)
  final String? phone;
  @JsonKey(name: 'profileImage', includeIfNull: false)
  final String? profileImage;
  static const fromJsonFactory = _$MemberUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MemberUpdate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.profileImage, profileImage) ||
                const DeepCollectionEquality().equals(
                  other.profileImage,
                  profileImage,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(profileImage) ^
      runtimeType.hashCode;
}

extension $MemberUpdateExtension on MemberUpdate {
  MemberUpdate copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    return MemberUpdate(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  MemberUpdate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? email,
    Wrapped<String?>? phone,
    Wrapped<String?>? profileImage,
  }) {
    return MemberUpdate(
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      phone: (phone != null ? phone.value : this.phone),
      profileImage: (profileImage != null
          ? profileImage.value
          : this.profileImage),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProblemDetails {
  const ProblemDetails({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
  });

  factory ProblemDetails.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsFromJson(json);

  static const toJsonFactory = _$ProblemDetailsToJson;
  Map<String, dynamic> toJson() => _$ProblemDetailsToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'title', includeIfNull: false)
  final String? title;
  @JsonKey(name: 'status', includeIfNull: false)
  final int? status;
  @JsonKey(name: 'detail', includeIfNull: false)
  final String? detail;
  @JsonKey(name: 'instance', includeIfNull: false)
  final String? instance;
  static const fromJsonFactory = _$ProblemDetailsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProblemDetails &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)) &&
            (identical(other.instance, instance) ||
                const DeepCollectionEquality().equals(
                  other.instance,
                  instance,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(detail) ^
      const DeepCollectionEquality().hash(instance) ^
      runtimeType.hashCode;
}

extension $ProblemDetailsExtension on ProblemDetails {
  ProblemDetails copyWith({
    String? type,
    String? title,
    int? status,
    String? detail,
    String? instance,
  }) {
    return ProblemDetails(
      type: type ?? this.type,
      title: title ?? this.title,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      instance: instance ?? this.instance,
    );
  }

  ProblemDetails copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<String?>? title,
    Wrapped<int?>? status,
    Wrapped<String?>? detail,
    Wrapped<String?>? instance,
  }) {
    return ProblemDetails(
      type: (type != null ? type.value : this.type),
      title: (title != null ? title.value : this.title),
      status: (status != null ? status.value : this.status),
      detail: (detail != null ? detail.value : this.detail),
      instance: (instance != null ? instance.value : this.instance),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiV1AuthLoginPost$RequestBody {
  const ApiV1AuthLoginPost$RequestBody({this.email, this.password});

  factory ApiV1AuthLoginPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiV1AuthLoginPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$ApiV1AuthLoginPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$ApiV1AuthLoginPost$RequestBodyToJson(this);

  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;
  static const fromJsonFactory = _$ApiV1AuthLoginPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiV1AuthLoginPost$RequestBody &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $ApiV1AuthLoginPost$RequestBodyExtension
    on ApiV1AuthLoginPost$RequestBody {
  ApiV1AuthLoginPost$RequestBody copyWith({String? email, String? password}) {
    return ApiV1AuthLoginPost$RequestBody(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  ApiV1AuthLoginPost$RequestBody copyWithWrapped({
    Wrapped<String?>? email,
    Wrapped<String?>? password,
  }) {
    return ApiV1AuthLoginPost$RequestBody(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

int? rolesEnumNullableToJson(enums.RolesEnum? rolesEnum) {
  return rolesEnum?.value;
}

int? rolesEnumToJson(enums.RolesEnum rolesEnum) {
  return rolesEnum.value;
}

enums.RolesEnum rolesEnumFromJson(
  Object? rolesEnum, [
  enums.RolesEnum? defaultValue,
]) {
  return enums.RolesEnum.values.firstWhereOrNull((e) => e.value == rolesEnum) ??
      defaultValue ??
      enums.RolesEnum.swaggerGeneratedUnknown;
}

enums.RolesEnum? rolesEnumNullableFromJson(
  Object? rolesEnum, [
  enums.RolesEnum? defaultValue,
]) {
  if (rolesEnum == null) {
    return null;
  }
  return enums.RolesEnum.values.firstWhereOrNull((e) => e.value == rolesEnum) ??
      defaultValue;
}

String rolesEnumExplodedListToJson(List<enums.RolesEnum>? rolesEnum) {
  return rolesEnum?.map((e) => e.value!).join(',') ?? '';
}

List<int> rolesEnumListToJson(List<enums.RolesEnum>? rolesEnum) {
  if (rolesEnum == null) {
    return [];
  }

  return rolesEnum.map((e) => e.value!).toList();
}

List<enums.RolesEnum> rolesEnumListFromJson(
  List? rolesEnum, [
  List<enums.RolesEnum>? defaultValue,
]) {
  if (rolesEnum == null) {
    return defaultValue ?? [];
  }

  return rolesEnum.map((e) => rolesEnumFromJson(e)).toList();
}

List<enums.RolesEnum>? rolesEnumNullableListFromJson(
  List? rolesEnum, [
  List<enums.RolesEnum>? defaultValue,
]) {
  if (rolesEnum == null) {
    return defaultValue;
  }

  return rolesEnum.map((e) => rolesEnumFromJson(e)).toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
