import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/profile_button.dart';
import 'package:bloco_na_rua/ui/home/view_model/home_viewmodel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onResult() {
    final resultBlocks = widget.viewModel.loadCarnivalBlocks.results.value.data;
    final resultMeetings = widget.viewModel.loadMeetings.results.value.data;

    if (resultMeetings == null || resultBlocks == null) {
      return;
    }

    final errors = <String>[];
    if (resultMeetings.isError()) {
      errors.add(
        resultMeetings.exceptionOrNull().toString().replaceAll(
          "Exception: ",
          "",
        ),
      );
      widget.viewModel.loadMeetings.clearErrors();
    }

    if (resultBlocks.isError()) {
      errors.add(
        resultBlocks.exceptionOrNull().toString().replaceAll("Exception: ", ""),
      );
      widget.viewModel.loadCarnivalBlocks.clearErrors();
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errors.join('\n'))));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadCarnivalBlocks.addListener(_onResult);
    widget.viewModel.loadMeetings.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadCarnivalBlocks.removeListener(_onResult);
    widget.viewModel.loadCarnivalBlocks.addListener(_onResult);

    oldWidget.viewModel.loadMeetings.removeListener(_onResult);
    widget.viewModel.loadMeetings.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadCarnivalBlocks.removeListener(_onResult);
    widget.viewModel.loadMeetings.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ProfileButton(),
        title: const Text('Bloco Na Rua'),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(authRepository: context.read()),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Text(
                "Meus blocos",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              _buildCarnivalBlockCarousel(),
              Text(
                "Encontros da semana",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              _buildMeetingsList(),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarnivalBlockCarousel() {
    return ListenableBuilder(
      listenable: widget.viewModel.loadCarnivalBlocks,
      builder: (context, child) {
        if (widget.viewModel.loadCarnivalBlocks.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.loadCarnivalBlocks.results.value.hasError) {
          return ErrorWidget(
            widget.viewModel.loadCarnivalBlocks.results.value.error!,
          );
        }

        var carnivalBlockList = widget
            .viewModel
            .loadCarnivalBlocks
            .results
            .value
            .data
            ?.getOrNull();
        if (carnivalBlockList == null || carnivalBlockList.isEmpty) {
          return const Center(child: Text('Nenhum bloco encontrado'));
        }

        return CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.4,
            height: MediaQuery.of(context).size.height * 0.20,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ),
          items: carnivalBlockList.map((block) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    context.push('${Routes.carnivalBlock}/${block.id}');
                  },
                  child: Card(
                    color: Colors.blueAccent,
                    child: Center(
                      child: Text(
                        block.name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMeetingsList() {
    return ListenableBuilder(
      listenable: widget.viewModel.loadMeetings,
      builder: (context, child) {
        if (widget.viewModel.loadMeetings.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.loadMeetings.results.value.hasError) {
          return ErrorWidget(
            widget.viewModel.loadMeetings.results.value.error!,
          );
        }

        var meetingsList = widget.viewModel.loadMeetings.results.value.data
            ?.getOrNull();
        if (meetingsList == null || meetingsList.isEmpty) {
          return const Center(child: Text('Nenhuma reunião encontrada'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: meetingsList.length,
          itemBuilder: (context, index) {
            final meeting = meetingsList[index];
            var meetingDateTime = DateTime.parse(meeting.meetingDateTime ?? '');

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
                  DateFormat('dd/MM/yy HH:mm', 'pt_BR').format(meetingDateTime),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              meeting.name ?? '',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              meeting.description ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Local: ${meeting.location}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              DateFormat(
                                'E dd/MM/yy HH:mm',
                                'pt_BR',
                              ).format(meetingDateTime),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            ElevatedButton(
                              child: const Text('Fechar'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // context.push('${Routes.meeting}/${meeting.id}');
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 20,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () => context.push(Routes.carnivalBlock),
            child: const Text('Block Page'),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () => context.push(Routes.members),
            child: const Text('Members Page'),
          ),
        ),
      ],
    );
  }
}
