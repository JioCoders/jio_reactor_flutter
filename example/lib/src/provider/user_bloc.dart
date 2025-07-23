
// Enhanced BLoC with lifecycle management
import 'package:example/src/provider/api_service.dart';
import 'package:example/src/provider/todo_model.dart';
import 'package:example/src/provider/user_state.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();
  
  // Private subjects
  final BehaviorSubject<UserState> _stateSubject = 
      BehaviorSubject<UserState>.seeded(UserState());
  
  // Navigation and side effects
  final PublishSubject<String> _errorSubject = PublishSubject<String>();
  final PublishSubject<void> _refreshSubject = PublishSubject<void>();
  
  // Public streams
  Stream<UserState> get state => _stateSubject.stream;
  Stream<LoadingState> get loadingState => 
      _stateSubject.stream.map((state) => state.loadingState).distinct();
  Stream<List<User>> get users => 
      _stateSubject.stream.map((state) => state.users).distinct();
  Stream<User?> get selectedUser => 
      _stateSubject.stream.map((state) => state.selectedUser).distinct();
  Stream<String?> get error => 
      _stateSubject.stream.map((state) => state.error).distinct();
  Stream<bool> get isDetailLoading => 
      _stateSubject.stream.map((state) => state.isDetailLoading).distinct();
  Stream<int> get counter => 
      _stateSubject.stream.map((state) => state.counter).distinct();
  Stream<String> get textFieldValue => 
      _stateSubject.stream.map((state) => state.textFieldValue).distinct();
  
  // Side effect streams
  Stream<String> get errorStream => _errorSubject.stream;
  Stream<void> get refreshStream => _refreshSubject.stream;

  // Current state getter
  UserState get currentState => _stateSubject.value;

  // Constructor
  UserBloc() {
    WidgetsBinding.instance.addObserver(this);
    
    // Listen to errors for side effects
    _stateSubject.stream
        .map((state) => state.error)
        .distinct()
        .where((error) => error != null)
        .listen((error) => _errorSubject.add(error!));
  }

  // Lifecycle management
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('App resumed');
        // Could refresh data here if needed
        break;
      case AppLifecycleState.paused:
        print('App paused');
        break;
      case AppLifecycleState.detached:
        print('App detached');
        break;
      case AppLifecycleState.inactive:
        print('App inactive');
        break;
      case AppLifecycleState.hidden:
        print('App hidden');
        break;
    }
  }

  // Actions
  void loadUsers() async {
    _stateSubject.add(currentState.copyWith(
      loadingState: LoadingState.loading,
      error: null,
    ));

    try {
      final users = await _apiService.fetchUsers();
      _stateSubject.add(currentState.copyWith(
        loadingState: LoadingState.success,
        users: users,
      ));
    } catch (e) {
      _stateSubject.add(currentState.copyWith(
        loadingState: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  void loadUser(int userId) async {
    _stateSubject.add(currentState.copyWith(
      isDetailLoading: true,
      error: null,
    ));

    try {
      final user = await _apiService.fetchUser(userId);
      _stateSubject.add(currentState.copyWith(
        isDetailLoading: false,
        selectedUser: user,
      ));
    } catch (e) {
      _stateSubject.add(currentState.copyWith(
        isDetailLoading: false,
        error: e.toString(),
      ));
    }
  }

  void clearSelectedUser() {
    _stateSubject.add(currentState.copyWith(
      selectedUser: null,
      isDetailLoading: false,
    ));
  }

  void retry() {
    if (currentState.users.isEmpty) {
      loadUsers();
    }
  }

  void triggerRefresh() {
    _refreshSubject.add(null);
  }

  // Counter actions
  void incrementCounter() {
    _stateSubject.add(currentState.copyWith(
      counter: currentState.counter + 1,
    ));
  }

  void decrementCounter() {
    _stateSubject.add(currentState.copyWith(
      counter: currentState.counter - 1,
    ));
  }

  void updateTextFieldValue(String value) {
    _stateSubject.add(currentState.copyWith(
      textFieldValue: value,
    ));
  }

  void setCounterFromTextField() {
    final value = int.tryParse(currentState.textFieldValue) ?? 0;
    _stateSubject.add(currentState.copyWith(
      counter: value,
    ));
  }

  void resetCounter() {
    _stateSubject.add(currentState.copyWith(
      counter: 0,
      textFieldValue: '',
    ));
  }

  // Dispose
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSubject.close();
    _errorSubject.close();
    _refreshSubject.close();
  }
}
