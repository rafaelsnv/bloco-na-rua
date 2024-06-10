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
      final document = await carnivalBlock.add({
        'name': name,
        'owner': owner,
      });

      document.id;
      final docSnap = await document.get();
      final data = docSnap.data()!;
      final carnivalBlockEntity =
          CarnivalBlockAdapter.fromFireStoreRepository(data);

      return CreatedCarnivalBlockState(carnivalBlock: carnivalBlockEntity);
    } catch (e) {
      return const FailedCarnivalBlockState();
    }
  }

  @override
  Future<CarnivalBlockState> deleteCarnivalBlock() {
    // TODO: implement deleteCarnivalBlock
    throw UnimplementedError();
  }

  @override
  Future<CarnivalBlockState> getCarnivalBlock(
    String email,
  ) async {
    late CarnivalBlockEntity carnivalBlockEntity;

    final carnivalBlock = _carnivalBlockCollection;
    final querySnapshot =
        await carnivalBlock.where('owner', isEqualTo: email).get();

    for (final queryDocumentSnapshot in querySnapshot.docs) {
      final data = queryDocumentSnapshot.data();
      carnivalBlockEntity = CarnivalBlockAdapter.fromFireStoreRepository(data);
      return CreatedCarnivalBlockState(carnivalBlock: carnivalBlockEntity);
    }

    return CreatedCarnivalBlockState(carnivalBlock: carnivalBlockEntity);
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
}
