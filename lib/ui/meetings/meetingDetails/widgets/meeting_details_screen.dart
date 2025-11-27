import 'package:bloco_na_rua/ui/meetings/meetingDetails/view_model/meeting_details_viewmodel.dart';
import 'package:flutter/material.dart';

class MeetingDetailsScreen extends StatefulWidget {
  const MeetingDetailsScreen({
    super.key,
    required this.viewModel,
    required this.meetingId,
  });

  final MeetingDetailsViewModel viewModel;
  final String meetingId;

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  void _onResult() {
    final result = widget.viewModel.loadMeeting.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      final error = result.exceptionOrNull().toString().replaceAll(
        "Exception: ",
        "",
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      widget.viewModel.loadMeeting.clearErrors();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadMeeting.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant MeetingDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadMeeting.removeListener(_onResult);
    widget.viewModel.loadMeeting.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadMeeting.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Encontro")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.loadMeeting,
          builder: (context, child) {
            if (widget.viewModel.loadMeeting.isExecuting.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.loadMeeting.results.value.hasError) {
              return ErrorWidget(
                widget.viewModel.loadMeeting.results.value.error!,
              );
            }

            var meeting = widget.viewModel.loadMeeting.results.value.data
                ?.getOrNull();
            if (meeting == null) {
              return const Center(child: Text('Nenhum dado encontrado'));
            }
            return Center(
              child: Text(
                meeting.name ?? "",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purpleAccent.shade100,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
