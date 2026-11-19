import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:test/test.dart";

class MockDio extends Mock implements Dio {}

class MockBaseApiClient extends Mock implements IBaseApiClient {
  @override
  late Dio client;
}

void main() {
  late MockDio dio;
  late MockBaseApiClient baseApiClient;
  late AuthApiClient authApiClient;

  final loginJson = <String, dynamic>{
    "accessToken": "access-token",
    "refreshToken": "refresh-token",
    "userId": "user-id",
  };

  setUp(() {
    dio = MockDio();
    baseApiClient = MockBaseApiClient()..client = dio;
    authApiClient = AuthApiClient(baseApiClient: baseApiClient);
    when(
      () => dio.options,
    ).thenReturn(BaseOptions(baseUrl: "https://api.test"));
  });

  test(
    "login posts form-urlencoded credentials and parses the response",
    () async {
      // Arrange
      when(
        () => dio.post<dynamic>(
          any(),
          data: any(named: "data"),
          options: any(named: "options"),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: "/api/v1/Auth/login"),
          statusCode: 200,
          data: loginJson,
        ),
      );

      // Act
      final result = await authApiClient.loginAsync("user@test.com", "secret");

      // Assert
      expect(result.getOrNull()?.accessToken, "access-token");
      final captured = verify(
        () => dio.post<dynamic>(
          "/api/v1/Auth/login",
          data: captureAny(named: "data"),
          options: captureAny(named: "options"),
        ),
      ).captured;
      expect(captured[0], "Email=user%40test.com&Password=secret");
      expect(
        (captured[1] as Options).contentType,
        Headers.formUrlEncodedContentType,
      );
    },
  );

  test("signup posts form-urlencoded fields", () async {
    // Arrange
    when(
      () => dio.post<dynamic>(
        any(),
        data: any(named: "data"),
        options: any(named: "options"),
      ),
    ).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: "/api/v1/Auth/signup"),
        statusCode: 201,
      ),
    );
    const request = SignUpRequest(
      name: "Ana",
      email: "ana@test.com",
      phone: "5511999999999",
      password: "secret",
    );

    // Act
    final result = await authApiClient.signUpAsync(request);

    // Assert
    expect(result.isSuccess(), isTrue);
    final captured = verify(
      () => dio.post<dynamic>(
        "/api/v1/Auth/signup",
        data: captureAny(named: "data"),
        options: captureAny(named: "options"),
      ),
    ).captured;
    expect(captured[0], "Email=ana%40test.com&Password=secret&Name=Ana");
    expect(
      (captured[1] as Options).contentType,
      Headers.formUrlEncodedContentType,
    );
  });

  test("refresh posts JSON and parses the response", () async {
    // Arrange
    when(() => dio.post<dynamic>(any(), data: any(named: "data"))).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: "/api/v1/Auth/refresh"),
        statusCode: 200,
        data: loginJson,
      ),
    );

    // Act
    final result = await authApiClient.refresh("refresh-token");

    // Assert
    expect(result.getOrNull()?.refreshToken, "refresh-token");
    verify(
      () => dio.post<dynamic>(
        "/api/v1/Auth/refresh",
        data: {"refreshToken": "refresh-token"},
      ),
    ).called(1);
  });

  test("logout sends the access token as a Bearer header", () async {
    // Arrange
    when(
      () => dio.post<dynamic>(any(), options: any(named: "options")),
    ).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: "/api/v1/Auth/logout"),
        statusCode: 200,
      ),
    );

    // Act
    final result = await authApiClient.logout("access-token");

    // Assert
    expect(result.isSuccess(), isTrue);
    final options =
        verify(
              () => dio.post<dynamic>(
                "/api/v1/Auth/logout",
                options: captureAny(named: "options"),
              ),
            ).captured.single
            as Options;
    expect(options.headers?["Authorization"], "Bearer access-token");
  });

  test("maps Dio failures through ApiError.fromDioException", () async {
    // Arrange
    final exception = DioException(
      requestOptions: RequestOptions(path: "/api/v1/Auth/login"),
      type: DioExceptionType.connectionTimeout,
      message: "slow",
    );
    when(
      () => dio.post<dynamic>(
        any(),
        data: any(named: "data"),
        options: any(named: "options"),
      ),
    ).thenThrow(exception);

    // Act
    final result = await authApiClient.loginAsync("user@test.com", "secret");

    // Assert
    final error = result.exceptionOrNull();
    expect(error, isA<ApiError>());
    expect((error! as ApiError).type, ApiErrorType.timeout);
  });

  test("returns the absolute Google challenge URL", () {
    // Arrange is provided by setUp.

    // Act
    final url = authApiClient.googleChallengeUrl();

    // Assert
    expect(url, "https://api.test/api/v1/Auth/google/challenge");
  });
}
