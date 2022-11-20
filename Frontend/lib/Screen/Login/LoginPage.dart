// ignore: file_names
// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, library_private_types_in_public_api, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/validate_form.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Home/SelectRolePage.dart';
import 'package:dogslivery/Screen/Intro/IntroPage.dart';
import 'package:dogslivery/Screen/Login/ForgotPasswordPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoadingAuthState) {
          modalLoading(context);
        } else if (state is FailureAuthState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state.rolId != '') {
          userBloc.add(OnGetUserEvent(state.user!));
          Navigator.pop(context);

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              // ignore: duplicate_ignore, duplicate_ignore, duplicate_ignore
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context, routeDogsLivery(page: IntroPage())),
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[50], shape: BoxShape.circle),
                          child: Icon(Icons.arrow_back_ios_new_outlined,
                              color: Colors.black, size: 20),
                        ),
                      ),
                      Row(
                        children: [
                          TextDogsLivery(
                              text: 'Dog\'s',
                              color: ColorsDogsLivery.primaryColor,
                              fontWeight: FontWeight.w500),
                          TextDogsLivery(
                              text: 'Livery',
                              color: ColorsDogsLivery.secundaryColor,
                              fontWeight: FontWeight.w500),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Image.asset('Assets/Logo/dogslivery_sero.png', height: 200),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  child: TextDogsLivery(
                      text: 'Bem Vindo!',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff212121)),
                ),
                SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.center,
                  child: TextDogsLivery(
                      text:
                          'Use suas credenciais abaixo e faça login em sua conta.',
                      textAlign: TextAlign.center,
                      color: Colors.grey,
                      maxLine: 2,
                      fontSize: 16),
                ),
                SizedBox(height: 15.0),
                TextDogsLivery(text: 'E-mail', color: Color(0xff212121)),
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _emailController,
                  hintText: 'email@dogslivery.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail,
                ),
                SizedBox(height: 20.0),
                // ignore: prefer_const_constructors
                TextDogsLivery(text: 'Senha', color: Color(0xff212121)),
                // ignore: prefer_const_constructors
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _passwordController,
                  hintText: 'Digite a Senha',
                  isPassword: true,
                  validator: passwordValidator,
                  textInputAction: TextInputAction.done,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: InkWell(
                            onTap: () => Navigator.push(
                                context, routeDogsLivery(page: IntroPage())),
                            child: TextDogsLivery(
                                text: 'Criar uma conta?',
                                fontSize: 17,
                                color: Color(0xffD84315)))),
                    Container(
                        child: InkWell(
                            onTap: () => Navigator.push(context,
                                routeDogsLivery(page: ForgotPasswordPage())),
                            child: TextDogsLivery(
                                text: 'Esqueceu sua senha?',
                                fontSize: 17,
                                color: Color(0xffD84315)))),
                  ],
                ),
                SizedBox(height: 30.0),
                BtnDogsLivery(
                  text: 'Login',
                  fontSize: 21,
                  color: ColorsDogsLivery.primaryColor,
                  height: 50,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      authBloc.add(LoginEvent(
                          _emailController.text, _passwordController.text));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
