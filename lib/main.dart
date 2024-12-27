import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()
            ..add(
              CheckUserStatusEvent(),
            ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthStateWrapper(),
      ),
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserPresent) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(userId: state.userId),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateUserScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator(),);
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
