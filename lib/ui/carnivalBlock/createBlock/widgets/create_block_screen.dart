import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateBlockCubit, CreateBlockState>(
      listener: (context, state) {
        if (state is CreateBlockSuccess) {
          AppSnackbar.success(context, message: "Bloco criado com sucesso!");
          context.pushReplacement("${Routes.carnivalBlock}/${state.blockId}");
        } else if (state is CreateBlockError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBlockLoading;
        final name = _nameController.text.trim();
        final isDisabled = name.isEmpty || isLoading;

        return Scaffold(
          appBar: const AppAppBar(title: "Criar bloco"),
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
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.celebration_rounded,
                            size: 48,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Heading
                      Text(
                        "Crie seu bloco",
                        style: AppTypography.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.space_2xs),
                      Text(
                        "Dê um nome ao seu bloco de rua e comece a organizar!",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Name field
                      AppTextField(
                        controller: _nameController,
                        label: "Nome do bloco",
                        hint: "Ex.: Bloco da Saudade",
                        prefixIcon: Icons.celebration_rounded,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Digite um nome para o bloco";
                          }
                          if (value.trim().length < 3) {
                            return "Nome muito curto";
                          }
                          if (value.trim().length > 50) {
                            return "Nome muito longo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Spacing.space_lg),
                      // Submit button
                      AppButton(
                        label: "Criar",
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.lg,
                        isFullWidth: true,
                        isLoading: isLoading,
                        isDisabled: isDisabled,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final name = _nameController.text.trim();
                            context.read<CreateBlockCubit>().createBlock(name);
                          }
                        },
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
