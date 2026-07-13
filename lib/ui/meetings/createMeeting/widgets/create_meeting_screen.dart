import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTimeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final initialDate = DateTime.now();
    final firstDate = initialDate;
    final lastDate = initialDate.add(const Duration(days: 365));

    DateTime? picked;
    if (reduceMotion) {
      picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    }
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDateTimeController();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final initialTime = TimeOfDay.now();

    TimeOfDay? picked;
    if (reduceMotion) {
      picked = await showTimePicker(context: context, initialTime: initialTime);
    } else {
      picked = await showTimePicker(context: context, initialTime: initialTime);
    }
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _updateDateTimeController();
      });
    }
  }

  void _updateDateTimeController() {
    if (_selectedDate == null || _selectedTime == null) {
      _dateTimeController.text = "";
      return;
    }
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    _dateTimeController.text = DateFormat.yMd(
      "pt_BR",
    ).add_Hm().format(dateTime);
  }

  void _submitForm(BuildContext context) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      AppSnackbar.warning(
        context,
        message: "Por favor, insira um nome para a reunião",
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      AppSnackbar.warning(context, message: "Por favor, selecione data e hora");
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
      "name": title,
      "description": _descriptionController.text.trim(),
      "location": _locationController.text.trim(),
      "dateTime": dateTime.toIso8601String(),
      "carnivalBlockId": int.tryParse(widget.carnivalBlockId) ?? 0,
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
          if (state.status == CreateMeetingStatus.success) {
            AppSnackbar.success(context, message: "Reunião criada com sucesso");
            context.pop();
          } else if (state.status == CreateMeetingStatus.failure) {
            final message =
                state.errorMessage ?? "Erro ao criar reunião. Tente novamente.";
            AppSnackbar.error(context, message: message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const AppAppBar(
              title: "Nova reunião",
              showBackButton: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          controller: _titleController,
                          label: "Título da reunião",
                          hint: "Ex.: Ensaio geral",
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: Spacing.space_md),
                        AppTextField(
                          controller: _descriptionController,
                          label: "Descrição",
                          hint: "Detalhes sobre a reunião (opcional)",
                          isMultiline: true,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: Spacing.space_md),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: _selectedDate != null
                                          ? DateFormat.yMd(
                                              "pt_BR",
                                            ).format(_selectedDate!)
                                          : "",
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Data",
                                      hintText: "Selecione",
                                      suffixIcon: const Icon(
                                        Icons.calendar_today_rounded,
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.space_sm),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(context),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: _selectedTime != null
                                          ? _selectedTime!.format(context)
                                          : "",
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Hora",
                                      hintText: "Selecione",
                                      suffixIcon: const Icon(
                                        Icons.access_time_rounded,
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.space_md),
                        AppTextField(
                          controller: _locationController,
                          label: "Local",
                          hint: "Ex.: Praça central",
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: Spacing.space_lg),
                        AppButton(
                          label: "Criar reunião",
                          variant: AppButtonVariant.primary,
                          isFullWidth: true,
                          isLoading:
                              state.status == CreateMeetingStatus.loading,
                          isDisabled:
                              _titleController.text.trim().isEmpty ||
                              _selectedDate == null ||
                              _selectedTime == null,
                          onPressed: () => _submitForm(context),
                        ),
                      ],
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
