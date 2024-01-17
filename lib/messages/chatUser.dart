import '../model/educatorModel.dart';

class ChatUser {
  late String image;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String lastMessage; // Add lastMessage property

  ChatUser({
    required this.image,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.lastMessage,
  });

  ChatUser.fromEducatorModel(EducatorModel educator) {
    image = '';
    name = '';
    createdAt = '';
    isOnline = false;
    id = '';
    lastActive = '';
    email = educator.educatorEmail;
    pushToken = '';
    lastMessage = ''; // Initialize lastMessage with an empty string
  }

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['photoURL'] ?? '';
    name = json['displayName'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    lastMessage = json['last_message'] ?? ''; // Parse lastMessage from JSON
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['photoURL'] = image;
    data['displayName'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['last_message'] = lastMessage; // Add lastMessage to JSON
    return data;
  }
}