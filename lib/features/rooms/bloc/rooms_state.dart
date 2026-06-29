import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

sealed class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object?> get props => [];
}

class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

class RoomsLoaded extends RoomsState {
  final List<RoomModel> rooms;

  const RoomsLoaded({required this.rooms});

  @override
  List<Object?> get props => [rooms];
}

class RoomsError extends RoomsState {
  final String message;

  const RoomsError({required this.message});

  @override
  List<Object?> get props => [message];
}
