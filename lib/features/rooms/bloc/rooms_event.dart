import 'package:equatable/equatable.dart';

sealed class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object?> get props => [];
}

class RoomsLoadRequested extends RoomsEvent {
  final String userId;

  const RoomsLoadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RoomCreateRequested extends RoomsEvent {
  final String currentUserId;
  final String targetUserId;

  const RoomCreateRequested({
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  List<Object?> get props => [currentUserId, targetUserId];
}
