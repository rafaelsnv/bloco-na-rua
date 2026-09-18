import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockICarnivalBlocksRepository extends Mock
    implements ICarnivalBlocksRepository {}

void main() {
  late MockICarnivalBlocksRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockRepository = MockICarnivalBlocksRepository();
  });

  group('EditBlockCubit', () {
    test('emits loading then loaded when loadBlock succeeds', () async {
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'INV123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'image.png',
      );

      when(() => mockRepository.getByIdAsync(1))
          .thenAnswer((_) async => Success(block));

      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: '1',
      );

      // Wait for load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<EditBlockLoaded>());
      expect(
        (cubit.state as EditBlockLoaded).name,
        equals('Test Block'),
      );
    });

    test('emits loading then error when loadBlock fails with invalid id',
        () async {
      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: 'invalid',
      );

      // Wait for load to fail
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<EditBlockError>());
    });

    test('emits saving then success when updateBlock succeeds after load', () async {
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'INV123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'image.png',
      );

      when(() => mockRepository.getByIdAsync(1))
          .thenAnswer((_) async => Success(block));
      when(() => mockRepository.updateAsync(any(), any()))
          .thenAnswer((_) async => Success(block));

      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: '1',
      );

      // Wait for load to complete
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<EditBlockLoaded>());

      final states = <EditBlockState>[];
      cubit.stream.listen(states.add);

      await cubit.updateBlock(
        name: 'Updated Block',
        carnivalBlockImage: 'new_image.png',
      );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, [
        isA<EditBlockSaving>(),
        isA<EditBlockSuccess>(),
      ]);
    });

    test('emits saving then error when updateBlock fails', () async {
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'INV123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'image.png',
      );

      when(() => mockRepository.getByIdAsync(1))
          .thenAnswer((_) async => Success(block));
      when(() => mockRepository.updateAsync(any(), any()))
          .thenAnswer((_) async => Failure(Exception('Update failed')));

      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: '1',
      );

      // Wait for load to complete
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<EditBlockLoaded>());

      final states = <EditBlockState>[];
      cubit.stream.listen(states.add);

      await cubit.updateBlock(
        name: 'Updated Block',
        carnivalBlockImage: 'new_image.png',
      );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, [
        isA<EditBlockSaving>(),
        isA<EditBlockError>(),
      ]);
    });

    test('emits deleting then deleted when deleteBlock succeeds', () async {
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'INV123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'image.png',
      );

      when(() => mockRepository.getByIdAsync(1))
          .thenAnswer((_) async => Success(block));
      when(() => mockRepository.deleteByIdAsync(1))
          .thenAnswer((_) async => Success.unit());

      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: '1',
      );

      // Wait for load to complete
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<EditBlockLoaded>());

      final states = <EditBlockState>[];
      cubit.stream.listen(states.add);

      await cubit.deleteBlock();

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, [
        isA<EditBlockDeleting>(),
        isA<EditBlockDeleted>(),
      ]);
    });

    test('emits deleting then error when deleteBlock fails', () async {
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Test Block',
        inviteCode: 'INV123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'image.png',
      );

      when(() => mockRepository.getByIdAsync(1))
          .thenAnswer((_) async => Success(block));
      when(() => mockRepository.deleteByIdAsync(1))
          .thenAnswer((_) async => Failure(Exception('Delete failed')));

      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: '1',
      );

      // Wait for load to complete
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<EditBlockLoaded>());

      final states = <EditBlockState>[];
      cubit.stream.listen(states.add);

      await cubit.deleteBlock();

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, [
        isA<EditBlockDeleting>(),
        isA<EditBlockError>(),
      ]);
    });

    test('deleteBlock does nothing when state is not loaded', () async {
      final cubit = EditBlockCubit(
        carnivalBlocksRepository: mockRepository,
        carnivalBlockId: 'invalid',
      );

      // Wait for load to fail
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<EditBlockError>());

      final states = <EditBlockState>[];
      cubit.stream.listen(states.add);

      await cubit.deleteBlock();

      await Future.delayed(const Duration(milliseconds: 50));

      // No new states emitted because state is not Loaded
      expect(states, isEmpty);
    });
  });
}
