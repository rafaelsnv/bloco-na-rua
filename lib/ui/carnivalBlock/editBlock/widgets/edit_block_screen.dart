import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/block_error.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
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
  final _formKey = GlobalKey<FormState>();
  String _currentImage = "";
  String _originalName = "";
  bool _initialized = false;

  /// Fields the user has already edited.
  ///
  /// Only these may paint an error before the first submit attempt — a
  /// pristine field the user never touched stays neutral.
  bool _nameTouched = false;

  /// True once the user tried to submit.
  ///
  /// From then on every invalid field shows its error, and the form is
  /// re-validated on every edit so the errors stay in sync.
  bool _submitAttempted = false;

  /// Error message for the name field, or null when the value is valid.
  String? _nameValidator(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.blockNameRequired;
    }
    return null;
  }

  /// Keeps the painted error states in sync after an edit.
  void _syncForm() {
    if (_submitAttempted) {
      // After a submit attempt every invalid field shows its error, so the
      // whole form has to be re-validated on every edit.
      _formKey.currentState?.validate();
    }
  }

  void _onNameChanged(String _) {
    setState(() => _nameTouched = true);
    _syncForm();
  }

  void _submitForm() {
    setState(() => _submitAttempted = true);
    // Field errors are reported inline, below the field that owns them.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<EditBlockCubit>().updateBlock(
      name: _nameController.text.trim(),
      carnivalBlockImage: _currentImage,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<EditBlockCubit, EditBlockState>(
      listenWhen: (prev, curr) =>
          prev is! EditBlockLoaded && curr is EditBlockLoaded && !_initialized,
      listener: (context, state) {
        final loaded = state as EditBlockLoaded;
        _nameController.text = loaded.name;
        _currentImage = loaded.carnivalBlockImage;
        _originalName = loaded.name;
        _initialized = true;
      },
      child: BlocConsumer<EditBlockCubit, EditBlockState>(
        listener: (context, state) {
          if (state is EditBlockSuccess) {
            context.read<BlockListCubit>().loadBlocks();
            context.read<HomeCubit>().loadHomeData();
            AppSnackbar.success(context, message: l10n.blocksUpdateSuccess);
            context.pop();
          } else if (state is EditBlockError) {
            AppSnackbar.error(
              context,
              message: localizeBlockError(context, state.error),
            );
          } else if (state is EditBlockDeleted) {
            context.read<BlockListCubit>().loadBlocks();
            context.read<HomeCubit>().loadHomeData();
            AppSnackbar.success(context, message: l10n.blocksDeleteSuccess);
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBar(
              title: l10n.blocksEditTitle,
              showBackButton: true,
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Future<void> _deleteBlock(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<EditBlockCubit>();
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.blocksDeleteTitle,
      message: l10n.blocksDeleteConfirmMessage,
      confirmLabel: l10n.blocksDeleteConfirm,
      cancelLabel: l10n.blocksCancel,
      isDestructive: true,
    );

    if (confirmed != true) return;

    if (!mounted) return;
    cubit.deleteBlock();
  }

  Widget _buildBody(BuildContext context, EditBlockState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state is EditBlockLoading || state is EditBlockInitial) {
      return AppLoading(message: l10n.blocksLoadingBlock);
    }

    if (state is EditBlockError) {
      return AppError(
        message: localizeBlockError(context, state.error),
        onRetry: () => context.read<EditBlockCubit>().loadBlock(),
      );
    }

    if (state is! EditBlockLoaded) {
      return AppLoading(message: l10n.blocksLoadingBlock);
    }

    final isSaving = state is EditBlockSaving;
    final isDeleting = state is EditBlockDeleting;
    final currentName = _nameController.text.trim();
    // An empty name is invalid, not "unchanged": the CTA stays tappable so
    // the inline error can explain what is missing.
    final isUnchanged = currentName.isNotEmpty && currentName == _originalName;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.space_sm),
      child: AppCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: Spacing.space_xs),
                child: AppTextField(
                  label: l10n.blockNameLabel,
                  hint: l10n.blockEditNameHint,
                  controller: _nameController,
                  validator: (value) => _nameValidator(l10n, value),
                  errorText: _nameTouched
                      ? _nameValidator(l10n, _nameController.text)
                      : null,
                  onChanged: _onNameChanged,
                  isEnabled: !isSaving,
                ),
              ),
              const SizedBox(height: Spacing.space_lg),
              _buildImageSection(context, state),
              const SizedBox(height: Spacing.space_xl),
              AppButton(
                label: l10n.blocksSaveChanges,
                onPressed: isSaving || isUnchanged ? null : _submitForm,
                isLoading: isSaving,
                isFullWidth: true,
              ),
              const SizedBox(height: Spacing.space_md),
              AppButton(
                label: l10n.blocksDeleteTitle,
                onPressed: isDeleting ? null : () => _deleteBlock(context),
                isLoading: isDeleting,
                isFullWidth: true,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, EditBlockLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = state.carnivalBlockImage.isNotEmpty;

    return Column(
      children: [
        ClipRRect(
          borderRadius: Radii.radiusMd,
          child: hasImage
              ? Image.network(
                  state.carnivalBlockImage,
                  height: Spacing.imageBoxHeight,
                  width: Spacing.imageBoxWidth,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImagePlaceholder(context),
                )
              : _buildImagePlaceholder(context),
        ),
        const SizedBox(height: Spacing.space_sm),
        Text(
          hasImage ? l10n.blocksImageLabel : l10n.blocksNoImage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: Spacing.imageBoxHeight,
      width: Spacing.imageBoxWidth,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_rounded,
        size: AppIconSizes.displayXLarge,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
