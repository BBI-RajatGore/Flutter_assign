import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        initialRoute: Routes.initialRoute,  
        routes: {
          Routes.initialRoute:(context)=> AuthStateWrapper(),
          Routes.createUserScreen:(context) => CreateUserScreen()
        },
        onGenerateRoute: (settings){

          if(settings.name == Routes.taskScreen){
            final userId = settings.arguments as String?;
            if(userId != null){
              return MaterialPageRoute(
                builder: (context) => TaskScreen(userId: userId),
              );
            }
          }

          if(settings.name == Routes.addTaskScreen){
            final arguments = settings.arguments as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            final task = arguments['task'] as UserTask?;

            return MaterialPageRoute(
              builder: (context) => AddTaskScreen(userId: userId, task: task),
            );
          }

          return null;
        },
      ),
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is UserPresent) {
          return TaskScreen(userId: state.userId);
        }
        return CreateUserScreen();
      },
    );
  }
}
