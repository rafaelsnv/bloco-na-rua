import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class EditMeetingScreen extends StatefulWidget {
  const EditMeetingScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  DateTime _selectedDateTime = DateTime.now();
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _initializeControllers(MeetingsEntity meeting) {
    if (_controllersInitialized) return;

    _titleController.text = meeting.name ?? "";
    _locationController.text = meeting.location ?? "";

    final dateTimeStr = meeting.meetingDateTime;
    if (dateTimeStr != null && dateTimeStr.isNotEmpty) {
      try {
        _selectedDateTime = DateTime.parse(dateTimeStr);
      } catch (_) {
        _selectedDateTime = DateTime.now();
      }
    } else {
      _selectedDateTime = DateTime.now();
    }

    _updateDateTimeControllers();

    _controllersInitialized = true;
  }

  void _updateDateTimeControllers() {
    final dateFormat = DateFormat.yMd("pt_BR");
    final timeFormat = DateFormat.Hm();

    _dateController.text = dateFormat.format(_selectedDateTime);
    _timeController.text = timeFormat.format(_selectedDateTime);
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
      _updateDateTimeControllers();
    });
  }

  void _submitForm() {
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final formattedDateTime = dateFormat.format(_selectedDateTime);

    final data = <String, dynamic>{
      if (_titleController.text.isNotEmpty) "name": _titleController.text,
      if (_locationController.text.isNotEmpty)
        "location": _locationController.text,
      "meetingDateTime": formattedDateTime,
    };

    context.read<EditMeetingCubit>().updateMeeting(
      int.parse(widget.meetingId),
      data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditMeetingCubit, EditMeetingState>(
      listener: (context, state) {
        if (state.status == EditMeetingStatus.success) {
          AppSnackbar.success(
            context,
            message: "Reuniao atualizada com sucesso!",
          );
          context.read<EditMeetingCubit>().loadMeeting(
            int.parse(widget.meetingId),
          );
          if (!mounted) return;
          context.pop();
        } else if (state.status == EditMeetingStatus.failure &&
            state.errorMessage != null) {
          AppSnackbar.error(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state.status == EditMeetingStatus.initial) {
          context.read<EditMeetingCubit>().loadMeeting(
            int.parse(widget.meetingId),
          );
          return Scaffold(
            appBar: const AppAppBar(title: "Editar reuniao"),
            body: const AppLoading(),
          );
        }

        if (state.status == EditMeetingStatus.loading) {
          return Scaffold(
            appBar: const AppAppBar(title: "Editar reuniao"),
            body: const AppLoading(),
          );
        }

        if (state.status == EditMeetingStatus.failure &&
            state.meeting == null) {
          return Scaffold(
            appBar: const AppAppBar(title: "Editar reuniao"),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: Spacing.space_sm),
                  Text(
                    state.errorMessage ?? "Erro desconhecido",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // EditMeetingLoaded
        _initializeControllers(state.meeting!);

        final isSaving = state.status == EditMeetingStatus.saving;

        return Scaffold(
          appBar: const AppAppBar(title: "Editar reuniao"),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Spacing.pagePaddingMobile),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: "Titulo da reuniao",
                    controller: _titleController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: Spacing.space_sm),
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Data e hora",
                        suffixIcon: const Icon(Icons.event_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.space_sm),
                  AppTextField(
                    label: "Local",
                    controller: _locationController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: Spacing.space_md),
                  AppButton(
                    label: "Salvar alteracoes",
                    isFullWidth: true,
                    isLoading: isSaving,
                    isDisabled: isSaving,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
