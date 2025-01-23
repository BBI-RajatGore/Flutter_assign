import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profileModel;

  ProfileSuccessState(this.profileModel);
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileStatusCompleteState extends ProfileState {

}

class ProfileStatusIncompleteState extends ProfileState {
  final ProfileModel profileModel;

  ProfileStatusIncompleteState(this.profileModel);
}


class ProfileUpdatedSuccess extends ProfileState {
  final ProfileModel profileModel;

  ProfileUpdatedSuccess(this.profileModel);
}


class ProfileSetupComplete extends ProfileState{
}

