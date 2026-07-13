// lib/ui/meetings/userMeetings/widgets/user_meetings_screen.dart
//
// User meetings screen for the Bloco na Rua app.
//
// Displays a list of meetings assigned to the current user with search
// filtering, pull-to-refresh, and navigation to meeting details.
// Uses the design system for all UI primitives: AppAppBar, MeetingCard,
// AppLoading, AppError, AppEmpty, AppSearchField, and AppSnackbar.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_state.dart";

class UserMeetingsScreen extends StatefulWidget {
  const UserMeetingsScreen({super.key});

  @override
  State<UserMeetingsScreen> createState() => _UserMeetingsScreenState();
}

class _UserMeetingsScreenState extends State<UserMeetingsScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserMeetingsCubit, UserMeetingsState>(
      listenWhen: (previous, current) =>
          current.status == UserMeetingsStatus.failure &&
          previous.status != UserMeetingsStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.error(context, message: state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppAppBar(title: "Reuniões", showBackButton: false),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Spacing.space_sm),
                child: AppSearchField(
                  hint: "Buscar reuniões...",
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<UserMeetingsCubit, UserMeetingsState>(
                  builder: (context, state) {
                    if (state.status == UserMeetingsStatus.loading) {
                      return const AppLoading();
                    }

                    if (state.status == UserMeetingsStatus.failure &&
                        state.meetings.isEmpty) {
                      return AppError(
                        message: state.errorMessage,
                        onRetry: () =>
                            context.read<UserMeetingsCubit>().loadMeetings(),
                      );
                    }

                    final allMeetings = state.meetings;
                    final filteredMeetings = _searchQuery.isEmpty
                        ? allMeetings
                        : allMeetings.where((meeting) {
                            final name = meeting.name?.toLowerCase() ?? "";
                            final location =
                                meeting.location?.toLowerCase() ?? "";
                            return name.contains(_searchQuery) ||
                                location.contains(_searchQuery);
                          }).toList();

                    if (filteredMeetings.isEmpty) {
                      if (allMeetings.isEmpty) {
                        return AppEmpty(
                          title: "Nenhuma reuniao",
                          message: "Você ainda não tem reuniões agendadas",
                          icon: Icons.event_busy_rounded,
                        );
                      }
                      return AppEmpty(
                        title: "Nenhuma reuniao encontrada",
                        message: "Tente buscar com outros termos",
                        icon: Icons.search_off_rounded,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<UserMeetingsCubit>().loadMeetings();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.space_sm,
                        ),
                        itemCount: filteredMeetings.length,
                        itemBuilder: (context, index) {
                          final meeting = filteredMeetings[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: Spacing.space_xs),
                            child: MeetingCard(
                              meeting: meeting,
                              onTap: () {
                                context.push("${Routes.meeting}/${meeting.id}");
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
