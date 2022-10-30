// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, curly_braces_in_flow_control_structures, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/validate_form.dart';
import 'package:dogslivery/Screen/Login/LoginPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

/* CONFIGURAÇÃO DO FORMULÁRIO */
class RegisterClientPage extends StatefulWidget {
  @override
  _RegisterClientPageState createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  static const _types = ["2 - Client", "3 - Delivery", "1 - Admin"];
  var userType = "2 - Client";

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clearForm();
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearForm() {
    _nameController.clear();
    _lastnameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  /*CONFIGURAÇÃO DE BOTÕES */
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Cliente cadastrado com sucesso',
              () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: LoginPage())));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              clearForm();
            },
            child: Container(
                alignment: Alignment.center,
                child: TextDogsLivery(
                    text: 'Cancelar',
                    color: ColorsDogsLivery.primaryColor,
                    fontSize: 16)),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 50,
          title: TextDogsLivery(
            text: 'Crie sua conta',
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                if (_keyForm.currentState!.validate()) {
                  userBloc.add(OnRegisterClientEvent(
                      _nameController.text,
                      _lastnameController.text,
                      _phoneController.text,
                      _emailController.text,
                      _passwordController.text,
                      userBloc.state.pictureProfilePath,
                      userType));
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                child: TextDogsLivery(
                    text: 'Salvar',
                    color: ColorsDogsLivery.secundaryColor,
                    fontSize: 16),
              ),
            ),
          ],
        ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              SizedBox(height: 20.0),
              Align(alignment: Alignment.center, child: _PictureRegistre()),
              SizedBox(height: 40.0),
              TextDogsLivery(text: 'Nome'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _nameController,
                hintText: 'Digite seu nome',
                validator: RequiredValidator(errorText: 'O nome é obrigatório'),
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Sobrenome'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _lastnameController,
                hintText: 'Digite seu sobrenome',
                validator:
                    RequiredValidator(errorText: 'O sobrenome é obrigatório'),
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Telefone'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _phoneController,
                hintText: '(00) 0000-0000',
                keyboardType: TextInputType.number,
                validator: validatedPhoneForm,
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Email'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                  controller: _emailController,
                  hintText: 'email@dogslivery.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Senha'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _passwordController,
                hintText: 'Digite sua senha',
                isPassword: true,
                validator: passwordValidator,
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Tipo'),
              SizedBox(height: 5.0),
              DropdownButton(
                  value: userType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _types.map((String items) {
                    var type = "";
                    var valor = 0;

                    void fixName(String item) {
                      if (item == "1 - Admin") {
                        type = "Loja";
                        valor = 1;
                      } else if (item == "2 - Client") {
                        type = "Cliente";
                        valor = 2;
                      } else if (item == "3 - Delivery") {
                        type = "Entregador";
                        valor = 3;
                      }
                    }

                    fixName(items);

                    return DropdownMenuItem(
                      value: items,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      userType = newValue!;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

/*CONFIGURAÇÃO IMAGENS*/
class _PictureRegistre extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          border:
              Border.all(style: BorderStyle.solid, color: Colors.grey[300]!),
          shape: BoxShape.circle),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
            ctx: context,
            onPressedChange: () async {
              final permissionGallery = await Permission.photos.request();

              switch (permissionGallery) {
                case PermissionStatus.granted:
                  Navigator.pop(context);
                  final XFile? imagePath =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (imagePath != null)
                    userBloc.add(OnSelectPictureEvent(imagePath.path));
                  break;
                case PermissionStatus.denied:
                case PermissionStatus.restricted:
                case PermissionStatus.limited:
                case PermissionStatus.permanentlyDenied:
                  openAppSettings();
                  break;
              }
            },
            onPressedTake: () async {
              final permissionPhotos = await Permission.camera.request();

              switch (permissionPhotos) {
                case PermissionStatus.granted:
                  Navigator.pop(context);
                  final XFile? photoPath =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photoPath != null)
                    userBloc.add(OnSelectPictureEvent(photoPath.path));
                  break;

                case PermissionStatus.denied:
                case PermissionStatus.restricted:
                case PermissionStatus.limited:
                case PermissionStatus.permanentlyDenied:
                  openAppSettings();
                  break;
              }
            }),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) => state.pictureProfilePath == ''
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wallpaper_rounded,
                        size: 60, color: ColorsDogsLivery.primaryColor),
                    SizedBox(height: 10.0),
                    TextDogsLivery(text: 'Foto', color: Colors.grey)
                  ],
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(state.pictureProfilePath)))),
                ),
        ),
      ),
    );
  }
}
