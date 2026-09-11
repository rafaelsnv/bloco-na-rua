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
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthInterceptor extends Interceptor {
  final Logger _logger = Logger('AuthInterceptor');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = Supabase.instance.client.auth.currentSession;
    final token = session?.accessToken;
    assert(() {
      _logger.fine('[AuthInterceptor] ${options.uri} auth=${token != null}');
      return true;
    }());
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

var baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL']!,
  receiveDataWhenStatusError: true,
  validateStatus: (status) => status != null && status >= 200 && status < 300,
);

var supabaseClient = Supabase.instance.client;

List<SingleChildWidget> get providers {
  return [
    // Core
    Provider<SupabaseClient>(create: (context) => supabaseClient),
    Provider(create: (context) => SecureStorageService()),
    Provider<IBaseApiClient>(
      create: (context) => BaseApiClient(
        clientFactory: (options) {
          final client = Dio(options);
          client.interceptors.add(AuthInterceptor());
          return client;
        },
        options: baseOptions,
      ),
    ),
    Provider(
      create: (context) =>
          AuthApiClient(baseApiClient: context.read<IBaseApiClient>()),
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
    Provider<IAuthRepository>(
      create: (context) => AuthRepository(
        membersRepository: context.read(),
        authApiClient: context.read(),
        baseApiClient: context.read<IBaseApiClient>(),
        sharedPreferencesService: context.read(),
      ),
    ),
    ChangeNotifierProvider<AuthListenable>(create: (_) => AuthListenable()),

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
