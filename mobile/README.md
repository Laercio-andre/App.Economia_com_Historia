# Economia com História 🇦🇴

App educativa angolana sobre economia — quizzes, artigos, fórum de discussão e ranking.

## Como correr

```bash
flutter pub get
flutter run
```

Requer Flutter 3.x+ (SDK Dart >=3.3.0). Testado para Android/iOS; a UI é 100% dark mode
por definição, seguindo a identidade visual "vinho + dourado" do protótipo original.

## Estrutura do projeto

```
lib/
  core/
    theme/        → cores, tipografia e ThemeData globais (app_colors.dart, app_text_styles.dart)
    router/        → configuração de rotas (go_router)
  models/          → modelos de dados (Article, QuizQuestion, ForumTopic, RankingEntry, AppUser)
  data/            → repositórios (mock, prontos para trocar por API real)
  shared/widgets/  → componentes reutilizáveis (botões, inputs, cards, bottom nav)
  features/        → um ecrã/fluxo por pasta (welcome, auth, home, explorar, quiz, forum,
                     perfil, configuracoes, legal, suporte, ranking)
```

## Notas

- Autenticação, quiz, fórum, artigos e ranking usam **dados mock** em memória/local
  (`shared_preferences` para sessão e definições). As interfaces dos repositórios (`data/`)
  já estão desenhadas para serem substituídas por chamadas API reais sem tocar na UI.
- Gestão de estado: **Riverpod**.
- Navegação: **go_router**, com rota `/welcome` como entrada e shell de 5 tabs em `/home/*`.
- Todas as cores/tipografia estão centralizadas em `lib/core/theme/` — nunca uses valores
  soltos nos ecrãs.

## Próximos passos sugeridos

- Ligar `AuthRepository` a um backend real (Firebase Auth ou API REST).
- Substituir os repositórios mock por chamadas HTTP.
- Adicionar testes de widget para os fluxos principais (login, quiz, fórum).
flutter create 