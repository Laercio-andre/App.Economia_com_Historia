import "../models/quiz_question.dart";

class QuizRepository {
  static final List<QuizQuestion> _questions = [
    const QuizQuestion(
      id: "q1",
      category: "MACROECONOMIA ANGOLANA",
      question:
          "Qual foi o principal motor de crescimento do PIB não petrolífero em Angola durante o último trimestre fiscal?",
      options: [
        "Expansão do Setor Agrícola e Agro-processamento",
        "Digitalização dos Serviços Bancários e FinTech",
        "Privatização de Ativos Estatais Críticos",
        "Incremento na Exploração de Diamantes",
      ],
      correctIndex: 1,
      hint: "Pense no setor que mais recebeu investimento em infraestrutura digital.",
    ),
    const QuizQuestion(
      id: "q2",
      category: "POLÍTICA MONETÁRIA",
      question: "Qual é o principal objectivo do Banco Nacional de Angola (BNA) ao subir as taxas de juro directoras?",
      options: [
        "Aumentar o consumo interno",
        "Ancorar as expectativas de inflação",
        "Desvalorizar o Kwanza",
        "Reduzir as reservas internacionais",
      ],
      correctIndex: 1,
      hint: "Relaciona-se com o controlo da subida generalizada de preços.",
    ),
    const QuizQuestion(
      id: "q3",
      category: "COMÉRCIO EXTERNO",
      question: "Qual destes produtos ainda domina as exportações angolanas?",
      options: ["Café", "Petróleo bruto", "Diamantes lapidados", "Têxteis"],
      correctIndex: 1,
      hint: "É o recurso mais associado historicamente à economia angolana.",
    ),
  ];

  Future<List<QuizQuestion>> fetchQuestions() async => _questions;
}
