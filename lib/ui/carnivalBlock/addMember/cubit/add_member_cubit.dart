import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit({
    required IMembersRepository membersRepository,
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
  }) : _membersRepository = membersRepository,
       _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       super(const AddMemberState());

  final IMembersRepository _membersRepository;
  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;

  Future<void> loadMembers() async {
    emit(state.copyWith(status: AddMemberStatus.loading));

    final result = await _membersRepository.getAllAsync();

    result.fold(
      (members) {
        emit(
          state.copyWith(
            status: AddMemberStatus.initial,
            allMembers: members,
            filteredMembers: members,
          ),
        );
      },
      (failure) {
        emit(
          state.copyWith(
            status: AddMemberStatus.error,
            errorMessage: extractUserMessage(failure),
          ),
        );
      },
    );
  }

  void searchMembers(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredMembers: state.allMembers));
    } else {
      final lowercaseQuery = query.toLowerCase();
      final filtered = state.allMembers.where((member) {
        final name = member.name?.toLowerCase() ?? '';
        final email = member.email?.toLowerCase() ?? '';
        return name.contains(lowercaseQuery) || email.contains(lowercaseQuery);
      }).toList();

      emit(state.copyWith(searchQuery: query, filteredMembers: filtered));
    }
  }

  Future<void> addMember(int memberId, int carnivalBlockId) async {
    emit(state.copyWith(status: AddMemberStatus.loading));

    final result = await _carnivalBlockMembersRepository.createAsync(
      carnivalBlockId,
      memberId,
      0,
    );

    result.fold(
      (_) {
        emit(state.copyWith(status: AddMemberStatus.success));
      },
      (failure) {
        emit(
          state.copyWith(
            status: AddMemberStatus.error,
            errorMessage: extractUserMessage(failure),
          ),
        );
      },
    );
  }
}
