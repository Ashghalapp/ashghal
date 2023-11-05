class AppCategory {
  final int id;
  final String name;

  AppCategory({required this.id, required this.name});

  factory AppCategory.fromJson(Map<String, dynamic> json) {
    return AppCategory(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
    );
  }

  static List<AppCategory> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => AppCategory.fromJson(json)).toList();
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
