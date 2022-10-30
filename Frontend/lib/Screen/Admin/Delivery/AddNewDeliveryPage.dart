import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/validate_form.dart';
import 'package:dogslivery/Screen/Admin/AdminHomePage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';


class AddNewDeliveryPage extends StatefulWidget {
  @override
  _AddNewDeliveryPageState createState() => _AddNewDeliveryPageState();
}


class _AddNewDeliveryPageState extends State<AddNewDeliveryPage> {

  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();    
    super.dispose();
  }

  void clearTextEditingController(){
    _nameController.clear();
    _lastnameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        
        if( state is LoadingUserState ){

          modalLoading(context);

        }else if ( state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(context, 'Entrega Registrada com Sucesso',
            () => Navigator.pushAndRemoveUntil(context, routeDogsLivery(page: AdminHomePage()), (route) => false));
          userBloc.add( OnClearPicturePathEvent());

        } else if ( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: TextDogsLivery(text: 'Adicionar Nova Entrega'),
            centerTitle: true,
            leadingWidth: 80,
            leading: TextButton(
              child: TextDogsLivery(text: 'Cancelar', color: ColorsDogsLivery.primaryColor, fontSize: 17 ),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  if( _keyForm.currentState!.validate() ){
                    userBloc.add( OnRegisterDeliveryEvent(
                      _nameController.text, 
                      _lastnameController.text, 
                      _phoneController.text, 
                      _emailController.text, 
                      _passwordController.text, 
                      userBloc.state.pictureProfilePath 
                    ));
                    
                  }
                }, 
                child: TextDogsLivery(text: ' Salvar ', color: ColorsDogsLivery.primaryColor )
              )
            ],
          ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: _PictureRegister()
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Nome'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                hintText: 'nome',
                controller: _nameController,
                validator: RequiredValidator(errorText: 'O nome é obrigatório'),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Sobrenome'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _lastnameController,
                hintText: 'sobrenome',
                validator: RequiredValidator(errorText: 'O Sobrenome é Obrigatório'),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Telefone'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _phoneController,
                hintText: '(--) -----.----',
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'O Telefone é Obrigatório'),
              ),
              SizedBox(height: 15.0),
                TextDogsLivery(text: 'E-mail'),
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _emailController,
                  hintText: 'email@dogslivery.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail
                ),
                SizedBox(height: 15.0),
                TextDogsLivery(text: 'Senha'),
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _passwordController,
                  hintText: 'Digite a Senha',
                  isPassword: true,
                  validator: passwordValidator,
                ),
            ],
          ),
        ),
      ),
    );
  }
}



class _PictureRegister extends StatelessWidget {

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Colors.grey[300]!),
        shape: BoxShape.circle
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
          ctx: context, 
          onPressedChange: () async {
            
            Navigator.pop(context);
            final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);
            if( imagePath != null ) userBloc.add( OnSelectPictureEvent(imagePath.path));

          },
          onPressedTake: () async {

            Navigator.pop(context);
            final XFile? photoPath = await _picker.pickImage(source: ImageSource.camera);
            userBloc.add( OnSelectPictureEvent(photoPath!.path));

          }
        ),
        child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) 
                => state.pictureProfilePath == ''
                   ? Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        Icon(Icons.wallpaper_rounded, size: 60, color: ColorsDogsLivery.primaryColor ),
                        SizedBox(height: 10.0),
                        TextDogsLivery(text: 'Foto', color: Colors.black45 )
                     ],
                   ) 
                   : Container(
                      height: 100,  
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(state.pictureProfilePath))
                        )
                      ),
                     ),
            ),
           
      ),
    );
  }
}