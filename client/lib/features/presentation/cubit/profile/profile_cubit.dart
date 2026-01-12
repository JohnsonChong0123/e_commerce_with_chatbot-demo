import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/user/get_user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileLoadState> {
  final GetUserProfile _getUserProfile;

  ProfileCubit({required GetUserProfile getUserProfile})
      : _getUserProfile = getUserProfile,
        super(ProfileInitial());

  void loadProfile() async {
    emit(ProfileLoading());
    final result = await _getUserProfile(NoParams());
    result.fold(
      (failure) => emit(ProfileLoadFailure(failure.message)),
      (user) => emit(ProfileLoadSuccess(user)),
    );
  }
}
