import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat_thread.dart';
import '../repositories/chat_repository.dart';

class LoadChatHistory implements UseCase<ChatThread, NoParams> {
  const LoadChatHistory(this._repository);

  final ChatRepository _repository;

  @override
  Future<Either<Failure, ChatThread>> call(NoParams params) {
    return _repository.loadHistory();
  }
}
