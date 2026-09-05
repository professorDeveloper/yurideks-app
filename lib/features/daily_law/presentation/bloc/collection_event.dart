part of 'collection_bloc.dart';

sealed class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class CollectionRequested extends CollectionEvent {
  const CollectionRequested();
}
