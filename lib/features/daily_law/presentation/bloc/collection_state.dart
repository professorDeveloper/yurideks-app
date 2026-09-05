part of 'collection_bloc.dart';

sealed class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object?> get props => const <Object?>[];
}

class CollectionInitial extends CollectionState {
  const CollectionInitial();
}

class CollectionLoading extends CollectionState {
  const CollectionLoading();
}

class CollectionLoaded extends CollectionState {
  const CollectionLoaded({required this.laws, required this.catalogueSize});

  final List<DailyLaw> laws;
  final int catalogueSize;

  @override
  List<Object?> get props => <Object?>[laws, catalogueSize];
}

class CollectionError extends CollectionState {
  const CollectionError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
