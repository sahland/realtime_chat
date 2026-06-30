import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';
import 'rooms_event.dart';
import 'rooms_state.dart';

export 'rooms_event.dart';
export 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final ChatRepository _repository;

  RoomsBloc({required ChatRepository repository})
      : _repository = repository,
        super(const RoomsInitial()) {
    on<RoomsLoadRequested>(_onLoadRequested);
    on<RoomCreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    RoomsLoadRequested event,
    Emitter<RoomsState> emit,
  ) async {
    emit(const RoomsLoading());
    try {
      final results = await Future.wait([
        _repository.getRooms(event.userId),
        _repository.getUsers(),
      ]);

      final rooms = results[0] as List<RoomModel>;
      final users = results[1] as List<UserModel>;

      final usersMap = {for (final u in users) u.id: u};

      emit(RoomsLoaded(rooms: rooms, usersMap: usersMap));
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    RoomCreateRequested event,
    Emitter<RoomsState> emit,
  ) async {
    try {
      await _repository.createDirectRoom(
        userAId: event.currentUserId,
        userBId: event.targetUserId,
      );
      add(RoomsLoadRequested(userId: event.currentUserId));
    } catch (e) {
      emit(RoomsError(message: e.toString()));
    }
  }
}
