import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserMeetingsScreen extends StatelessWidget {
  const UserMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserMeetingsCubit, UserMeetingsState>(
      listenWhen: (previous, current) =>
          current.status == UserMeetingsStatus.failure &&
          previous.status != UserMeetingsStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Meus Encontros')),
        body: SafeArea(
          child: BlocBuilder<UserMeetingsCubit, UserMeetingsState>(
            builder: (context, state) {
              if (state.status == UserMeetingsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == UserMeetingsStatus.failure &&
                  state.meetings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Erro ao carregar encontros'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed:
                            () => context.read<UserMeetingsCubit>().loadMeetings(),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              }

              final meetings = state.meetings;
              if (meetings.isEmpty) {
                return const Center(child: Text('Nenhum encontro encontrado'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetings[index];
                  var meetingDateTime = DateTime.parse(
                    meeting.meetingDateTime ?? '',
                  );

                  return Card(
                    child: ListTile(
                      leading: Text(
                        DateFormat.E('pt_BR').format(meetingDateTime),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      title: Text(
                        meeting.name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        meeting.location ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Text(
                        DateFormat(
                          'dd/MM/yy HH:mm',
                          'pt_BR',
                        ).format(meetingDateTime),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        context.push('${Routes.meeting}/${meeting.id}');
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
