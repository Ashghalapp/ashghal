class Provider {
  final int? id;
  final String? jobName;
  final String? jobDesc;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Provider._({
    this.id,
    this.jobName,
    this.jobDesc,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Provider.addRequest({
    required String jobName,
    String? jobDesc,
    required int? categoryId,
  }) =>
      Provider._(jobName: jobName, jobDesc: jobDesc, categoryId: categoryId);

  factory Provider.updateRequest({
    String? jobName,
    String? jobDesc,
    int? categoryId,
  }) =>
      Provider._(jobName: jobName, jobDesc: jobDesc, categoryId: categoryId);

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider._(
      id: json['id'],
      jobName: json['job_name'],
      jobDesc: json['job_desc'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (jobName != null) 'job_name': jobName,
      if (jobDesc != null) 'job_desc': jobDesc,
      if (categoryId != null) 'category_id': categoryId,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
