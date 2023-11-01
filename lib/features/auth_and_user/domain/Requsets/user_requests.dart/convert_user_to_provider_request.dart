class ConvertClientToProviderRequest {
  int categoryId;
  String jobName;
  String? jobDesc;

  ConvertClientToProviderRequest({
    required this.categoryId,
    required this.jobName,
    this.jobDesc,
  });

  Map<String, Object> toJson() {
    return {
      'category_id': categoryId,
      'job_name': jobName,
      if (jobDesc != null) 'job_desc': jobDesc!,
    };
  }
}
