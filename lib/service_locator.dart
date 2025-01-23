import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasource/remote_datasource.dart';
import 'package:ecommerce_app/features/auth/data/repositories/respositories_impl.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/get_uid_from_local_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_google_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signup_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/product/data/datasource/remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/repositories/repository_imp.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:ecommerce_app/features/product/domain/usecase/add_item_to_cart_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_cart_items_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_favourite_products_id_usercase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/remove_item_from_cart_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/toggle_favourite_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/profile/data/datasource/remote_data_source.dart';
import 'package:ecommerce_app/features/profile/data/repositories/profile_repositories_impl.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repositories.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/checkprofilestatus_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/getprofile_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/saveprofile_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> serviceLocator() async {
  // auth feature
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
    () => AuthRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<SignUpWithEmailPassword>(
    () => SignUpWithEmailPassword(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<SignInWithEmailPassword>(
    () => SignInWithEmailPassword(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogle(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<SignOut>(
    () => SignOut(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<GetUidFromLocalDataSource>(
    () => GetUidFromLocalDataSource(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(
      getIt(),
    ),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signUpWithEmailPassword: getIt(),
      signInWithEmailPassword: getIt(),
      signInWithGoogle: getIt(),
      signOut: getIt(),
      getUidFromLocalDataSource: getIt(),
      forgotPassword: getIt(),
    ),
  );

  // profile feature

  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileRemoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<CheckprofilestatusUsecase>(
    () => CheckprofilestatusUsecase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<GetprofileUsecase>(
    () => GetprofileUsecase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<UpdateprofileUsecase>(
    () => UpdateprofileUsecase(
      getIt(),
    ),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      saveProfileUseCase: getIt(),
      updateprofileUsecase: getIt(),
      getProfileUsecase: getIt(),
      checkProfileStatusUsecase: getIt(),
    ),
  );

  // product feature
  getIt.registerLazySingleton(
    () => http.Client(),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<GetProductsUsecase>(
    () => GetProductsUsecase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<ToggleFavouriteUsecase>(
    () => ToggleFavouriteUsecase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<GetFavouriteProductsIdUsercase>(
    () => GetFavouriteProductsIdUsercase(
      getIt(),
    ),
  );

  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(
      getProductsUsecase: getIt(),
      toggleFavouriteUsecase: getIt(),
      getFavouriteProductsIdUsercase: getIt(),
    ),
  );

  // cart feature
  getIt.registerLazySingleton<AddItemToCartUsecase>(
    () => AddItemToCartUsecase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<GetCartItemsUsecase>(
    () => GetCartItemsUsecase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<RemoveItemFromCartUsecase>(
    () => RemoveItemFromCartUsecase(
      getIt(),
    ),
  );

  getIt.registerFactory<CartBloc>(
    () => CartBloc(
      getProductsUsecase: getIt(),
      addItemToCart: getIt(),
      getCartItems: getIt(),
      removeItemFromCart: getIt(),
    ),
  );

}
