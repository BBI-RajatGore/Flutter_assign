import 'package:ecommerce_app/features/profile/domain/usecase/checkprofilestatus_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/getprofile_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/saveprofile_usecase.dart';
import 'package:ecommerce_app/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SaveProfileUseCase saveProfileUseCase;
  final UpdateprofileUsecase updateprofileUsecase;
  final GetprofileUsecase getProfileUsecase;
  final CheckprofilestatusUsecase checkProfileStatusUsecase;

  ProfileBloc({
    required this.saveProfileUseCase,
    required this.updateprofileUsecase,
    required this.getProfileUsecase,
    required this.checkProfileStatusUsecase,
  }) : super(ProfileInitialState()) {
    on<SaveProfileEvent>(_onSaveProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<GetProfileEvent>(_onGetProfile);
    on<CheckProfileStatusEvent>(_onCheckProfileStatus);
  }

  Future<void> _onSaveProfile(SaveProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await saveProfileUseCase.call(event.profileModel, event.userId);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (_) => emit(ProfileSuccessState(event.profileModel)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await updateprofileUsecase.call(event.profileModel, event.userId);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (_) => emit(ProfileSuccessState(event.profileModel)),
    );
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await getProfileUsecase.call(event.userId);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (profileModel) => emit(ProfileSuccessState(profileModel)),
    );
  }

  Future<void> _onCheckProfileStatus(CheckProfileStatusEvent event, Emitter<ProfileState> emit) async {
    // emit(ProfileLoadingState());
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;

    final result = await checkProfileStatusUsecase.call(userId);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (isProfileComplete) {
        print("here in check ${isProfileComplete}");
        if (isProfileComplete) {
          emit(ProfileStatusCompleteState());
        } else {
          emit(ProfileStatusIncompleteState());
        }
      },
    );
  }
}
