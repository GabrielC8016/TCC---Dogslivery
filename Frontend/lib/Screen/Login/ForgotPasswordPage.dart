import 'package:flutter/material.dart';
import 'package:dogslivery/Helpers/validate_form.dart';
import 'package:dogslivery/Screen/Login/CheckEmailPage.dart';
import 'package:dogslivery/Screen/Login/LoginPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}


class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextDogsLivery(text: 'Redefinir senha', fontSize: 21, fontWeight: FontWeight.w500 ),
        centerTitle: true,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pushReplacement(context, routeDogsLivery(page: LoginPage())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ColorsDogsLivery.primaryColor ),
              TextDogsLivery(text: 'Voltar', color: ColorsDogsLivery.secundaryColor, fontSize: 18)
            ],
          ),
        ),
        actions: [
          Icon(Icons.help_outline_outlined)
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              TextDogsLivery(
                text: 'Digite o e-mail associado à sua conta e enviaremos um e-mail com instruções para redefinir sua senha.',
                maxLine: 4, 
                color: Color(0xff5B6589),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30.0),
              TextDogsLivery(text: 'Endereço de E-mail'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _emailController,
                hintText: 'example@dogslivery.com',
                validator: validatedEmail,
              ),
              SizedBox(height: 30.0),
              BtnDogsLivery(
                text: 'Enviar instruções',
                color: ColorsDogsLivery.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                onPressed: (){
                    // if( _formKey.currentState!.validate() ){}
                    Navigator.push(context, routeDogsLivery(page: CheckEmailPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}