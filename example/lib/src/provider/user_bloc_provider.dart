
// InheritedWidget for dependency injection
import 'package:example/src/provider/user_bloc.dart';
import 'package:flutter/widgets.dart';

class UserBlocProvider extends InheritedWidget {
  final UserBloc userBloc;

  const UserBlocProvider({
    Key? key,
    required this.userBloc,
    required Widget child,
  }) : super(key: key, child: child);

  static UserBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserBlocProvider>();
    assert(provider != null, 'UserBlocProvider not found in context');
    return provider!.userBloc;
  }

  @override
  bool updateShouldNotify(UserBlocProvider oldWidget) {
    return userBloc != oldWidget.userBloc;
  }
}
