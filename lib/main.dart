// import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
// import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
// import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
// import 'package:ecommerce_app/features/product/presentation/pages/home_page.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
// import 'package:ecommerce_app/features/profile/presentation/pages/profile_form.dart';
// import 'package:ecommerce_app/firebase_options.dart';
// import 'package:ecommerce_app/service_locator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   serviceLocator();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) =>
//               getIt<AuthBloc>()..add(GetCurrentUserIdFromLocalEvent()),
//         ),
//         BlocProvider<ProfileBloc>(
//           create: (context) => getIt<ProfileBloc>()..add(CheckProfileStatusEvent()),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         routes: {
//           '/': (context) => AuthStateWrapper(),
//           '/login': (context) => LoginPage(),
//           '/signup': (context) => SignUpPage(),
//           '/profile-form': (context) => ProfilePage(),
//           '/home': (context) => HomePage(),
//         },
//       ),
//     );
//   }
// }

// class AuthStateWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
        
//         if (state is UserPresent) {
//           // BlocProvider.of<ProfileBloc>(context).add(CheckProfileStatusEvent());
//            return BlocBuilder<ProfileBloc, ProfileState>(
//             builder: (context, profileState) {
//               if (profileState is ProfileStatusCompleteState) {
//                 return const  HomePage();  
//               }
//               if (profileState is ProfileStatusIncompleteState) {
//                 return ProfilePage();  
//               }
              
//               return const  Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             },
//           );
//         }
//         return LoginPage();  
//       },
//     );
//   }

//   // Widget build(BuildContext context) {
//   //   return BlocBuilder<AuthBloc, AuthState>(
//   //     builder: (context, state) {
//   //       print("This is state: $state");
//   //       if (state is UserPresent) {
//   //         return ProfilePage();
//   //       }
//   //       return LoginPage();
//   //     },
//   //   );
//   // }
// }



import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/profile/presentation/pages/profile_form.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  serviceLocator();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(GetCurrentUserIdFromLocalEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => getIt<ProfileBloc>()..add(CheckProfileStatusEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthStateWrapper(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/profile-form': (context) => ProfilePage(),
          '/home': (context) => HomePage(),
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
           return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              if (profileState is ProfileStatusCompleteState) {
                return const  HomePage();  
              }
              if (profileState is ProfileStatusIncompleteState) {
                return ProfilePage();  
              }
              return const  Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }
        else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSignedIn) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              print("main profile state: $profileState");
              if (profileState is ProfileStatusCompleteState) {
                return const HomePage();
              } else if (profileState is ProfileStatusIncompleteState) {
                return ProfilePage();
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }  else {
          return LoginPage();
        }
      },
    );
  }
}
