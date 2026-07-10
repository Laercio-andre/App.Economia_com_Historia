import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/outline_button_widget.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

/// Só edita região e instituição: são os únicos campos do perfil que o
/// backend expõe para o próprio utilizador (email e password mudam-se por
/// outros fluxos; role só é alterável por um MASTER).
class EditarPerfilScreen extends ConsumerStatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  ConsumerState<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends ConsumerState<EditarPerfilScreen> {
  late final TextEditingController _regiaoController;
  late final TextEditingController _instituicaoController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _regiaoController = TextEditingController(text: user?.regiao ?? '');
    _instituicaoController = TextEditingController(text: user?.instituicao ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Editar Perfil', centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldPrimary, width: 3),
                  color: AppColors.wineCard,
                ),
                child: const Icon(Icons.person, size: 46, color: AppColors.greySoft2),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(user?.email ?? '', style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'O email e a palavra-passe não podem ser alterados aqui.',
                style: AppTextStyles.bodyMuted,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(label: 'Região', hint: 'Luanda', icon: Icons.location_on_outlined, controller: _regiaoController),
            const SizedBox(height: 16),
            AppTextField(label: 'Instituição', hint: 'ISPTEC', icon: Icons.school_outlined, controller: _instituicaoController),
            const SizedBox(height: 26),
            PrimaryButton(
              label: 'Salvar alterações',
              showArrow: false,
              isLoading: authState.isLoading,
              onPressed: () async {
                try {
                  await ref.read(authProvider.notifier).updateProfile(
                        regiao: _regiaoController.text.trim(),
                        instituicao: _instituicaoController.text.trim(),
                      );
                  if (context.mounted) context.pop();
                } on ApiException catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
                  }
                }
              },
            ),
            const SizedBox(height: 12),
            AppOutlineButton(label: 'Cancelar', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}
