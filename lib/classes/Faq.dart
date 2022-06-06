class Faq {
  //  'question', 'answer'
  final String question;
  final String answer;

  const Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
