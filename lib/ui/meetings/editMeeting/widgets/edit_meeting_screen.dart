import 'package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditMeetingScreen extends StatefulWidget {
  const EditMeetingScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateTimeController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _dateTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  void _initializeControllers(EditMeetingState meetingState) {
    if (_controllersInitialized) return;
    if (meetingState.meeting == null) return;

    final meeting = meetingState.meeting!;
    _nameController.text = meeting.name ?? '';
    _descriptionController.text = meeting.description ?? '';
    _locationController.text = meeting.location ?? '';
    _dateTimeController.text = meeting.meetingDateTime ?? '';

    _controllersInitialized = true;
  }

  void _submitForm() {
    final data = {
      if (_nameController.text.isNotEmpty) 'name': _nameController.text,
      if (_descriptionController.text.isNotEmpty)
        'description': _descriptionController.text,
      if (_locationController.text.isNotEmpty)
        'location': _locationController.text,
      if (_dateTimeController.text.isNotEmpty)
        'meetingDateTime': _dateTimeController.text,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reunião atualizada com sucesso!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          context.pop();
        } else if (state.status == EditMeetingStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == EditMeetingStatus.initial) {
          context.read<EditMeetingCubit>().loadMeeting(
            int.parse(widget.meetingId),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == EditMeetingStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == EditMeetingStatus.failure &&
            state.meeting == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: Center(
              child: Text(state.errorMessage ?? 'Erro desconhecido'),
            ),
          );
        }

        if (state.status == EditMeetingStatus.loaded) {
          _initializeControllers(state);

          return Scaffold(
            appBar: AppBar(title: const Text('Editar Reunião')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do encontro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Local',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Data/Hora',
                      border: OutlineInputBorder(),
                      hintText: 'YYYY-MM-DD HH:mm',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.status == EditMeetingStatus.saving
                        ? null
                        : _submitForm,
                    child: state.status == EditMeetingStatus.saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar Alterações'),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Carregando...')));
      },
    );
  }
}
