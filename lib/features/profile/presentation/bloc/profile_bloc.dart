import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
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

  ProfileModel profileModel = ProfileModel(
    username: "",
    phoneNumber: "",
    address: "",
    imageUrl: "",
  );

  ProfileBloc({
    required this.saveProfileUseCase,
    required this.updateprofileUsecase,
    required this.getProfileUsecase,
    required this.checkProfileStatusUsecase,
  }) : super(ProfileInitialState()) {
    on<SaveProfileEvent>(_onSaveProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<GetProfileEvent>(_onGetProfile);
    on<ClearProfileModelEvent>(_onclearProfileModelEvent);
  }

  Future<void> _onSaveProfile(
      SaveProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result =
        await saveProfileUseCase.call(event.profileModel, event.userId);
    result.fold(
      (failure) {
        emit(ProfileErrorState(failure.message));
      },
      (_) {
        profileModel = event.profileModel;
        emit(ProfileSetupComplete());
      },
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    final result =
        await updateprofileUsecase.call(event.profileModel, event.userId);
    result.fold(
      (failure) => ProfileErrorState(failure.message),
      (_) {
        profileModel = event.profileModel;
        ProfileUpdatedSuccess(event.profileModel);
      },
    );
  }

  Future<void> _onGetProfile(
      GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;

    final result = await getProfileUsecase.call(userId);

    result.fold(
      (failure) {
        emit(ProfileErrorState(failure.message));
      },
      (fetchedProfile) {
        profileModel = fetchedProfile;
        if (profileModel.isEmpty) {
          emit(ProfileStatusIncompleteState(profileModel));
        } else {
          emit(ProfileStatusCompleteState());
        }
      },
    );
  }

  Future<ProfileModel> onGetProfileForProfilePage(String userId) async {
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;

    final result = await getProfileUsecase.call(userId);

    result.fold(
      (failure) {},
      (fetchedProfile) {
        profileModel = fetchedProfile;
      },
    );

    return profileModel;
  }


  Future<void> _onclearProfileModelEvent(ClearProfileModelEvent event, Emitter<ProfileState> emit) async {
    profileModel = ProfileModel(imageUrl: "", username: "", phoneNumber: "", address: "");
    emit(ProfileInitialState());
  }


  void getProfile() async {
    add(GetProfileEvent());
  }



}
