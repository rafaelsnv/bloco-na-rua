// lib/ui/carnivalBlock/editBlock/widgets/edit_block_screen.dart
//
// Bloco na Rua design system — edit block form screen.
//
// Form pattern: prefilled (loads existing block data from cubit state).
// Uses AppAppBar, AppCard, AppTextField, AppButton, AppLoading, AppError,
// and AppSnackbar design system primitives.

import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class EditBlockScreen extends StatefulWidget {
  const EditBlockScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<EditBlockScreen> createState() => _EditBlockScreenState();
}

class _EditBlockScreenState extends State<EditBlockScreen> {
  final _nameController = TextEditingController();
  String _currentImage = "";
  String _originalName = "";
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBlockCubit, EditBlockState>(
      listener: (context, state) {
        if (state is EditBlockSuccess) {
          AppSnackbar.success(context, message: "Bloco atualizado com sucesso");
          context.read<EditBlockCubit>().loadBlock();
          context.pop();
        } else if (state is EditBlockError) {
          AppSnackbar.error(context, message: state.message);
        } else if (state is EditBlockLoaded && !_initialized) {
          _nameController.text = state.name;
          _currentImage = state.carnivalBlockImage;
          _originalName = state.name;
          _initialized = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBar(title: "Editar bloco", showBackButton: true),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EditBlockState state) {
    if (state is EditBlockLoading || state is EditBlockInitial) {
      return const AppLoading(message: "Carregando bloco...");
    }

    if (state is EditBlockError) {
      return AppError(
        message: state.message,
        onRetry: () => context.read<EditBlockCubit>().loadBlock(),
      );
    }

    if (state is! EditBlockLoaded) {
      return const AppLoading(message: "Carregando bloco...");
    }

    final isSaving = state is EditBlockSaving;
    final currentName = _nameController.text.trim();
    final isUnchanged = currentName.isEmpty || currentName == _originalName;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.space_sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: "Nome do bloco",
              hint: "Ex: Bloco da Vizinhança",
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              isEnabled: !isSaving,
            ),
            const SizedBox(height: Spacing.space_lg),
            _buildImageSection(context, state),
            const SizedBox(height: Spacing.space_xl),
            AppButton(
              label: "Salvar alterações",
              onPressed: isSaving || isUnchanged
                  ? null
                  : () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        AppSnackbar.warning(
                          context,
                          message: "Digite um nome para o bloco",
                        );
                        return;
                      }
                      context.read<EditBlockCubit>().updateBlock(
                        name: name,
                        carnivalBlockImage: _currentImage,
                      );
                    },
              isLoading: isSaving,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, EditBlockLoaded state) {
    final hasImage = state.carnivalBlockImage.isNotEmpty;

    return Column(
      children: [
        ClipRRect(
          borderRadius: Radii.radiusMd,
          child: hasImage
              ? Image.network(
                  state.carnivalBlockImage,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImagePlaceholder(context),
                )
              : _buildImagePlaceholder(context),
        ),
        const SizedBox(height: Spacing.space_sm),
        Text(
          hasImage ? "Imagem do bloco" : "Sem imagem",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_rounded,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
