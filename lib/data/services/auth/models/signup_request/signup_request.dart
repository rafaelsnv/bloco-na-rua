import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

@freezed
sealed class SignUpRequest with _$SignUpRequest {
  const factory SignUpRequest({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  }) = _SignUpRequest;

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);
}
