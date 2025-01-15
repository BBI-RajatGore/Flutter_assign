import 'package:ecommerce_app/features/auth/data/datasource/local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasource/remote_datasource.dart';
import 'package:ecommerce_app/features/auth/data/repositories/respositories_impl.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/get_uid_from_local_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_google_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signup_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> serviceLocator() async {

  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<GoogleAuthProvider>(() => GoogleAuthProvider());

  getIt.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(
    getIt(),
  ));

  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
            getIt(),
            getIt(),
            getIt(),
          ));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(),getIt()),
  );

  getIt.registerLazySingleton<SignUpWithEmailPassword>(
    ()=> SignUpWithEmailPassword(getIt(),),
  );
  getIt.registerLazySingleton<SignInWithEmailPassword>(
   ()=> SignInWithEmailPassword(getIt(),),
  );
  getIt.registerLazySingleton<SignInWithGoogle>(
   () => SignInWithGoogle(getIt(),),
  );
  getIt.registerLazySingleton<SignOut>(
   ()=> SignOut(getIt(),),
  );
  getIt.registerLazySingleton<GetUidFromLocalDataSource>(
   ()=> GetUidFromLocalDataSource(getIt(),),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signUpWithEmailPassword: getIt(),
      signInWithEmailPassword: getIt(),
      signInWithGoogle: getIt(),
      signOut: getIt(),
      getUidFromLocalDataSource: getIt(),
    ),
  );
}
