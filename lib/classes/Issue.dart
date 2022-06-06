class Issue {
  //  'journey_id', 'description'
  final int journey_id;
  final String description;

  const Issue({
    required this.journey_id,
    required this.description,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      journey_id: json['journey_id'],
      description: json['description'],
    );
  }
}
