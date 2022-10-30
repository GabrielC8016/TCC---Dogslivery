import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Screen/Admin/AdminHomePage.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Delivery/DeliveryHomePage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class SelectRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context).state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextDogsLivery(
                      text: 'Dog\'s',
                      fontSize: 25,
                      color: ColorsDogsLivery.primaryColor,
                      fontWeight: FontWeight.w500),
                  TextDogsLivery(
                      text: 'Livery',
                      fontSize: 25,
                      color: ColorsDogsLivery.secundaryColor,
                      fontWeight: FontWeight.w500),
                ],
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(
                text: 'Como você deseja continuar?',
                color: ColorsDogsLivery.secundaryColor,
                fontSize: 25,
              ),
              SizedBox(height: 30.0),
              (authBloc.user!.rolId == 1)
                  ? _BtnRol(
                      svg: 'Assets/svg/Icon_Petshop-semfundo.svg',
                      text: 'Petshop',
                      color1: ColorsDogsLivery.primaryColor.withOpacity(.2),
                      color2: Colors.greenAccent.withOpacity(.1),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          routeDogsLivery(page: AdminHomePage()),
                          (route) => false),
                    )
                  : Container(),
              (authBloc.user!.rolId == 1 || authBloc.user!.rolId == 3)
                  ? _BtnRol(
                      svg: 'Assets/svg/Icon_Cliente.svg',
                      text: 'Cliente',
                      color1: Color(0xffFE6488).withOpacity(.2),
                      color2: Colors.amber.withOpacity(.1),
                      onPressed: () => Navigator.pushReplacement(
                          context, routeDogsLivery(page: ClientHomePage())),
                    )
                  : Container(),
              (authBloc.user!.rolId == 1 || authBloc.user!.rolId == 3)
                  ? _BtnRol(
                      svg: 'Assets/svg/Icon_Delivery-sem.svg',
                      text: 'Delivery',
                      color1: Color(0xff8956FF).withOpacity(.2),
                      color2: Colors.purpleAccent.withOpacity(.1),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          routeDogsLivery(page: DeliveryHomePage()),
                          (route) => false),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class _BtnRol extends StatelessWidget {
  final String svg;
  final String text;
  final Color color1;
  final Color color2;
  final VoidCallback? onPressed;

  const _BtnRol(
      {required this.svg,
      required this.text,
      required this.color1,
      required this.color2,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onPressed,
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft, colors: [color1, color2]),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  svg,
                  height: 100,
                ),
                TextDogsLivery(
                    text: text,
                    fontSize: 20,
                    color: ColorsDogsLivery.secundaryColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
