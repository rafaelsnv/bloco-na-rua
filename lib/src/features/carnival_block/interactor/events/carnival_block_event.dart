import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';

sealed class CarnivalBlockEvent {}

class LoadCarnivalBlockEvent implements CarnivalBlockEvent {
  final String email;

  LoadCarnivalBlockEvent({
    required this.email,
  });
}

class InviteCarnivalBlockEvent implements CarnivalBlockEvent {
  final CarnivalBlockEntity carnivalBlock;

  InviteCarnivalBlockEvent({
    required this.carnivalBlock,
  });
}

class JoinCarnivalBlockEvent implements CarnivalBlockEvent {
  final String blockCode;
  final String sessionEmail;

  JoinCarnivalBlockEvent({
    required this.blockCode,
    required this.sessionEmail,
  });
}

class CreateCarnivalBlockEvent implements CarnivalBlockEvent {
  final int id;
  final String name;
  final String owner;

  CreateCarnivalBlockEvent({
    required this.id,
    required this.name,
    required this.owner,
  });
}

class DeleteCarnivalBlockEvent implements CarnivalBlockEvent {
  final CarnivalBlockEntity carnivalBlock;
  final String email;
  DeleteCarnivalBlockEvent({
    required this.carnivalBlock,
    required this.email,
  });
}
