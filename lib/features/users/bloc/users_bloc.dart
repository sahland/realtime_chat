import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import 'users_event.dart';
import 'users_state.dart';

export 'users_event.dart';
export 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final ChatRepository _repository;

  UsersBloc({required ChatRepository repository})
      : _repository = repository,
        super(const UsersInitial()) {
    on<UsersLoadRequested>(_onLoadRequested);
    on<UserCreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    UsersLoadRequested event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersLoading());
    try {
      final users = await _repository.getUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    UserCreateRequested event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.createUser(event.name);
      add(const UsersLoadRequested());
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }
}
