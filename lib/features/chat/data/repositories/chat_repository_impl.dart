import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/api_failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/ask_result_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._remote, this._local);

  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;

  static const ChatThread _emptyThread = ChatThread(
    id: '',
    title: '',
    messages: <ChatMessage>[],
  );

  @override
  Future<Either<Failure, ChatThread>> loadHistory() async {
    final String? conversationId = await _local.readConversationId();
    if (conversationId == null) {
      return const Right<Failure, ChatThread>(_emptyThread);
    }
    try {
      final ChatThread thread = await _remote.readThread(conversationId);
      return Right<Failure, ChatThread>(thread);
    } on DioException catch (error) {
      if (error.response?.statusCode != HttpStatus.notFound) {
        return Left<Failure, ChatThread>(ApiFailureMapper.of(error));
      }
      await _local.clearConversationId();
      return const Right<Failure, ChatThread>(_emptyThread);
    } on Object catch (error) {
      return Left<Failure, ChatThread>(ApiFailureMapper.of(error));
    }
  }

  @override
  Future<Either<Failure, ChatThread>> ask(String question) async {
    try {
      final AskResultModel result = await _askInThread(question);
      await _local.writeConversationId(result.conversationId);
      final ChatThread thread = await _remote.readThread(result.conversationId);
      return Right<Failure, ChatThread>(thread);
    } on Object catch (error) {
      return Left<Failure, ChatThread>(ApiFailureMapper.of(error));
    }
  }

  Future<AskResultModel> _askInThread(String question) async {
    final String? conversationId = await _local.readConversationId();
    if (conversationId == null) {
      return _remote.ask(question: question);
    }
    try {
      return await _remote.ask(
        question: question,
        conversationId: conversationId,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode != HttpStatus.notFound) {
        rethrow;
      }
      await _local.clearConversationId();
      return _remote.ask(question: question);
    }
  }
}
