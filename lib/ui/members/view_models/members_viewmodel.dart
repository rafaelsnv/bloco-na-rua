import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:flutter/foundation.dart';

class MembersViewModel extends ChangeNotifier {
  MembersViewModel({required IMembersRepository membersRepository})
    : _membersRepository = membersRepository;

  final IMembersRepository _membersRepository;

  List<MembersEntity> _members = [];
  List<MembersEntity> get members => _members;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> onInit() async {
    await loadMembers();
  }

  Future<void> loadMembers() async {
    _isLoading = true;
    notifyListeners();

    final result = await _membersRepository.getAllAsync();
    result.fold(
      (success) => _members = success,
      (failure) => debugPrint(failure.toString()),
    );

    _isLoading = false;
    notifyListeners();
  }
}
