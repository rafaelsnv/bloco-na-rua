import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/block_error.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:bloco_na_rua/routing/routes.dart";

class CreateBlockScreen extends StatefulWidget {
  const CreateBlockScreen({super.key});

  @override
  State<CreateBlockScreen> createState() => _CreateBlockScreenState();
}

class _CreateBlockScreenState extends State<CreateBlockScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    if (value.trim().length < 3) {
      return l10n.blockNameTooShort;
    }
    if (value.trim().length > 50) {
      return l10n.blockNameTooLong;
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
    context.read<CreateBlockCubit>().createBlock(_nameController.text.trim());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<CreateBlockCubit, CreateBlockState>(
      listener: (context, state) {
        if (state is CreateBlockSuccess) {
          context.read<BlockListCubit>().loadBlocks();
          context.read<HomeCubit>().loadHomeData();
          AppSnackbar.success(context, message: l10n.blocksCreateSuccess);
          context.pushReplacement("${Routes.carnivalBlock}/${state.blockId}");
        } else if (state is CreateBlockError) {
          AppSnackbar.error(
            context,
            message: localizeBlockError(context, state.error),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBlockLoading;

        return Scaffold(
          appBar: AppAppBar(title: l10n.blocksCreateTitle),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.space_md),
              child: AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Spacing.space_lg),
                      // Illustration
                      Center(
                        child: Container(
                          width: Spacing.space_4xl,
                          height: Spacing.space_4xl,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.celebration_rounded,
                            size: AppIconSizes.displayXLarge,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Heading
                      Text(
                        l10n.blocksCreateHeadline,
                        style: AppTypography.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.space_2xs),
                      Text(
                        l10n.blocksCreateSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Name field
                      AppTextField(
                        controller: _nameController,
                        label: l10n.blockNameLabel,
                        hint: l10n.blockNameHint,
                        prefixIcon: Icons.celebration_rounded,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        validator: (value) => _nameValidator(l10n, value),
                        errorText: _nameTouched
                            ? _nameValidator(l10n, _nameController.text)
                            : null,
                        onChanged: _onNameChanged,
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Submit button
                      AppButton(
                        label: l10n.blocksCreate,
                        variant: AppButtonVariant.primary,
                        size: AppButtonSizeMetrics.lg,
                        isFullWidth: true,
                        isLoading: isLoading,
                        // The CTA is never a dead end: an invalid form is
                        // reported inline when the user submits, instead of
                        // a button that never becomes tappable.
                        isDisabled: isLoading,
                        onPressed: _submitForm,
                      ),
                      const SizedBox(height: Spacing.space_lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
