import "package:bloco_na_rua/core/date_format.dart";
import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_state.dart";
import "package:bloco_na_rua/ui/meetings/meeting_error.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_date_time_field.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  /// Fields the user has already edited.
  ///
  /// Only these may paint an error before the first submit attempt — a
  /// pristine field the user never touched stays neutral.
  bool _titleTouched = false;
  bool _locationTouched = false;

  /// True once the user tried to submit.
  ///
  /// From then on every invalid field shows its error, and the form is
  /// re-validated on every edit so the errors stay in sync.
  bool _submitAttempted = false;

  /// Error message for the title field, or null when the value is valid.
  String? _titleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.meetingsTitleRequired;
    }
    return null;
  }

  /// Error message for the location field, or null when the value is valid.
  ///
  /// The description is deliberately absent: it is optional, exactly as its
  /// hint says.
  String? _locationValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.meetingsLocationRequired;
    }
    return null;
  }

  /// Error shown under the date picker, or null when the date is picked.
  String? get _dateError {
    if (_submitAttempted && _selectedDate == null) {
      return AppLocalizations.of(context)!.meetingsSelectDate;
    }
    return null;
  }

  /// Error shown under the time picker, or null when the time is picked.
  String? get _timeError {
    if (_submitAttempted && _selectedTime == null) {
      return AppLocalizations.of(context)!.meetingsSelectTime;
    }
    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = initialDate;
    final lastDate = initialDate.add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedDate = picked;
      _dateController.text = formatShortDate(picked, context);
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedTime = picked;
      _timeController.text = picked.format(context);
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

  void _onLocationChanged(String _) {
    setState(() => _locationTouched = true);
    _syncForm();
  }

  void _submitForm(BuildContext context) {
    setState(() => _submitAttempted = true);
    // Field errors are reported inline, below the field that owns them.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      // The pickers above are the only way to set these and both are
      // required — their inline errors are already painted by the submit
      // attempt.
      return;
    }

    final carnivalBlockId = int.tryParse(widget.carnivalBlockId);
    if (carnivalBlockId == null || carnivalBlockId <= 0) {
      AppSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.meetingsInvalidBlockId,
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final data = <String, dynamic>{
      "name": _titleController.text.trim(),
      // The description is optional — an empty one is a valid meeting.
      "description": _descriptionController.text.trim(),
      "location": _locationController.text.trim(),
      // API field is `meetingDateTime` (see MeetingCreate in swagger) — the
      // old `dateTime` key was silently dropped server-side, storing the
      // .NET default (1900-01-01 00:00).
      "meetingDateTime": dateTime.toIso8601String(),
      "carnivalBlockId": carnivalBlockId,
    };

    context.read<CreateMeetingCubit>().createMeeting(data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateMeetingCubit(
        meetingsRepository: context.read<IMeetingsRepository>(),
      ),
      child: BlocConsumer<CreateMeetingCubit, CreateMeetingState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state.status == CreateMeetingStatus.success) {
            context.read<UserMeetingsCubit>().loadMeetings();
            context.read<HomeCubit>().loadHomeData();
            AppSnackbar.success(context, message: l10n.meetingsCreateSuccess);
            context.pop();
          } else if (state.status == CreateMeetingStatus.failure) {
            final message = state.error != null
                ? localizeMeetingError(context, state.error!)
                : l10n.meetingsCreateError;
            AppSnackbar.error(context, message: message);
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final isLoading = state.status == CreateMeetingStatus.loading;

          return Scaffold(
            appBar: AppAppBar(
              title: l10n.meetingsCreateTitle,
              showBackButton: true,
            ),
            body: SafeArea(
              child: ContentWidthLimiter(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.pagePaddingFor(context),
                      vertical: Spacing.pagePaddingMobile,
                    ),
                    child: AppCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _titleController,
                              label: l10n.meetingsTitleLabel,
                              hint: l10n.meetingsTitleHint,
                              textInputAction: TextInputAction.next,
                              validator: _titleValidator,
                              errorText: _titleTouched
                                  ? _titleValidator(_titleController.text)
                                  : null,
                              onChanged: _onTitleChanged,
                            ),
                            const SizedBox(height: Spacing.space_md),
                            AppTextField(
                              controller: _descriptionController,
                              label: l10n.meetingsDescriptionLabel,
                              hint: l10n.meetingsDescriptionHint,
                              isMultiline: true,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: Spacing.space_md),
                            Row(
                              children: [
                                Expanded(
                                  child: AppDateTimeField(
                                    label: l10n.meetingsDateLabel,
                                    hint: l10n.meetingsSelectHint,
                                    semanticsLabel:
                                        l10n.meetingsSelectDateSemantics,
                                    controller: _dateController,
                                    errorText: _dateError,
                                    suffixIcon: Icons.calendar_today_rounded,
                                    onTap: () => _selectDate(context),
                                  ),
                                ),
                                const SizedBox(width: Spacing.space_sm),
                                Expanded(
                                  child: AppDateTimeField(
                                    label: l10n.meetingsTimeLabel,
                                    hint: l10n.meetingsSelectHint,
                                    semanticsLabel:
                                        l10n.meetingsSelectTimeSemantics,
                                    controller: _timeController,
                                    errorText: _timeError,
                                    suffixIcon: Icons.access_time_rounded,
                                    onTap: () => _selectTime(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.space_md),
                            AppTextField(
                              controller: _locationController,
                              label: l10n.meetingsLocationLabel,
                              hint: l10n.meetingsLocationHint,
                              textInputAction: TextInputAction.done,
                              validator: _locationValidator,
                              errorText: _locationTouched
                                  ? _locationValidator(_locationController.text)
                                  : null,
                              onChanged: _onLocationChanged,
                            ),
                            const SizedBox(height: Spacing.space_lg),
                            AppButton(
                              label: l10n.meetingsCreateButton,
                              variant: AppButtonVariant.primary,
                              isFullWidth: true,
                              isLoading: isLoading,
                              // The CTA is never a dead end: an invalid form is
                              // reported inline when the user submits, instead
                              // of a button that never becomes tappable.
                              isDisabled: isLoading,
                              onPressed: () => _submitForm(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
