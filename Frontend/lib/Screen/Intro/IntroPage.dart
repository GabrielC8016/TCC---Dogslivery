// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dogslivery/Screen/Login/LoginPage.dart';
import 'package:dogslivery/Screen/Login/RegisterClientPage.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*TextDogsLivery(
                text: 'Dog\'s',
                color: ColorsDogsLivery.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 25),
            TextDogsLivery(
                text: 'Livery',
                color: ColorsDogsLivery.secundaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w500),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: InkWell(
                        onTap: () => Navigator.push(
                            context, routeDogsLivery(page: LoginPage())),
                        // ignore: prefer_const_constructors
                        child: TextDogsLivery(
                            text: 'VOLTAR',
                            fontSize: 20,
                            color: Color(0xffD84315)))),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              height: 400,
              width: size.width,
              child: SvgPicture.asset('Assets/logo-dogs.svg'),
            ),
            Column(
              children: [
                _BtnSocial(
                  icon: FontAwesomeIcons.google,
                  text: 'Inscreva-se com o Google',
                  backgroundColor: Colors.white,
                  isBorder: true,
                ),
                SizedBox(height: 15.0),
                _BtnSocial(
                  icon: FontAwesomeIcons.facebook,
                  text: 'Inscreva-se com o Facebook',
                  backgroundColor: Color(0xff3b5998),
                  textColor: Colors.white,
                ),
                SizedBox(height: 15.0),
                _BtnSocial(
                  icon: FontAwesomeIcons.envelope,
                  text: 'Inscreva-se com um ID de e-mail valido',
                  backgroundColor: ColorsDogsLivery.secundaryColor,
                  textColor: Colors.white,
                  onPressed: () => Navigator.push(
                      context, routeDogsLivery(page: RegisterClientPage())),
                ),
                SizedBox(height: 20.0),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 1, width: 150, color: Colors.grey[300]),
                    TextDogsLivery(
                      text: 'Ou',
                      fontSize: 16,
                    ),
                    Container(height: 1, width: 150, color: Colors.grey[300])
                  ],
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BtnDogsLivery(
                    text: 'Login',
                    color: ColorsDogsLivery.primaryColor,
                    fontWeight: FontWeight.w500,
                    borderRadius: 10.0,
                    height: 50,
                    fontSize: 20,
                    onPressed: () => Navigator.push(
                        context, routeDogsLivery(page: LoginPage())),
                  ),
                ),
                SizedBox(height: 20.0)*/ //BOTÃO LOGIN EXTINTO
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _BtnSocial extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isBorder;

  const _BtnSocial(
      {required this.icon,
      required this.text,
      this.onPressed,
      this.backgroundColor = const Color(0xffF5F5F5),
      this.textColor = Colors.black,
      this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onPressed,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: backgroundColor,
              border:
                  isBorder ? Border.all(color: Colors.grey, width: .7) : null,
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: [
              SizedBox(width: 30.0),
              Icon(icon, color: isBorder ? Colors.black87 : Colors.white),
              SizedBox(width: 20.0),
              TextDogsLivery(text: text, color: textColor, fontSize: 17)
            ],
          ),
        ),
      ),
    );
  }
}
