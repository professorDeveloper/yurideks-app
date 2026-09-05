import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/usecases/ask_question.dart';
import '../../domain/usecases/load_chat_history.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._askQuestion, this._loadChatHistory)
      : super(const ChatLoaded(messages: <ChatMessage>[])) {
    on<ChatOpened>(_onOpened);
    on<ChatQuestionSubmitted>(_onSubmitted);
  }

  static const String _pendingIdPrefix = 'pending-';

  final AskQuestion _askQuestion;
  final LoadChatHistory _loadChatHistory;

  int _counter = 0;

  Future<void> _onOpened(ChatOpened event, Emitter<ChatState> emit) async {
    final ChatState current = state;
    if (current is! ChatLoaded ||
        current.messages.isNotEmpty ||
        current.isThinking ||
        current.isRestoring) {
      return;
    }

    emit(current.copyWith(isRestoring: true));
    final Either<Failure, ChatThread> result = await _loadChatHistory(
      const NoParams(),
    );

    final ChatState latest = state;
    if (latest is! ChatLoaded) {
      return;
    }
    emit(
      result.fold(
        (Failure failure) => latest.copyWith(isRestoring: false),
        (ChatThread thread) => latest.copyWith(
          messages: <ChatMessage>[...thread.messages, ...latest.messages],
          isRestoring: false,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    ChatQuestionSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    final String question = event.question.trim();
    final ChatState current = state;
    if (question.isEmpty || current is! ChatLoaded || current.isThinking) {
      return;
    }

    _counter++;
    final ChatMessage asked = ChatMessage(
      id: '$_pendingIdPrefix$_counter',
      author: MessageAuthor.citizen,
      content: question,
    );
    emit(
      current.copyWith(
        messages: <ChatMessage>[...current.messages, asked],
        isThinking: true,
      ),
    );

    final Either<Failure, ChatThread> result = await _askQuestion(
      AskQuestionParams(question),
    );

    final ChatState latest = state;
    if (latest is! ChatLoaded) {
      return;
    }
    emit(
      result.fold(
        (Failure failure) => latest.copyWith(
          isThinking: false,
          errorMessage: FailureMessage.of(failure),
        ),
        (ChatThread thread) => latest.copyWith(
          messages: thread.messages,
          isThinking: false,
        ),
      ),
    );
  }
}
