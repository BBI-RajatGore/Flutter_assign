import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/product/presentation/pages/cart_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/wishlist_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/product_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
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
        BlocProvider<ProfileBloc>(
          create: (context) => getIt<ProfileBloc>()..add(GetProfileEvent(),),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthStateWrapper(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/profile-form': (context) => ProfileForm(),
          '/bottom-nav': (context) =>  BottomNavigationPage(),
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
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSignedIn) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              if (profileState is ProfileStatusCompleteState) {
                return  BottomNavigationPage();
              } else if (profileState is ProfileInitialState || profileState is ProfileLoadingState) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator(),),
                );
              }  else {

                print("nowwwww ${profileState}");
                return ProfileForm();
              }
            },
          );
        } else if(state is AuthFailure){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          });
          return LoginPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}



class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {

  int _selectedIndex = 0;


  final List<Widget> _pages = [
    ProductPage(),
    CartPage(),
    WishlistPage(),
    // ProductProfilePage(),
    ProfilePage()
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        backgroundColor: Colors.teal.shade50,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            activeIcon: Icon(Icons.home, size: 30),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 30),
            activeIcon: Icon(Icons.shopping_cart, size: 30),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 30),
            activeIcon: Icon(Icons.favorite, size: 30),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, size: 30),
            activeIcon: Icon(Icons.account_circle, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
