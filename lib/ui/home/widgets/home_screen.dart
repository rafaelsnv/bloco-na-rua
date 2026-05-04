import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/card_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/chip_date.dart';
import 'package:bloco_na_rua/ui/core/widgets/empty_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/error_state_widget.dart';
import 'package:bloco_na_rua/ui/core/widgets/profile_button.dart';
import 'package:bloco_na_rua/ui/core/widgets/section_header.dart';
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
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.errorMessage!)),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
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
          actions: const [LogoutButton()],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeCubit>().loadHomeData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Meus blocos'),
                  _buildCarnivalBlockCarousel(),
                  const SizedBox(height: 8),
                  SectionHeader(
                    title: 'Encontros da semana',
                    action: 'Ver todos',
                    onAction: () => context.push(Routes.userMeetings),
                  ),
                  _buildMeetingsList(),
                  const SizedBox(height: 16),
                  _buildNavigationButtons(context),
                ],
              ),
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
          return _buildLoadingCarousel();
        }

        if (state.status == HomeStatus.failure && state.blocks.isEmpty) {
          return ErrorStateWidget(
            message: state.errorMessage ?? 'Erro ao carregar blocos',
            onRetry: () => context.read<HomeCubit>().loadHomeData(),
          );
        }

        final blocks = state.blocks;
        if (blocks.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.celebration,
            message: 'Nenhum bloco ainda',
            subtitle: 'Crie ou entre em um bloco para começar!',
            actionLabel: 'Criar bloco',
            onAction: () => context.push(Routes.createBlock),
          );
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 0.45,
                height: 140,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
              ),
              items: blocks.map((block) {
                return Builder(
                  builder: (context) {
                    return _buildBlockCard(context, block);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            _buildCarouselIndicator(blocks.length),
          ],
        );
      },
    );
  }

  Widget _buildBlockCard(BuildContext context, block) {
    return InkWell(
      onTap: () => context.push('${Routes.carnivalBlock}/${block.id}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purpleAccent.shade100,
                  Colors.purpleAccent.shade400,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    Icons.celebration,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        block.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicator(int count) {
    return const SizedBox.shrink();
  }

  Widget _buildLoadingCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.45,
        height: 140,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
      ),
      items: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget _buildMeetingsList() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.meetings != current.meetings,
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == HomeStatus.failure && state.meetings.isEmpty) {
          return ErrorStateWidget(
            message: state.errorMessage ?? 'Erro ao carregar encontros',
            onRetry: () => context.read<HomeCubit>().loadHomeData(),
          );
        }

        final meetings = state.meetings;
        if (meetings.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.event_busy,
            message: 'Nenhum encontro esta semana',
            subtitle: 'Aguarde ou crie um novo encontro',
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final meeting = meetings[index];
            final meetingDateTime =
                DateTime.parse(meeting.meetingDateTime ?? '');

            return _buildMeetingCard(context, meeting, meetingDateTime);
          },
        );
      },
    );
  }

  Widget _buildMeetingCard(BuildContext context, meeting, DateTime meetingDateTime) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showMeetingModal(context, meeting, meetingDateTime),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getDayColor(meetingDateTime).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E('pt_BR').format(meetingDateTime),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getDayColor(meetingDateTime),
                      ),
                    ),
                    Text(
                      meetingDateTime.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getDayColor(meetingDateTime),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.name ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            meeting.location ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChipDate(dateTime: meetingDateTime),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(meetingDateTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDayColor(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final meetingDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (meetingDate == today) {
      return Colors.green;
    } else if (meetingDate == today.add(const Duration(days: 1))) {
      return Colors.blue;
    } else {
      return Colors.purple;
    }
  }

  void _showMeetingModal(
      BuildContext context, meeting, DateTime meetingDateTime) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event,
                    color: Colors.purpleAccent.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    meeting.name ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (meeting.description != null &&
                meeting.description!.isNotEmpty) ...[
              Text(
                meeting.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
            _buildModalInfoRow(
              Icons.location_on,
              meeting.location ?? 'Local não informado',
            ),
            const SizedBox(height: 8),
            _buildModalInfoRow(
              Icons.calendar_today,
              DateFormat('EEEE, dd/MM/yyyy - HH:mm', 'pt_BR')
                  .format(meetingDateTime),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('${Routes.meeting}/${meeting.id}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade100,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ver detalhes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CardButton(
            icon: Icons.group_add,
            label: 'Entrar em Bloco',
            onTap: () => context.push(Routes.joinBlock),
            color: Colors.green,
          ),
        ),
        Expanded(
          child: CardButton(
            icon: Icons.add_circle,
            label: 'Criar Bloco',
            onTap: () => context.push(Routes.createBlock),
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}
