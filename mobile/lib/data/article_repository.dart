import "../models/article.dart";

class ArticleRepository {
  static final List<Article> _articles = [
    const Article(
      id: "a1",
      category: "ANÁLISE ESTRATÉGICA",
      title: "A dependência do Petróleo de Angola: uma década de mudanças",
      description:
          "Analisando as reformas estruturais no setor petrolífero e o roteiro de longo prazo para a diversificação fiscal além do crude.",
      imageUrl: "https://images.unsplash.com/photo-1502920917128-1aa500764cbd",
      readTime: "5 min",
      type: ArticleType.texto,
      body:
          "Ao longo da última década, Angola tem procurado reduzir a sua dependência histórica das receitas petrolíferas. "
          "Este artigo detalha as principais reformas fiscais, os investimentos em novos setores produtivos e os desafios "
          "que ainda persistem no caminho da diversificação económica.",
    ),
    const Article(
      id: "a2",
      category: "RELATÓRIO DE OPORTUNIDADE",
      title: "Potencial Agrícola: O Celeiro do Huambo",
      description:
          "Como a província do Huambo se posiciona como um dos principais polos de produção agrícola do país.",
      imageUrl: "https://images.unsplash.com/photo-1500937386664-56d1dfef3854",
      readTime: "12 min",
      type: ArticleType.texto,
      body:
          "O Huambo, historicamente conhecido como o celeiro de Angola, tem vindo a recuperar a sua vocação agrícola "
          "com o apoio de programas de mecanização e crédito rural, contribuindo de forma crescente para o PIB não petrolífero.",
    ),
    const Article(
      id: "a3",
      category: "MINERAÇÃO",
      title: "Iniciativa de Transparência do Sector de Diamantes",
      description:
          "Como as novas tecnologias de rastreamento blockchain estão elevando o valor da produção artesanal angolana.",
      imageUrl: "",
      hasImage: false,
      readTime: "17 min",
      type: ArticleType.texto,
      body:
          "A introdução de sistemas de rastreamento baseados em blockchain no sector diamantífero angolano promete "
          "aumentar a transparência da cadeia de valor e valorizar a produção artesanal certificada.",
    ),
    const Article(
      id: "a4",
      category: "FINANCE",
      title: "Estabilidade do Kwanza e o Banco Central",
      description:
          "Uma análise aprofundada das recentes ajustes de política monetária e das metas de inflação do BNA.",
      imageUrl: "",
      hasImage: false,
      readTime: "20 min",
      type: ArticleType.podcast,
      body:
          "O Banco Nacional de Angola tem adotado uma política monetária mais restritiva nos últimos trimestres, "
          "com o objetivo de ancorar as expectativas de inflação e estabilizar o valor do Kwanza face às principais divisas.",
    ),
  ];

  Future<List<Article>> fetchAll() async => _articles;

  Future<List<Article>> fetchByType(ArticleType? type) async {
    if (type == null) return _articles;
    return _articles.where((a) => a.type == type).toList();
  }

  Future<Article?> fetchById(String id) async {
    try {
      return _articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
