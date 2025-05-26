import 'package:bloco_na_rua/src/features/carnival_block/data/adapters/carnival_block_adapter.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/repositories/icarnival_block_repository.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCarnivalBlockRepository implements ICarnivalBlockRepository {
  final FirebaseFirestore firestoreRepository;

  const FirestoreCarnivalBlockRepository({required this.firestoreRepository});

  CollectionReference<Map<String, dynamic>> get _carnivalBlockCollection {
    return firestoreRepository.collection('CarnivalBlock');
  }

  @override
  Future<CarnivalBlockState> createCarnivalBlock(
    int id,
    String name,
    String owner,
  ) async {
    try {
      final carnivalBlock = _carnivalBlockCollection;
      final document = carnivalBlock.doc(name);

      final nameCode = name.toLowerCase().replaceAll(' ', '_');
      final managerCode = 'managers_code:$nameCode';
      final inviteCode = 'invite_code:$nameCode';

      await document.set({
        'managers_code': managerCode,
        'invite_code': inviteCode,
        'name': name,
        'owner': owner,
        'managers': [
          {
            'email': owner,
          }
        ],
        'percussion': [],
        'meetings': [],
      });

      final docSnap = await document.get();
      final data = docSnap.data()!;
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);

      return CreatedCarnivalBlockState(carnivalBlock: carnivalBlockEntity);
    } catch (e) {
      return const FailedCarnivalBlockState(
        'Erro ao criar bloco',
      );
    }
  }

  @override
  Future<String> getInviteCode(
    CarnivalBlockEntity carnivalBlock,
  ) async {
    final docData = await _getCarnivalDocData(blockName: carnivalBlock.name);
    final inviteCode = docData['invite_code'];
    return inviteCode;
  }

  Future<Map<String, dynamic>> _getCarnivalDocData({required blockName}) async {
    final blockDoc = _carnivalBlockCollection.doc(blockName);
    final docSnap = await blockDoc.get();
    final docData = docSnap.data()!;
    return docData;
  }

  @override
  Future<CarnivalBlockState> deleteCarnivalBlock(
    String email,
    CarnivalBlockEntity carnivalBlock,
  ) async {
    final blockDoc = _carnivalBlockCollection.doc(carnivalBlock.name);
    final docSnap = await blockDoc.get();
    final docData = docSnap.data()!;

    if (docData['owner'] != email) {
      return const FailedCarnivalBlockState(
        'Você não tem permissão para excluir esse bloco',
      );
    }

    try {
      await blockDoc.delete();
    } catch (e) {
      return const FailedCarnivalBlockState(
        'Erro ao excluir bloco',
      );
    }
    return const DeletedCarnivalBlockState();
  }

  @override
  Future<List<CarnivalBlockEntity>> getCarnivalBlocksList(
    String email,
  ) async {
    final blockList = await _getOwnerBlocks(email)
      ..addAll(await _getManagersBlocks(email))
      ..addAll(await _getPercussionBlocks(email));

    return blockList.toSet().toList();
  }

  Future<List<CarnivalBlockEntity>> _getOwnerBlocks(
    String email,
  ) async {
    final carnivalBlock = _carnivalBlockCollection;
    final querySnapshot =
        await carnivalBlock.where('owner', isEqualTo: email).get();

    final blockList = List<CarnivalBlockEntity>.empty(growable: true);
    for (final queryDocumentSnapshot in querySnapshot.docs) {
      final data = queryDocumentSnapshot.data();
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);
      blockList.add(carnivalBlockEntity);
    }

    return blockList;
  }

  Future<List<CarnivalBlockEntity>> _getManagersBlocks(
    String email,
  ) async {
    final object = {
      'email': email,
    };
    final carnivalBlock = _carnivalBlockCollection;
    final querySnapshot =
        await carnivalBlock.where('managers', arrayContains: object).get();

    final blockList = List<CarnivalBlockEntity>.empty(growable: true);
    for (final queryDocumentSnapshot in querySnapshot.docs) {
      final data = queryDocumentSnapshot.data();
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);
      blockList.add(carnivalBlockEntity);
    }

    return blockList;
  }

  Future<List<CarnivalBlockEntity>> _getPercussionBlocks(
    String email,
  ) async {
    final object = {
      'email': email,
    };
    final carnivalBlock = _carnivalBlockCollection;
    final querySnapshot =
        await carnivalBlock.where('percussion', arrayContains: object).get();

    final blockList = List<CarnivalBlockEntity>.empty(growable: true);
    for (final queryDocumentSnapshot in querySnapshot.docs) {
      final data = queryDocumentSnapshot.data();
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);
      blockList.add(carnivalBlockEntity);
    }

    return blockList;
  }

  @override
  Future<CarnivalBlockState> updateCarnivalBlock(
    String id,
    String name,
    String owner,
  ) async {
    final carnivalBlock = _carnivalBlockCollection;

    final document = carnivalBlock.doc(id);
    await document.update({
      'name': name,
      'owner': owner,
    });

    final docSnap = await document.get();
    final data = docSnap.data()!;
    final carnivalBlockEntity =
        CarnivalBlockAdapter.fromFireStoreRepository(data);

    return UpdatedCarnivalBlockState(carnivalBlock: carnivalBlockEntity);
  }

  @override
  Future<CarnivalBlockState> joinCarnivalBlock(
    String code,
    String email,
  ) async {
    final managersBlockList = await _getBlocksFromCode('managers', code);

    if (managersBlockList.isNotEmpty) {
      for (final managerBlock in managersBlockList) {
        final doc = _carnivalBlockCollection.doc(managerBlock.name);
        managerBlock.managers.add({
          'email': email,
        });
        await doc.update(
          {
            'managers': managerBlock.managers,
          },
        );
      }
    }

    final percussionBlockList = await _getBlocksFromCode('invite', code);
    if (percussionBlockList.isNotEmpty) {
      for (final percussionBlock in percussionBlockList) {
        percussionBlock.percussion.add({
          'email': email,
        });
        final doc = _carnivalBlockCollection.doc(percussionBlock.name);
        await doc.update(
          {
            'percussion': percussionBlock.percussion,
          },
        );
      }
    }

    final blockList = List<CarnivalBlockEntity>.from(managersBlockList)
      ..addAll(percussionBlockList);

    return LoadedCarnivalBlockState(
      blockList: blockList,
      sessionEmail: email,
    );
  }

  Future<List<CarnivalBlockEntity>> _getBlocksFromCode(
    String section,
    String code,
  ) async {
    final carnivalBlock = _carnivalBlockCollection;
    final querySnapshot =
        await carnivalBlock.where('${section}_code', isEqualTo: code).get();

    final blockList = List<CarnivalBlockEntity>.empty(growable: true);
    for (final queryDocumentSnapshot in querySnapshot.docs) {
      final data = queryDocumentSnapshot.data();
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);
      blockList.add(carnivalBlockEntity);
    }

    return blockList;
  }
}
