import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/ask_result_model.dart';
import '../models/chat_thread_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<AskResultModel> ask({
    required String question,
    String? conversationId,
  });

  Future<ChatThreadModel> readThread(String conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl(this._client);

  static const String _askPath = '/api/ask';
  static const String _conversationsPath = '/api/conversations';

  final ApiClient _client;

  @override
  Future<AskResultModel> ask({
    required String question,
    String? conversationId,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{'question': question};
    if (conversationId != null) {
      body['conversationId'] = conversationId;
    }
    final Response<dynamic> response = await _client.post(_askPath, body: body);
    return AskResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ChatThreadModel> readThread(String conversationId) async {
    final Response<dynamic> response = await _client.get(
      '$_conversationsPath/$conversationId',
    );
    return ChatThreadModel.fromJson(response.data as Map<String, dynamic>);
  }
}
