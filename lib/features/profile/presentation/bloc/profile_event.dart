import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';

abstract class ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final ProfileModel profileModel;
  final String userId;

  SaveProfileEvent(this.profileModel, this.userId);
}

class UpdateProfileEvent extends ProfileEvent {
  final ProfileModel profileModel;
  final String userId;

  UpdateProfileEvent(this.profileModel, this.userId);
}

class GetProfileEvent extends ProfileEvent {}

class CheckProfileStatusEvent extends ProfileEvent {}


// class GetProfileForProfilePage extends  ProfileEvent {
//   final String userId;

//   GetProfileForProfilePage(this.userId);
// }
