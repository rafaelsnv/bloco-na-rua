import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/profile_button.dart';
import 'package:bloco_na_rua/ui/home/cubit/home_cubit.dart';
import 'package:bloco_na_rua/ui/home/cubit/home_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          current.status == HomeStatus.failure &&
          previous.status != HomeStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const ProfileButton(),
          title: const Text(
            'Bloco Na Rua',
            overflow: TextOverflow.ellipsis,
          ),
          actions: const [
            LogoutButton(),
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
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarnivalBlockCarousel() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.blocks != current.blocks,
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure && state.blocks.isEmpty) {
          return const Center(child: Text('Erro ao carregar blocos'));
        }

        final blocks = state.blocks;
        if (blocks.isEmpty) {
          return const Center(child: Text('Nenhum bloco encontrado'));
        }

        return CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.4,
            height: MediaQuery.of(context).size.height * 0.20,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ),
          items: blocks.map((block) {
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
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.meetings != current.meetings,
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure && state.meetings.isEmpty) {
          return const Center(child: Text('Erro ao carregar encontros'));
        }

        final meetings = state.meetings;
        if (meetings.isEmpty) {
          return const Center(child: Text('Nenhuma reunião encontrada'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final meeting = meetings[index];
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
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
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
