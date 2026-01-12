import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user/change_password.dart';
import '../../../domain/usecases/user/update_address.dart';
import '../../../domain/usecases/user/update_user.dart';
import '../../../domain/usecases/user/update_wallet.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileUpdateState> {
  final UpdateUser _updateUser;
  final UpdateUserAddress _updateUserAddress;
  final UpdateUserWallet _updateUserWallet;
  final ChangePassword _changePassword;

  ProfileBloc({
    required UpdateUser updateUser,
    required UpdateUserAddress updateUserAddress,
    required UpdateUserWallet updateUserWallet,
    required ChangePassword changePassword,
  })  :
        _updateUser = updateUser,
        _updateUserAddress = updateUserAddress,
        _updateUserWallet = updateUserWallet,
        _changePassword = changePassword,
        super(ProfileInitial()) {
    on<ProfileUpdate>(_onProfileUpdate);
    on<ProfileUpdateAddress>(_onProfileUpdateAddress);
    on<ProfileUpdateWallet>(_onProfileUpdateWallet);
    on<ProfileChangePassword>(_onProfileChangePassword);
  }

  void _onProfileUpdate(
      ProfileUpdate event, Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdateLoading());
    final result = await _updateUser(UpdateUserParams(
      userId: event.userId,
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      image: event.image,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateFailure(failure.message)),
      (user) => emit(const ProfileUpdateSuccess('Profile updated!')),
    );
  }

  void _onProfileUpdateAddress(
      ProfileUpdateAddress event, Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdateLoading());
    final result = await _updateUserAddress(UpdateUserAddressParams(
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateAddressFailure(failure.message)),
      (_) => emit(const ProfileUpdateAddressSuccess('Address updated')),
    );
  }

  void _onProfileUpdateWallet(
      ProfileUpdateWallet event, Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdateLoading());
    final result = await _updateUserWallet(UpdateUserWalletParams(
      amount: event.amount,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateFailure(failure.message)),
      (_) => emit(const ProfileUpdateSuccess('Wallet updated')),
    );
  }

  void _onProfileChangePassword(ProfileChangePassword event, Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdateLoading());
    final result = await _changePassword(ChangePasswordParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateFailure(failure.message)),
      (_) => emit(const ProfileUpdateSuccess('Password updated')),
    );
  }
}
