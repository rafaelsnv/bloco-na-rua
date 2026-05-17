import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/logout/widgets/logout_button.dart';
import 'package:bloco_na_rua/ui/core/colors/app_colors.dart';
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
                  Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.errorMessage!)),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
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
          return _buildLoadingCarousel(context);
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
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildLoadingCarousel(BuildContext context) {
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.event_busy,
                    color: Theme.of(context).colorScheme.outline,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nenhum encontro esta semana',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
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
      elevation: 0,
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
                  color: _getDayColor(meetingDateTime).withValues(alpha: 0.15),
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
                          color: Theme.of(context).colorScheme.outline,
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
                          color: Theme.of(context).colorScheme.outline,
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
      return AppColors.success;
    } else if (meetingDate == today.add(const Duration(days: 1))) {
      return AppColors.info;
    } else {
      return AppColors.warning;
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.primary,
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
              context,
              Icons.location_on,
              meeting.location ?? 'Local não informado',
            ),
            const SizedBox(height: 8),
            _buildModalInfoRow(
              context,
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
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildModalInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
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
          child: ElevatedButton.icon(
            onPressed: () => context.push(Routes.joinBlock),
            icon: const Icon(Icons.group_add),
            label: const Text('Entrar em Bloco'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push(Routes.createBlock),
            icon: const Icon(Icons.add_circle),
            label: const Text('Criar Bloco'),
          ),
        ),
      ],
    );
  }
}
