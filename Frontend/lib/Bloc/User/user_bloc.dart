// ignore_for_file: depend_on_referenced_packages, duplicate_ignore, prefer_const_constructors

import 'dart:async';

import 'package:meta/meta.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dogslivery/Controller/UserController.dart';
import 'package:dogslivery/Models/Response/ResponseLogin.dart';
import 'package:dogslivery/Services/PushNotification.dart';

import 'dart:developer';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<OnGetUserEvent>(_onGetUser);
    on<OnSelectPictureEvent>(_onSelectPicture);
    on<OnClearPicturePathEvent>(_onClearPicturePath);
    on<OnChangeImageProfileEvent>(_onChangePictureProfile);
    on<OnEditUserEvent>(_onEditProfileUser);
    on<OnChangePasswordEvent>(_onChangePassword);
    on<OnRegisterClientEvent>(_onRegisterClient);
    on<OnRegisterDeliveryEvent>(_onRegisterDelivery);
    on<OnUpdateDeliveryToClientEvent>(_onUpdateDeliveryToClient);
    on<OnDeleteStreetAddressEvent>(_onDeleteStreetAddress);
    on<OnSelectAddressButtonEvent>(_onSelectAddressButton);
    on<OnAddNewAddressEvent>(_onAddNewStreetAddress);
  }

  Future<void> _onGetUser(OnGetUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(user: event.user));
  }

  Future<void> _onSelectPicture(
      OnSelectPictureEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(pictureProfilePath: event.pictureProfilePath));
  }

  Future<void> _onClearPicturePath(
      OnClearPicturePathEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(pictureProfilePath: ''));
  }

  Future<void> _onChangePictureProfile(
      OnChangeImageProfileEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userController.changeImageProfile(event.image);

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user!));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onEditProfileUser(
      OnEditUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userController.editProfile(
          event.name, event.lastname, event.phone);

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onChangePassword(
      OnChangePasswordEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userController.changePassword(
          event.currentPassword, event.newPassword);

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onRegisterClient(
      OnRegisterClientEvent event, Emitter<UserState> emit) async {
    //converte o texto do numero da op????o escolhida no menu dropdown em int
    var eventType = event.type.split(" ")[0];

    try {
      emit(LoadingUserState());
      final nToken = await pushNotification.getNotificationToken();

      final data = await userController.registerClient(
          event.name,
          event.lastname,
          event.phone,
          event.image,
          event.email,
          event.password,
          nToken!,
          eventType);
      log('user_bloc._onRegisterClient 3');
      if (data.resp) {
        log('user_bloc._onRegisterClient 4');
        emit(SuccessUserState());
      } else {
        log('user_bloc._onRegisterClient 5');
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      log('user_bloc._onRegisterClient 6');
      log(e.toString());
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onRegisterDelivery(
      OnRegisterDeliveryEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final nToken = await pushNotification.getNotificationToken();

      final data = await userController.registerDelivery(
          event.name,
          event.lastname,
          event.phone,
          event.email,
          event.password,
          event.image,
          nToken!);

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onUpdateDeliveryToClient(
      OnUpdateDeliveryToClientEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userController.updateDeliveryToClient(event.idPerson);

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onDeleteStreetAddress(
      OnDeleteStreetAddressEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data =
          await userController.deleteStreetAddress(event.uid.toString());

      if (data.resp) {
        final user = await userController.getUserById();

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onSelectAddressButton(
      OnSelectAddressButtonEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
        uidAddress: event.uidAddress, addressName: event.addressName));
  }

  Future<void> _onAddNewStreetAddress(
      OnAddNewAddressEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userController.addNewAddressLocation(
          event.street,
          event.reference,
          event.location.latitude.toString(),
          event.location.longitude.toString());

      if (data.resp) {
        final user = await userController.getUserById();

        final userdb = await userController.getAddressOne();

        add(OnSelectAddressButtonEvent(
            userdb.address!.id, userdb.address!.reference));

        emit(SuccessUserState());

        emit(state.copyWith(user: user));
      } else {
        emit(FailureUserState(data.msg));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }
}
