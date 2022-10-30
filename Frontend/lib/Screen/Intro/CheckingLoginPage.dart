// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Home/SelectRolePage.dart';
import 'package:dogslivery/Screen/Login/LoginPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';

import 'dart:developer';

class CheckingLoginPage extends StatefulWidget {
  @override
  _CheckingLoginPageState createState() => _CheckingLoginPageState();
}

class _CheckingLoginPageState extends State<CheckingLoginPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoadingAuthState) {
          Navigator.pushReplacement(
              context, routeDogsLivery(page: CheckingLoginPage()));
        } else if (state is LogOutAuthState) {
          Navigator.pushAndRemoveUntil(
              context, routeDogsLivery(page: LoginPage()), (route) => false);
        } else if (state.rolId != '') {
          userBloc.add(OnGetUserEvent(state.user!));

          if (state.rolId == '1' || state.rolId == '3') {
            Navigator.pushAndRemoveUntil(context,
                routeDogsLivery(page: SelectRolePage()), (route) => false);
          } else if (state.rolId == '2') {
            Navigator.pushAndRemoveUntil(context,
                routeDogsLivery(page: ClientHomePage()), (route) => false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorsDogsLivery.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('Assets/Logo/logo-white.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
