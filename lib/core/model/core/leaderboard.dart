class LeaderboardResponse {
  final String message;
  final List<LeaderboardItem> data;

  LeaderboardResponse({
    required this.message,
    required this.data,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => LeaderboardItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaderboardItem {
  final int rank;
  final String name;
  final String email;
  final String? avatar;
  final int value;
  final String joinedAt;

  LeaderboardItem({
    required this.rank,
    required this.name,
    required this.email,
    this.avatar,
    required this.value,
    required this.joinedAt,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      rank: json['rank'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'],
      value: json['value'] as int,
      joinedAt: json['joined_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'name': name,
      'email': email,
      'avatar': avatar,
      'value': value,
      'joined_at': joinedAt,
    };
  }
}
