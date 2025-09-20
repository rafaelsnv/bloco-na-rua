import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required IMembersRepository membersRepository})
    : _membersRepository = membersRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();
  }

  final IMembersRepository _membersRepository;
  final _log = Logger('HomeViewModel');

  late Command load;

  AsyncResult<void> _load() async {
    try {
      final membersList = await _membersRepository.getAllAsync();
      return membersList;
    } finally {
      notifyListeners();
    }
  }
}
