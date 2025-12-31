import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeetingDetailsScreen extends StatelessWidget {
  const MeetingDetailsScreen({
    super.key,
    required this.meetingId,
  });

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeetingDetailsCubit, MeetingDetailsState>(
      listener: (context, state) {
        if (state is MeetingDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is MeetingDetailsInitial) {
          context.read<MeetingDetailsCubit>().loadMeeting();
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MeetingDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MeetingDetailsError) {
          return Center(child: Text(state.message));
        }

        if (state is MeetingDetailsLoaded) {
          final meeting = state.meeting;
          return AlertDialog.adaptive(
            title: Text(meeting.name ?? ""),
            content: Text(meeting.description ?? ""),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        }

        return const Center(child: Text('Nenhum dado encontrado'));
      },
    );
  }
}
