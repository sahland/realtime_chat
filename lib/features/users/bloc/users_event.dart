import 'package:equatable/equatable.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class UsersLoadRequested extends UsersEvent {
  const UsersLoadRequested();
}

class UserCreateRequested extends UsersEvent {
  final String name;

  const UserCreateRequested({required this.name});

  @override
  List<Object?> get props => [name];
}
