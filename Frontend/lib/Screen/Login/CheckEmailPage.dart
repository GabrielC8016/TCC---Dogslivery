import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dogslivery/Screen/Login/LoginPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class CheckEmailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 90.0),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 50.0),
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: ColorsDogsLivery.primaryColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Icon(FontAwesomeIcons.envelopeOpenText, size: 60, color: ColorsDogsLivery.primaryColor),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextDogsLivery(text: 'Verifique seu e-mail', textAlign: TextAlign.center, fontSize: 32, fontWeight: FontWeight.w500 ),
                  SizedBox(height: 20.0),
                  TextDogsLivery(text: 'Enviamos instruções de recuperação de senha para o seu e-mail.', maxLine: 2, textAlign: TextAlign.center),
                  SizedBox(height: 40.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: BtnDogsLivery(
                      text: 'Abra o aplicativo de e-mail', color: ColorsDogsLivery.secundaryColor,
                      fontWeight: FontWeight.w500,
                      onPressed: () async {
                        
                        if( Platform.isAndroid ){

                          final intent = AndroidIntent(
                            action: 'action_view',
                            package: 'com.android.email'
                            );
                          intent.launch();

                        }
                      },
                    )
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(context, routeDogsLivery(page: LoginPage())),
                      child: TextDogsLivery(text: 'Pular, confirmarei mais tarde', color: ColorsDogsLivery.primaryColor)
                    )
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: TextDogsLivery(text: 'Não recebeu o e-mail? Verifique seu filtro de spam.', color: Colors.black87, maxLine: 2 )
              ),
            ],
          ),
        ),
      ),
    );
  }
}