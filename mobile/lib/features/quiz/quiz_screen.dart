import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/quiz_repository.dart';
import '../../models/quiz_question.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/primary_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _repo = QuizRepository();
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final questions = await _repo.fetchQuestions();
    setState(() => _questions = questions);
  }

  void _confirm() {
    if (_selectedOption == null) return;
    setState(() {
      _answered = true;
      if (_selectedOption == _questions[_currentIndex].correctIndex) _score++;
    });
  }

  void _next() {
    if (_currentIndex >= _questions.length - 1) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedOption = null;
      _answered = false;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedOption = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const ColoredBox(
        color: AppColors.wineDarkest,
        child: Center(child: CircularProgressIndicator(color: AppColors.goldPrimary)),
      );
    }

    if (_finished) {
      return _ResultView(score: _score, total: _questions.length, onRestart: _restart);
    }

    final question = _questions[_currentIndex];

    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.h2,
                      children: [
                        const TextSpan(text: 'Quiz de '),
                        TextSpan(text: 'Mercado', style: AppTextStyles.h2.copyWith(color: AppColors.goldPrimary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${_currentIndex + 1}/${_questions.length}',
                          style: AppTextStyles.h3.copyWith(color: AppColors.goldLight)),
                      Text('PERGUNTAS', style: AppTextStyles.label),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  minHeight: 6,
                  backgroundColor: AppColors.wineCard,
                  valueColor: const AlwaysStoppedAnimation(AppColors.goldPrimary),
                ),
              ),
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 8, color: AppColors.goldAccent),
                        const SizedBox(width: 6),
                        Text(question.category, style: AppTextStyles.eyebrow),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(question.question, style: AppTextStyles.h3.copyWith(fontSize: 19)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ...List.generate(question.options.length, (index) {
                final letter = String.fromCharCode(65 + index);
                final isSelected = _selectedOption == index;
                final isCorrect = index == question.correctIndex;
                Color borderColor = Colors.transparent;
                Widget? trailing;
                if (_answered && isSelected) {
                  borderColor = isCorrect ? AppColors.successGreen : AppColors.errorRed;
                  trailing = Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? AppColors.successGreen : AppColors.errorRed, size: 20);
                } else if (isSelected) {
                  borderColor = AppColors.goldPrimary;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: _answered ? null : () => setState(() => _selectedOption = index),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.wineDeep,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isSelected ? AppColors.goldPrimary : AppColors.wineCard,
                            child: Text(letter,
                                style: TextStyle(
                                    color: isSelected ? AppColors.wineDarkest : AppColors.textRose,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Text(question.options[index], style: AppTextStyles.body)),
                          if (trailing != null) trailing,
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Center(
                child: TextButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(question.hint)),
                  ),
                  icon: const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.goldAccent),
                  label: Text('PRECISA DE UMA DICA?', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: _answered ? 'Próxima Pergunta' : 'Confirmar Resposta',
                onPressed: _answered ? _next : (_selectedOption == null ? null : _confirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;
  const _ResultView({required this.score, required this.total, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: AppColors.goldPrimary, size: 64),
                const SizedBox(height: 16),
                Text('Quiz Concluído!', style: AppTextStyles.h2, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Acertaste $score de $total perguntas.', style: AppTextStyles.body, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                PrimaryButton(label: 'Repetir Quiz', showArrow: false, onPressed: onRestart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
