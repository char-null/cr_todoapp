class Todo {
  int? id;
  String title;
  String content;
  String isCompleted;
  String writedDate;
  Todo({
    this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.writedDate,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      isCompleted: json["isCompleted"],
      writedDate: json["writedDate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "isCompleted": isCompleted,
        "writedDate": writedDate,
      };
}
