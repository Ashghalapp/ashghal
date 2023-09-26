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
    required String? jobName,
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'job_name': jobName,
      'job_desc': jobDesc,
      'category_id': categoryId,
    };
  }
}
