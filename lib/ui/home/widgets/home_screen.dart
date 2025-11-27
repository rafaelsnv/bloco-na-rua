import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/view_model/logout_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/profile_button.dart';
import 'package:bloco_na_rua/ui/home/view_model/home_viewmodel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          child: Column(
            children: [
              _buildCarnivalBlockCarousel(),
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
          options: CarouselOptions(height: 200.0),
          items: carnivalBlockList.map((block) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    context.push('${Routes.carnivalBlock}/${block.id}');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.amber),
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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meetingsList.length,
          itemBuilder: (context, index) {
            final meeting = meetingsList[index];
            return ListTile(
              title: Text(meeting.name ?? ''),
              subtitle: Text(meeting.description ?? ''),
              onTap: () {
                context.push('${Routes.meeting}/${meeting.id}');
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
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
