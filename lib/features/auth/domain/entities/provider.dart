
class Provider {
  int pId;
  String jobName;
  String? jobDesc;
  int categoryId;
  DateTime pCreatedAt;
  DateTime pUpdatedAt;

  Provider({
    required this.pId,
    required this.jobName,
    this.jobDesc,
    required this.categoryId,
    required this.pCreatedAt,
    required this.pUpdatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json){
    return Provider(
      pId: json['id'],
      jobName: json['job_name'],
      jobDesc: json['job_desc'],
      categoryId: json['category_id'],
      pCreatedAt: json['created_at'],
      pUpdatedAt: json['updated_at'],
    );
  }

  Map<String, Object?> toJson(){
    return {
      'job_name': jobName,
      'job_desc': jobDesc,
      'category_id': categoryId,
    };
  }
}
