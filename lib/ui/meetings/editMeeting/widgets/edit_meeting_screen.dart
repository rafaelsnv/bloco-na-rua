import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart";
import "package:bloco_na_rua/ui/meetings/meeting_error.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_date_time_field.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class EditMeetingScreen extends StatefulWidget {
  const EditMeetingScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateTimeController;

  DateTime _selectedDateTime = DateTime.now();
  bool _controllersInitialized = false;

  /// Fields the user has already edited.
  ///
  /// Only these may paint an error before the first submit attempt — a
  /// pristine field the user never touched stays neutral.
  bool _titleTouched = false;

  /// True once the user tried to submit.
  ///
  /// From then on every invalid field shows its error, and the form is
  /// re-validated on every edit so the errors stay in sync.
  bool _submitAttempted = false;

  /// Error message for the title field, or null when the value is valid.
  String? _titleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.meetingsEditTitleRequired;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _dateTimeController = TextEditingController();

    final meetingId = int.tryParse(widget.meetingId);
    if (meetingId != null) {
      context.read<EditMeetingCubit>().loadMeeting(meetingId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  void _initializeControllers(MeetingsEntity meeting) {
    if (_controllersInitialized) return;

    _titleController.text = meeting.name ?? "";
    _locationController.text = meeting.location ?? "";

    final dateTime = meeting.meetingDateTime;
    if (dateTime != null) {
      _selectedDateTime = dateTime;
    } else {
      _selectedDateTime = DateTime.now();
    }

    _updateDateTimeController();

    _controllersInitialized = true;
  }

  void _updateDateTimeController() {
    // The field is labelled "Data e hora", so it paints both — the old code
    // only ever showed the date and kept the time in a hidden controller.
    _dateTimeController.text = formatShortDateTime(_selectedDateTime, context);
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _updateDateTimeController();
    });
  }

  /// Keeps the painted error states in sync after an edit.
  void _syncForm() {
    if (_submitAttempted) {
      // After a submit attempt every invalid field shows its error, so the
      // whole form has to be re-validated on every edit.
      _formKey.currentState?.validate();
    }
  }

  void _onTitleChanged(String _) {
    setState(() => _titleTouched = true);
    _syncForm();
  }

  void _submitForm() {
    setState(() => _submitAttempted = true);
    // Field errors are reported inline, below the field that owns them.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final meetingId = int.tryParse(widget.meetingId);
    if (meetingId == null) {
      AppSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.meetingsInvalidMeetingId,
      );
      return;
    }

    final title = _titleController.text.trim();

    // ISO 8601 with 'T' separator — System.Text.Json rejects the
    // space-separated "yyyy-MM-dd HH:mm:ss" format.
    final formattedDateTime = _selectedDateTime.toIso8601String();

    final data = <String, dynamic>{
      "name": title,
      if (_locationController.text.isNotEmpty)
        "location": _locationController.text,
      "meetingDateTime": formattedDateTime,
    };

    context.read<EditMeetingCubit>().updateMeeting(meetingId, data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditMeetingCubit, EditMeetingState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state.status == EditMeetingStatus.success) {
          context.read<UserMeetingsCubit>().loadMeetings();
          context.read<HomeCubit>().loadHomeData();
          try {
            context.read<MeetingDetailsCubit>().loadMeeting();
          } catch (_) {}
          AppSnackbar.success(context, message: l10n.meetingsUpdateSuccess);
          if (!mounted) return;
          context.pop();
        } else if (state.status == EditMeetingStatus.failure &&
            state.error != null) {
          AppSnackbar.error(
            context,
            message: localizeMeetingError(context, state.error!),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state.status == EditMeetingStatus.initial) {
          final meetingId = int.tryParse(widget.meetingId);
          if (meetingId == null) {
            return Scaffold(
              appBar: AppAppBar(title: l10n.meetingsEditTitle),
              body: AppError(message: l10n.meetingsInvalidMeetingId),
            );
          }
          return Scaffold(
            appBar: AppAppBar(title: l10n.meetingsEditTitle),
            body: const AppLoading(),
          );
        }

        if (state.status == EditMeetingStatus.loading) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.meetingsEditTitle),
            body: const AppLoading(),
          );
        }

        if (state.status == EditMeetingStatus.failure &&
            state.meeting == null) {
          return Scaffold(
            appBar: AppAppBar(title: l10n.meetingsEditTitle),
            body: AppError(
              message: state.error != null
                  ? localizeMeetingError(context, state.error!)
                  : l10n.meetingsUnknownError,
              onRetry: () {
                final meetingId = int.tryParse(widget.meetingId);
                if (meetingId != null) {
                  context.read<EditMeetingCubit>().loadMeeting(meetingId);
                }
              },
            ),
          );
        }

        // EditMeetingLoaded
        _initializeControllers(state.meeting!);

        final isSaving = state.status == EditMeetingStatus.saving;

        return Scaffold(
          appBar: AppAppBar(title: l10n.meetingsEditTitle),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Spacing.pagePaddingMobile),
            child: AppCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: l10n.meetingsTitleLabel,
                      controller: _titleController,
                      validator: _titleValidator,
                      errorText: _titleTouched
                          ? _titleValidator(_titleController.text)
                          : null,
                      onChanged: _onTitleChanged,
                    ),
                    const SizedBox(height: Spacing.space_sm),
                    AppDateTimeField(
                      label: l10n.meetingsDateTimeLabel,
                      semanticsLabel: l10n.meetingsSelectDateTimeSemantics,
                      controller: _dateTimeController,
                      suffixIcon: Icons.event_rounded,
                      onTap: _pickDateTime,
                    ),
                    const SizedBox(height: Spacing.space_sm),
                    AppTextField(
                      label: l10n.meetingsLocationLabel,
                      controller: _locationController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: Spacing.space_md),
                    AppButton(
                      label: l10n.meetingsSaveButton,
                      isFullWidth: true,
                      isLoading: isSaving,
                      isDisabled: isSaving,
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
