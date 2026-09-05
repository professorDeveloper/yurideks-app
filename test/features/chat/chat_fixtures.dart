import 'package:yurideks_app/features/chat/data/datasources/chat_local_data_source.dart';

class MemoryChatLocalDataSource implements ChatLocalDataSource {
  MemoryChatLocalDataSource({this.conversationId});

  String? conversationId;
  int clears = 0;

  @override
  Future<String?> readConversationId() async => conversationId;

  @override
  Future<void> writeConversationId(String id) async => conversationId = id;

  @override
  Future<void> clearConversationId() async {
    conversationId = null;
    clears++;
  }
}

Map<String, dynamic> askResultJson(String conversationId) {
  return <String, dynamic>{
    'ok': true,
    'conversationId': conversationId,
    'messageId': 'm-generated',
  };
}

Map<String, dynamic> threadJson({
  required String id,
  required List<Map<String, dynamic>> messages,
  String title = 'Ish haqi',
}) {
  return <String, dynamic>{
    'id': id,
    'title': title,
    'createdAt': '2026-09-01T10:00:00Z',
    'messages': messages,
  };
}

Map<String, dynamic> citizenMessageJson(String id, String content) {
  return <String, dynamic>{
    'id': id,
    'author': 'CITIZEN',
    'content': content,
    'needsEscalation': false,
    'createdAt': '2026-09-01T10:00:00Z',
    'citations': <Map<String, dynamic>>[],
  };
}

Map<String, dynamic> assistantMessageJson(
  String id,
  String content, {
  List<Map<String, dynamic>> citations = const <Map<String, dynamic>>[],
  bool needsEscalation = false,
}) {
  return <String, dynamic>{
    'id': id,
    'author': 'ASSISTANT',
    'content': content,
    'needsEscalation': needsEscalation,
    'createdAt': '2026-09-01T10:00:05Z',
    'citations': citations,
  };
}

Map<String, dynamic> citationJson() {
  return <String, dynamic>{
    'id': 'law-1',
    'code': 'LABOR_CODE',
    'number': '175',
    'title': 'Ish haqini to‘lash muddati',
  };
}
