class Faq {
  final String id;
  final String name;
  final String slug;
  final String status;
  final DateTime? created_at;
  final List<FaqData> data;

  Faq(
      {required this.id,
      required this.name,
      required this.slug,
      required this.status,
      required this.created_at,
      required this.data});

  factory Faq.fromMap(Map<String, dynamic> map) {
    List<FaqData> emptyFaqs = [];
    return Faq(
      id: map["id"].toString(),
      name: map["name"] ?? "NA",
      slug: map["slug"] ?? "NA",
      status: map["status"] ?? "NA",
      created_at: DateTime.tryParse(map["created_at"]),
      data: (map["faqs"] == null)
          ? emptyFaqs
          : (map["faqs"] as List).map((e) => FaqData.fromMap(e)).toList(),
    );
  }
}

class FaqData {
  final String id;
  final String question;
  final String slug;
  final String answer;
  final DateTime? created_at;

  FaqData({
    required this.id,
    required this.question,
    required this.slug,
    required this.answer,
    required this.created_at,
  });

  factory FaqData.fromMap(Map<String, dynamic> map) {
    return FaqData(
      id: map["id"].toString(),
      question: map["question"] ?? "NA",
      slug: map["slug"] ?? "NA",
      answer: map["answer"] ?? "NA",
      created_at: DateTime.tryParse(map["created_at"]),
    );
  }
}
