import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat_thread.dart';
import '../repositories/chat_repository.dart';

class AskQuestionParams extends Equatable {
  const AskQuestionParams(this.question);

  final String question;

  @override
  List<Object?> get props => <Object?>[question];
}

class AskQuestion implements UseCase<ChatThread, AskQuestionParams> {
  const AskQuestion(this._repository);

  final ChatRepository _repository;

  @override
  Future<Either<Failure, ChatThread>> call(AskQuestionParams params) {
    return _repository.ask(params.question);
  }
}
