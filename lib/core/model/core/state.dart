class AppState {
  final String id;
  final String? name;
  final String? code;

  AppState({required this.id, required this.name, required this.code});

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
        id: map["id"].toString(), name: map["name"], code: map["code"]);
  }
}
