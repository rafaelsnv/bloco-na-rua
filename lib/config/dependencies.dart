import 'package:bloco_na_rua/data/repositories/auth/auth_listenable.dart';
import 'package:bloco_na_rua/data/repositories/auth/auth_repository.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/carnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/carnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/meeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/meetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/members_repository.dart';
import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart'
    show LoginResponse;
import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/data/services/api/base/base_api_client.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/carnival_block_members_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/carnival_blocks_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/imeeting_presences_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/meeting_presences_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetings/meetings_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/members_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/google_sign_in_service.dart';
import 'package:bloco_na_rua/data/services/secure_storage_service.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart';
import 'package:bloco_na_rua/domain/use_cases/meetings/get_user_meetings_use_case.dart';
import 'package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:result_dart/result_dart.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorageService storage,
    BaseOptions? options,
  }) : _storage = storage,
       _options = options;

  final SecureStorageService _storage;
  final BaseOptions? _options;
  void Function(ApiError)? onSessionRevoked;

  void setOnSessionRevoked(void Function(ApiError)? callback) =>
      onSessionRevoked = callback;
  Future<Result<LoginResponse>> Function()? _refresh;
  final Logger _logger = Logger('AuthInterceptor');
  Future<LoginResponse?>? _refreshFuture;

  void setRefresh(Future<Result<LoginResponse>> Function() refresh) =>
      _refresh = refresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = (await _storage.fetchToken()).getOrNull();
    assert(() {
      _logger.fine('[AuthInterceptor] ${options.uri} auth=${token != null}');
      return true;
    }());
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode != 401 ||
        response.requestOptions.extra['authRetry'] == true ||
        response.requestOptions.uri.path.startsWith('/api/v1/Auth/')) {
      handler.next(response);
      return;
    }

    final storedToken = (await _storage.fetchToken()).getOrNull();
    final requestToken = response.requestOptions.headers['Authorization'];
    if (storedToken != null &&
        storedToken.isNotEmpty &&
        requestToken != 'Bearer $storedToken') {
      response.requestOptions.headers['Authorization'] = 'Bearer $storedToken';
      response.requestOptions.extra['authRetry'] = true;
      try {
        handler.resolve(
          await Dio(
            _options?.copyWith() ?? BaseOptions(),
          ).fetch(response.requestOptions),
        );
      } on DioException catch (error) {
        handler.reject(error);
      }
      return;
    }
    final refreshFuture = _refreshFuture ??= _refreshWithStorage();
    final refreshed = await refreshFuture;
    if (identical(_refreshFuture, refreshFuture)) {
      if (refreshed == null) {
        refreshFuture.then<void>((_) {
          if (identical(_refreshFuture, refreshFuture)) {
            _refreshFuture = null;
          }
        });
      } else {
        _refreshFuture = null;
      }
    }
    final accessToken = refreshed?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      response.requestOptions.extra['skipSessionRevocation'] = true;
      handler.next(response);
      return;
    }

    final request = response.requestOptions..extra['authRetry'] = true;
    request.headers['Authorization'] = 'Bearer $accessToken';
    try {
      handler.resolve(
        await Dio(
          _options?.copyWith() ?? BaseOptions(),
        ).fetch(request),
      );
    } on DioException catch (error) {
      handler.reject(error);
    }
  }

  Future<LoginResponse?> _refreshWithStorage() async {
    final refreshToken = (await _storage.fetchRefreshToken()).getOrNull();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    final refresh = _refresh;
    if (refresh == null) return null;
    final result = await refresh();
    if (result.isError()) {
      final error = result.exceptionOrNull();
      if (error is ApiError && error.statusCode == 401) {
        await _storage.saveToken(null);
        await _storage.saveRefreshToken(null);
        onSessionRevoked?.call(error);
      }
      return null;
    }
    final response = result.getOrNull();
    final accessToken = response?.accessToken;
    if (accessToken == null || accessToken.isEmpty) return null;
    await _storage.saveToken(accessToken);
    await _storage.saveRefreshToken(response?.refreshToken ?? refreshToken);
    return response;
  }
}

var baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL']!,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  receiveDataWhenStatusError: true,
  validateStatus: (status) => status != null && status < 500,
);

List<SingleChildWidget> get providers {
  return [
    // Core
    Provider(create: (context) => SecureStorageService()),
    Provider<IBaseApiClient>(
      create: (context) {
        AuthInterceptor? authInterceptor;
        final apiClient = BaseApiClient(
          options: baseOptions,
          clientFactory: (options) {
            final client = Dio(options);
            authInterceptor = AuthInterceptor(
              storage: context.read<SecureStorageService>(),
              options: baseOptions,
            );
            client.interceptors.add(authInterceptor!);
            return client;
          },
        );
        authInterceptor?.setOnSessionRevoked(
          (error) => apiClient.onSessionRevoked?.call(error),
        );
        return apiClient;
      },
    ),
    Provider(
      create: (context) {
        final client = AuthApiClient(
          baseApiClient: context.read<IBaseApiClient>(),
        );
        for (final interceptor
            in context.read<IBaseApiClient>().client.interceptors) {
          if (interceptor is AuthInterceptor) {
            interceptor.setRefresh(() async {
              final token =
                  (await context
                          .read<SecureStorageService>()
                          .fetchRefreshToken())
                      .getOrNull();
              if (token == null || token.isEmpty) {
                return Failure(Exception('Refresh token not found'));
              }
              return client.refresh(token);
            });
          }
        }
        return client;
      },
    ),
    Provider(
      create: (context) =>
          GoogleSignInService(authApiClient: context.read<AuthApiClient>()),
    ),

    // Meetings
    Provider<IMeetingsApiClient>(
      create: (context) => MeetingsApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<IMeetingsRepository>(
      create: (context) =>
          MeetingsRepository(meetingsApiClient: context.read()),
    ),

    // Members
    Provider<IMembersApiClient>(
      create: (context) => MembersApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<IMembersRepository>(
      create: (context) => MembersRepository(membersApiClient: context.read()),
    ),

    // CarnivalBlocks
    Provider<ICarnivalBlocksApiClient>(
      create: (context) =>
          CarnivalBlocksApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<ICarnivalBlocksRepository>(
      create: (context) =>
          CarnivalBlocksRepository(carnivalBlockApiClient: context.read()),
    ),

    // CarnivalBlockMembers
    Provider<ICarnivalBlockMembersApiClient>(
      create: (context) =>
          CarnivalBlockMembersApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<ICarnivalBlockMembersRepository>(
      create: (context) => CarnivalBlockMembersRepository(
        carnivalBlockMembersApiClient: context.read(),
      ),
    ),

    // MeetingPresences
    Provider<IMeetingPresencesApiClient>(
      create: (context) =>
          MeetingPresencesApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<IMeetingPresencesRepository>(
      create: (context) =>
          MeetingPresencesRepository(meetingPresencesApiClient: context.read()),
    ),

    // Auth
    ChangeNotifierProvider<AuthListenable>(create: (_) => AuthListenable()),
    Provider<IAuthRepository>(
      create: (context) => AuthRepository(
        membersRepository: context.read(),
        authApiClient: context.read(),
        googleSignInService: context.read(),
        baseApiClient: context.read<IBaseApiClient>(),
        sharedPreferencesService: context.read(),
        authListenable: context.read(),
      ),
    ),

    // Use Cases
    Provider<GetCurrentUserData>(
      create: (context) => GetCurrentUserData(
        authRepository: context.read(),
        memberRepository: context.read(),
      ),
    ),
    Provider<GetHomeDataUseCase>(
      create: (context) => GetHomeDataUseCase(
        getCurrentUserData: context.read(),
        membersRepo: context.read(),
      ),
    ),
    Provider<GetUserMeetingsUseCase>(
      create: (context) => GetUserMeetingsUseCase(
        getCurrentUserData: context.read(),
        membersRepo: context.read(),
      ),
    ),

    // Profile
    Provider<ProfileCubit>(
      create: (context) => ProfileCubit(
        authRepository: context.read(),
        membersRepository: context.read(),
      ),
    ),
  ];
}
