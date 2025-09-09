
// User List Screen - Now StatelessWidget
import 'package:example/src/provider/user_bloc.dart';
import 'package:example/src/provider/user_bloc_provider.dart';
import 'package:example/src/provider/user_detail_screen.dart';
import 'package:example/src/provider/user_state.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = UserBlocProvider.of(context);
    
    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userBloc.currentState.users.isEmpty && 
          userBloc.currentState.loadingState == LoadingState.idle) {
        userBloc.loadUsers();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => userBloc.loadUsers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Counter Section
          _buildCounterSection(userBloc),
          // Divider
          Divider(height: 1, thickness: 1),
          // User List
          Expanded(
            child: StreamBuilder<UserState>(
              stream: userBloc.state,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final state = snapshot.data!;

                return Stack(
                  children: [
                    _buildMainContent(context, state, userBloc),
                    _buildErrorHandler(context, userBloc),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection(UserBloc userBloc) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Counter Demo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // Counter Display
              StreamBuilder<int>(
                stream: userBloc.counter,
                builder: (context, snapshot) {
                  final counter = snapshot.data ?? 0;
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      'Counter: $counter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Counter Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => userBloc.decrementCounter(),
                    icon: Icon(Icons.remove),
                    label: Text('Decrement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => userBloc.incrementCounter(),
                    icon: Icon(Icons.add),
                    label: Text('Increment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Text Field Section
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: userBloc.textFieldValue,
                      builder: (context, snapshot) {
                        return TextField(
                          onChanged: (value) => userBloc.updateTextFieldValue(value),
                          decoration: InputDecoration(
                            labelText: 'Enter counter value',
                            hintText: 'Type a number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.edit),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: snapshot.data ?? '',
                          )..selection = TextSelection.collapsed(
                            offset: (snapshot.data ?? '').length,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => userBloc.setCounterFromTextField(),
                    child: Text('Set'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Reset Button
              OutlinedButton.icon(
                onPressed: () => userBloc.resetCounter(),
                icon: Icon(Icons.refresh),
                label: Text('Reset All'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade600,
                  side: BorderSide(color: Colors.orange.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, UserState state, UserBloc userBloc) {
    if (state.loadingState == LoadingState.loading && state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading users...'),
          ],
        ),
      );
    }

    if (state.users.isEmpty && state.loadingState == LoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load users'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => userBloc.retry(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        userBloc.loadUsers();
        await userBloc.state
            .where((state) => state.loadingState != LoadingState.loading)
            .first;
      },
      child: ListView.builder(
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user.name.substring(0, 1)),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailScreen(userId: user.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorHandler(BuildContext context, UserBloc userBloc) {
    return StreamBuilder<String>(
      stream: userBloc.errorStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.data!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => userBloc.retry(),
                ),
              ),
            );
          });
        }
        return SizedBox.shrink();
      },
    );
  }
}
