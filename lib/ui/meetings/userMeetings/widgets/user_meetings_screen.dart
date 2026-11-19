import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_search_field.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/meetings/meeting_error.dart";
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
  void initState() {
    super.initState();
    context.read<UserMeetingsCubit>().loadMeetings();
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = Spacing.pagePaddingFor(context);

    return BlocListener<UserMeetingsCubit, UserMeetingsState>(
      listenWhen: (previous, current) =>
          current.status == UserMeetingsStatus.failure &&
          previous.status != UserMeetingsStatus.failure,
      listener: (context, state) {
        if (state.error != null) {
          AppSnackbar.error(
            context,
            message: localizeMeetingError(context, state.error!),
          );
        }
      },
      child: Scaffold(
        appBar: AppAppBar(
          title: AppLocalizations.of(context)!.meetingsListTitle,
          showBackButton: false,
        ),
        body: SafeArea(
          child: ContentWidthLimiter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: pagePadding,
                    vertical: Spacing.space_sm,
                  ),
                  child: AppSearchField(
                    hint: AppLocalizations.of(context)!.meetingsSearchHint,
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
                          message: state.error != null
                              ? localizeMeetingError(context, state.error!)
                              : null,
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
                        final l10n = AppLocalizations.of(context)!;
                        if (allMeetings.isEmpty) {
                          return AppEmpty(
                            title: l10n.meetingsNoMeetingTitle,
                            message: l10n.meetingsNoMeetingMessage,
                            icon: Icons.event_busy_rounded,
                          );
                        }
                        return AppEmpty(
                          title: l10n.meetingsNoMeetingFoundTitle,
                          message: l10n.meetingsNoMeetingFoundMessage,
                          icon: Icons.search_off_rounded,
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<UserMeetingsCubit>()
                              .loadMeetings();
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: pagePadding,
                          ),
                          itemCount: filteredMeetings.length,
                          itemBuilder: (context, index) {
                            final meeting = filteredMeetings[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Spacing.space_xs,
                              ),
                              child: MeetingCard(
                                meeting: meeting,
                                onTap: () {
                                  context.push(
                                    "${Routes.meeting}/${meeting.id}",
                                  );
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
      ),
    );
  }
}
