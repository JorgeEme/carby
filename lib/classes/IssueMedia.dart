class IssueMedia {
  //  'issue_id', 'media'
  final int issue_id;
  final String media;

  const IssueMedia({
    required this.issue_id,
    required this.media,
  });

  factory IssueMedia.fromJson(Map<String, dynamic> json) {
    return IssueMedia(
      issue_id: json['issue_id'],
      media: json['media'],
    );
  }
}
