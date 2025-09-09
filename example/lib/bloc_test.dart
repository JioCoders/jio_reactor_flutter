import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define API states
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiObjectLoaded extends ApiState {
  final String data;
  ApiObjectLoaded(this.data);
}

class ApiListLoaded extends ApiState {
  final List<dynamic> data; // Changed to List since API returns array
  ApiListLoaded(this.data);
}

class ApiError extends ApiState {
  final String message;
  ApiError(this.message);
}

class ApiBloc {
  // BehaviorSubject to hold the current state
  final _stateSubject = BehaviorSubject<ApiState>();

  // Stream to expose the state
  Stream<ApiState> get stateStream => _stateSubject.stream;

  // Subject to handle fetch data events with debounce
  final _fetchSubject = PublishSubject<void>();

  ApiBloc() {
    _stateSubject.add(ApiInitial());

    _fetchSubject
        .debounceTime(Duration(milliseconds: 500))
        .listen((_) => _fetchData());
  }

  // Function to add fetch events
  void fetchData() {
    debugPrint("fetchData--------requested");
    _fetchSubject.add(null);
  }

  Future<void> _fetchData() async {
    _stateSubject.add(ApiLoading());

    try {
      debugPrint("fetchData--------fetching");
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );
      debugPrint("fetchData--------done>> Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // The API returns a list of products, not an object with 'title'
        _stateSubject.add(ApiListLoaded(data)); // Pass the entire list
        // _stateSubject.add(ApiLoaded(data['title']));
      } else {
        _stateSubject.add(ApiError('Failed to fetch data'));
      }
    } catch (e) {
      _stateSubject.add(ApiError(e.toString()));
    }
  }

  void dispose() {
    _stateSubject.close();
    _fetchSubject.close();
  }
}

class MyBlocApp extends StatelessWidget {
  const MyBlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiBloc apiBloc = ApiBloc();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('RxDart HTTP without flutter_bloc')),
        body: StreamBuilder<ApiState>(
          stream: apiBloc.stateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;

            if (state is ApiInitial) {
              return Center(child: Text('Press button to fetch data'));
            } else if (state is ApiLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ApiListLoaded) {
              return Center(child: Text('Data: ${state.data}'));
            } else if (state is ApiError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => apiBloc.fetchData(),
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
