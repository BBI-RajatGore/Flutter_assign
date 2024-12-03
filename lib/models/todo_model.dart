class Todo {
  String title;
  String description;
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
    required this.description,
  });
  
}
