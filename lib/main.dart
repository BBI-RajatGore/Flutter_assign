import 'package:ecommerce_app/features/auth/presentation/pages/auth_wrapper_page.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/pages/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
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
        BlocProvider<ProfileBloc>(create: (context) => getIt<ProfileBloc>()),
        BlocProvider<ProductBloc>(create: (context) => getIt<ProductBloc>()),
        BlocProvider<CartBloc>(create: (context) => getIt<CartBloc>()..add(GetProductEventForCart())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthStateWrapper(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/bottom-nav': (context) => BottomNavigationPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/profile-form') {
            final isEdit = settings.arguments as bool;
            if (isEdit) {
              return MaterialPageRoute(
                builder: (context) => ProfileForm(isEdit: isEdit),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
