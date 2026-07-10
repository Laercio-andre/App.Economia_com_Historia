import "package:flutter/material.dart";
import "../../core/network/api_client.dart";
import "../../core/theme/app_colors.dart";
import "../../core/theme/app_text_styles.dart";
import "../../data/notification_repository.dart";
import "../../models/app_notification.dart";
import "../../shared/widgets/app_card.dart";
import "../../shared/widgets/simple_back_app_bar.dart";

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  final _repo = NotificationRepository();
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchAll();
  }

  Future<void> _reload() async {
    setState(() => _future = _repo.fetchAll());
    await _future;
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.lida) return;
    try {
      await _repo.markAsRead(notification.id);
      await _reload();
    } catch (_) {
      // Silencioso: se falhar, a notificação apenas continua marcada como não lida.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Notificações'),
      body: RefreshIndicator(
        onRefresh: _reload,
        color: AppColors.goldPrimary,
        backgroundColor: AppColors.wineDeep,
        child: FutureBuilder<List<AppNotification>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary));
            }
            if (snapshot.hasError) {
              final message = snapshot.error is ApiException
                  ? (snapshot.error as ApiException).mensagem
                  : 'Não foi possível carregar as notificações.';
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.wifi_off, color: AppColors.greySoft2, size: 40),
                  const SizedBox(height: 12),
                  Text(message, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                ],
              );
            }

            final notifications = snapshot.data ?? [];
            if (notifications.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.notifications_none, color: AppColors.greySoft2, size: 40),
                  const SizedBox(height: 12),
                  Text('Ainda não tens notificações.', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return AppCard(
                  color: n.lida ? AppColors.wineDeep : AppColors.wineCard,
                  onTap: () => _markAsRead(n),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        n.lida ? Icons.notifications_none : Icons.notifications_active,
                        color: n.lida ? AppColors.greySoft2 : AppColors.goldPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.mensagem, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(n.tipoEvento, style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
