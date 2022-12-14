// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dogslivery/Bloc/General/general_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/validate_form.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _repeatPasswordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void clearTextEditingController() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _repeatPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final generalBloc = BlocProvider.of<GeneralBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(context, 'Senha alterada', () => Navigator.pop(context));
          clearTextEditingController();
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextDogsLivery(text: 'Mudar senha'),
          centerTitle: true,
          leadingWidth: 80,
          leading: TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextDogsLivery(
                  text: 'Cancelar',
                  fontSize: 17,
                  color: ColorsDogsLivery.primaryColor)),
          actions: [
            TextButton(
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    userBloc.add(OnChangePasswordEvent(
                        _currentPasswordController.text,
                        _newPasswordController.text));
                  }
                },
                child: TextDogsLivery(
                    text: 'Salvar',
                    fontSize: 16,
                    color: ColorsDogsLivery.primaryColor))
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: BlocBuilder<GeneralBloc, GeneralState>(
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    TextDogsLivery(text: 'Senha atual'),
                    SizedBox(height: 5.0),
                    _FormFieldDogsPassword(
                      controller: _currentPasswordController,
                      isPassword: state.isShowPassword,
                      suffixIcon: IconButton(
                          splashRadius: 20,
                          icon: state.isShowPassword
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.visibility_off_rounded),
                          onPressed: () {
                            bool isShowPassword =
                                !generalBloc.state.isShowPassword;
                            generalBloc
                                .add(OnShowOrHidePasswordEvent(isShowPassword));
                          }),
                      validator: passwordValidator,
                    ),
                    SizedBox(height: 20.0),
                    TextDogsLivery(text: 'Nova Senha'),
                    SizedBox(height: 5.0),
                    _FormFieldDogsPassword(
                      controller: _newPasswordController,
                      isPassword: state.isNewPassword,
                      suffixIcon: IconButton(
                          splashRadius: 20,
                          icon: state.isNewPassword
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.visibility_off_rounded),
                          onPressed: () {
                            bool isShowPassword =
                                !generalBloc.state.isNewPassword;
                            generalBloc.add(
                                OnShowOrHideNewPasswordEvent(isShowPassword));
                          }),
                      validator: passwordValidator,
                    ),
                    SizedBox(height: 20.0),
                    TextDogsLivery(text: 'Repita a senha'),
                    SizedBox(height: 5.0),
                    _FormFieldDogsPassword(
                      controller: _repeatPasswordController,
                      isPassword: state.isRepeatpassword,
                      suffixIcon: IconButton(
                          splashRadius: 20,
                          icon: state.isRepeatpassword
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.visibility_off_rounded),
                          onPressed: () {
                            bool isShowPassword =
                                !generalBloc.state.isRepeatpassword;
                            generalBloc.add(OnShowOrHideRepeatPasswordEvent(
                                isShowPassword));
                          }),
                      validator: (val) {
                        if (val != _newPasswordController.text) {
                          return 'As senhas n??o coincidem';
                        } else {
                          return 'A repeti????o da senha ?? obrigat??ria';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormFieldDogsPassword extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLine;
  final bool readOnly;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  const _FormFieldDogsPassword(
      {this.controller,
      this.hintText,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.maxLine = 1,
      this.readOnly = false,
      this.suffixIcon,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.getFont('Roboto', fontSize: 18),
      obscureText: isPassword,
      maxLines: maxLine,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: .5, color: Colors.grey)),
          contentPadding: EdgeInsets.only(left: 15.0),
          hintText: hintText,
          hintStyle: GoogleFonts.getFont('Roboto', color: Colors.grey),
          suffixIcon: suffixIcon),
      validator: validator,
    );
  }
}
