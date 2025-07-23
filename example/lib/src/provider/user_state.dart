
// State Management with RxDart
import 'package:example/src/provider/todo_model.dart';

enum LoadingState { idle, loading, success, error }

class UserState {
  final LoadingState loadingState;
  final List<User> users;
  final User? selectedUser;
  final String? error;
  final bool isDetailLoading;
  final int counter;
  final String textFieldValue;

  UserState({
    this.loadingState = LoadingState.idle,
    this.users = const [],
    this.selectedUser,
    this.error,
    this.isDetailLoading = false,
    this.counter = 0,
    this.textFieldValue = '',
  });

  UserState copyWith({
    LoadingState? loadingState,
    List<User>? users,
    User? selectedUser,
    String? error,
    bool? isDetailLoading,
    int? counter,
    String? textFieldValue,
  }) {
    return UserState(
      loadingState: loadingState ?? this.loadingState,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      error: error ?? this.error,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      counter: counter ?? this.counter,
      textFieldValue: textFieldValue ?? this.textFieldValue,
    );
  }
}
