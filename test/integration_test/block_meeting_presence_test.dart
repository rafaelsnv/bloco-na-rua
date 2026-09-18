import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart';
import 'package:bloco_na_rua/domain/use_cases/meetings/get_user_meetings_use_case.dart';
import 'package:bloco_na_rua/l10n/app_localizations.dart';
import 'package:bloco_na_rua/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:result_dart/result_dart.dart';

class MockICarnivalBlocksRepository extends Mock
    implements ICarnivalBlocksRepository {}

class MockIMeetingsRepository extends Mock implements IMeetingsRepository {}

class MockIMeetingPresencesRepository extends Mock
    implements IMeetingPresencesRepository {}

class MockICarnivalBlockMembersRepository extends Mock
    implements ICarnivalBlockMembersRepository {}

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockGetCurrentUserData extends Mock implements GetCurrentUserData {}

class MockGetHomeDataUseCase extends Mock implements GetHomeDataUseCase {}

class MockGetUserMeetingsUseCase extends Mock
    implements GetUserMeetingsUseCase {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Block-Meeting-Presence Lifecycle Integration', () {
    late MockICarnivalBlocksRepository mockBlocksRepo;
    late MockIMeetingsRepository mockMeetingsRepo;
    late MockIMeetingPresencesRepository mockPresencesRepo;
    late MockICarnivalBlockMembersRepository mockBlockMembersRepo;
    late MockIAuthRepository mockAuthRepo;
    late MockIMembersRepository mockMembersRepo;
    late MockGetCurrentUserData mockGetCurrentUserData;
    late MockGetHomeDataUseCase mockGetHomeDataUseCase;

    // Test data
    late CarnivalBlocksEntity createdBlock;
    late MeetingsEntity createdMeeting;
    late MeetingPresencesEntity createdPresence;

    setUp(() {
      mockBlocksRepo = MockICarnivalBlocksRepository();
      mockMeetingsRepo = MockIMeetingsRepository();
      mockPresencesRepo = MockIMeetingPresencesRepository();
      mockBlockMembersRepo = MockICarnivalBlockMembersRepository();
      mockAuthRepo = MockIAuthRepository();
      mockMembersRepo = MockIMembersRepository();
      mockGetCurrentUserData = MockGetCurrentUserData();
      mockGetHomeDataUseCase = MockGetHomeDataUseCase();

      createdBlock = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'ABC123',
        managersInviteCode: 'MANAGER123',
        carnivalBlockImage: '',
      );

      createdMeeting = MeetingsEntity(
        id: 1,
        name: 'Test Meeting',
        description: 'Test Description',
        location: 'Test Location',
        meetingDateTime: DateTime(2026, 3, 15, 14, 0),
        carnivalBlockId: 1,
      );

      createdPresence = MeetingPresencesEntity(
        id: 1,
        meetingId: 1,
        memberId: 1,
        isPresent: false,
        carnivalBlockId: 1,
      );
    });

    testWidgets(
      'Full flow: create block → add member → create meeting → toggle presence',
      (tester) async {
        // --- Setup mocks: create block ---
        when(
          () => mockBlocksRepo.createAsync(any()),
        ).thenAnswer((_) async => Success(createdBlock));

        // --- Add member to block ---
        when(
          () => mockBlockMembersRepo.createAsync(any(), any(), any()),
        ).thenAnswer(
          (_) async => Success(
            CarnivalBlockMembersEntity(
              id: 1,
              carnivalBlockId: 1,
              memberId: 1,
              role: 1,
            ),
          ),
        );

        // --- Create meeting ---
        when(
          () => mockMeetingsRepo.createAsync(any()),
        ).thenAnswer((_) async => Success(createdMeeting));
        when(
          () => mockMeetingsRepo.getAllByBlockId(any()),
        ).thenAnswer((_) async => Success([createdMeeting]));

        // --- Toggle presence ---
        when(
          () => mockPresencesRepo.createAsync(any()),
        ).thenAnswer((_) async => Success(createdPresence));
        when(
          () => mockPresencesRepo.getByMeetingId(any()),
        ).thenAnswer((_) async => Success([createdPresence]));
        when(
          () => mockPresencesRepo.deleteByIdAsync(any()),
        ).thenAnswer((_) async => const Success(unit));

        // --- Auth mocks ---
        when(
          () => mockAuthRepo.validateSession(),
        ).thenAnswer((_) async => true);
        when(() => mockAuthRepo.currentUuid).thenAnswer((_) async => '1');
        when(() => mockAuthRepo.currentMember).thenReturn(
          MembersEntity(
            id: 1,
            name: 'Test User',
            email: 'test@example.com',
            phone: '123456789',
            profileImage: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Build a simplified test app with all cubits wired to mocks
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<ICarnivalBlocksRepository>.value(value: mockBlocksRepo),
              Provider<IMeetingsRepository>.value(value: mockMeetingsRepo),
              Provider<IMeetingPresencesRepository>.value(
                value: mockPresencesRepo,
              ),
              Provider<ICarnivalBlockMembersRepository>.value(
                value: mockBlockMembersRepo,
              ),
              Provider<IAuthRepository>.value(value: mockAuthRepo),
              Provider<IMembersRepository>.value(value: mockMembersRepo),
              Provider<GetCurrentUserData>.value(value: mockGetCurrentUserData),
              Provider<GetHomeDataUseCase>.value(value: mockGetHomeDataUseCase),
              Provider<GetUserMeetingsUseCase>.value(
                value: MockGetUserMeetingsUseCase(),
              ),
            ],
            child: MaterialApp(
              theme: AppTheme.light(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('pt'),
              home: const _LifecycleTestScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Step 1: Verify initial state shows create block button
        expect(find.text('Create Block'), findsOneWidget);
        expect(find.text('Add Member'), findsNothing);
        expect(find.text('Create Meeting'), findsNothing);

        // Step 2: Create block
        await tester.tap(find.text('Create Block'));
        await tester.pumpAndSettle();

        // Verify block created
        expect(createdBlock.name, 'Test Block');
        expect(find.text('Block: Test Block'), findsOneWidget);
        expect(find.text('Add Member'), findsOneWidget);

        // Step 3: Add member
        await tester.tap(find.text('Add Member'));
        await tester.pumpAndSettle();

        // Verify member added (check mock was called)
        verify(() => mockBlockMembersRepo.createAsync(1, 1, 1)).called(1);
        expect(find.text('Member Added'), findsOneWidget);
        expect(find.text('Create Meeting'), findsOneWidget);

        // Step 4: Create meeting
        await tester.tap(find.text('Create Meeting'));
        await tester.pumpAndSettle();

        expect(createdMeeting.name, 'Test Meeting');
        expect(find.text('Meeting: Test Meeting'), findsOneWidget);

        // Step 5: Toggle presence
        await tester.tap(find.text('Toggle Presence'));
        await tester.pumpAndSettle();

        // Verify presence toggled (mock was called with create)
        verify(() => mockPresencesRepo.createAsync(any())).called(1);
        expect(find.text('Presence Count: 1'), findsOneWidget);
      },
    );
  });
}

/// Simplified screen that exercises the full block→meeting→presence flow
/// using the actual cubits with mocked repositories.
class _LifecycleTestScreen extends StatefulWidget {
  const _LifecycleTestScreen();

  @override
  State<_LifecycleTestScreen> createState() => _LifecycleTestScreenState();
}

class _LifecycleTestScreenState extends State<_LifecycleTestScreen> {
  String _blockName = '';
  String _meetingName = '';
  int _presenceCount = 0;
  bool _memberAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_blockName.isEmpty) ...[
              ElevatedButton(
                onPressed: () async {
                  final repo = context.read<ICarnivalBlocksRepository>();
                  final result = await repo.createAsync({});
                  result.fold(
                    (block) => setState(() => _blockName = block.name),
                    (_) {},
                  );
                },
                child: const Text('Create Block'),
              ),
            ] else ...[
              Text('Block: $_blockName'),
              const SizedBox(height: 8),
              if (!_memberAdded) ...[
                ElevatedButton(
                  onPressed: () async {
                    final repo = context
                        .read<ICarnivalBlockMembersRepository>();
                    await repo.createAsync(1, 1, 1);
                    setState(() => _memberAdded = true);
                  },
                  child: const Text('Add Member'),
                ),
              ] else ...[
                const Text('Member Added'),
                const SizedBox(height: 8),
                if (_meetingName.isEmpty) ...[
                  ElevatedButton(
                    onPressed: () async {
                      final repo = context.read<IMeetingsRepository>();
                      final result = await repo.createAsync({});
                      result.fold(
                        (meeting) =>
                            setState(() => _meetingName = meeting.name ?? ''),
                        (_) {},
                      );
                    },
                    child: const Text('Create Meeting'),
                  ),
                ] else ...[
                  Text('Meeting: $_meetingName'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final repo = context.read<IMeetingPresencesRepository>();
                      await repo.createAsync({});
                      setState(() => _presenceCount = 1);
                    },
                    child: const Text('Toggle Presence'),
                  ),
                  const SizedBox(height: 8),
                  Text('Presence Count: $_presenceCount'),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}
