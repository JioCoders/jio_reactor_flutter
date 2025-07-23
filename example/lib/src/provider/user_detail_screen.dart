
// User Detail Screen - Now StatelessWidget
import 'package:example/src/provider/user_bloc_provider.dart';
import 'package:example/src/provider/user_state.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = UserBlocProvider.of(context);
    
    // Initialize user loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userBloc.currentState.selectedUser?.id != userId) {
        userBloc.loadUser(userId);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        userBloc.clearSelectedUser();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Details'),
        ),
        body: StreamBuilder<UserState>(
          stream: userBloc.state,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final state = snapshot.data!;

            if (state.isDetailLoading || state.selectedUser == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading user details...'),
                  ],
                ),
              );
            }

            final user = state.selectedUser!;

            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 16),
                          _buildInfoRow('Name', user.name),
                          _buildInfoRow('Username', user.username),
                          _buildInfoRow('Email', user.email),
                          _buildInfoRow('ID', user.id.toString()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<bool>(
                    stream: userBloc.isDetailLoading,
                    builder: (context, snapshot) {
                      final isLoading = snapshot.data ?? false;
                      return ElevatedButton(
                        onPressed: isLoading 
                            ? null 
                            : () => userBloc.loadUser(userId),
                        child: isLoading 
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('Refresh'),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}