import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../data/settings_repository.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class ConfiguracoesScreen extends ConsumerStatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  ConsumerState<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends ConsumerState<ConfiguracoesScreen> {
  final _repo = SettingsRepository();
  bool _push = true;
  bool _theme = true;
  bool _offline = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final push = await _repo.getPushNotifications();
    final theme = await _repo.getThemeMwangole();
    final offline = await _repo.getOfflineMode();
    setState(() {
      _push = push;
      _theme = theme;
      _offline = offline;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: AppColors.wineDarkest,
        body: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
      );
    }

    final isGuest = ref.watch(authProvider).isGuest;

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Configurações'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          if (!isGuest) ...[
            const _SectionLabel('Conta'),
            _NavRow(label: 'Editar Perfil', onTap: () => context.push('/perfil/editar')),
            _NavRow(label: 'Alterar Senha', onTap: () => context.push('/configuracoes/senha')),
          ],
          const _SectionLabel('Notificações'),
          _ToggleRow(
            label: 'Notificações Push',
            subtitle: 'Receber alertas no dispositivo',
            value: _push,
            onChanged: (v) async {
              setState(() => _push = v);
              await _repo.setPushNotifications(v);
            },
          ),
          const _SectionLabel('Aparência'),
          _ToggleRow(
            label: 'Tema Mwangole',
            value: _theme,
            onChanged: (v) async {
              setState(() => _theme = v);
              await _repo.setThemeMwangole(v);
            },
          ),
          _NavRow(label: 'Tamanho de Letra', onTap: () {}),
          const _SectionLabel('Dados e Armazenamento'),
          _ToggleRow(
            label: 'Modo Offline',
            value: _offline,
            onChanged: (v) async {
              setState(() => _offline = v);
              await _repo.setOfflineMode(v);
            },
          ),
          _NavRow(
            label: 'Limpar Cache',
            trailingText: '45 MB',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.wineDeep,
                  title: Text('Limpar cache', style: AppTextStyles.h3),
                  content: Text('Isto vai libertar 45 MB de espaço. Continuar?', style: AppTextStyles.body),
                  actions: [
                    TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache limpa com sucesso.')));
                      },
                      child: const Text('Limpar'),
                    ),
                  ],
                ),
              );
            },
          ),
          const _SectionLabel('Sobre'),
          _NavRow(label: 'Termos de Uso', onTap: () => context.push('/legal/termos')),
          _NavRow(label: 'Política de Privacidade', onTap: () => context.push('/legal/privacidade')),
          _NavRow(label: 'Ajuda e Suporte', onTap: () => context.push('/suporte')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Versão', style: AppTextStyles.body.copyWith(color: AppColors.textWhite)),
                Text('1.0.0', style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(text, style: AppTextStyles.h3.copyWith(fontSize: 15)),
    );
  }
}

class _NavRow extends StatelessWidget {
  final String label;
  final String? trailingText;
  final VoidCallback onTap;
  const _NavRow({required this.label, required this.onTap, this.trailingText});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.wineDeep,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600))),
              if (trailingText != null) ...[
                Text(trailingText!, style: AppTextStyles.bodyMuted),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.chevron_right, color: AppColors.greySoft2, size: 20),
            ],
          ),
        ),
      ),
    ).withBottomMargin();
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.value, required this.onChanged, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.wineDeep, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.goldPrimary,
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget withBottomMargin() => Padding(padding: const EdgeInsets.only(bottom: 10), child: this);
}
