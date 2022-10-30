// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Screen/Client/ClientOrdersPage.dart';
import 'package:dogslivery/Screen/Profile/ChangePasswordPage.dart';
import 'package:dogslivery/Screen/Profile/EditProdilePage.dart';
import 'package:dogslivery/Screen/Intro/CheckingLoginPage.dart';
import 'package:dogslivery/Screen/Profile/ListAddressesPage.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/BottomNavigationDogsLivery.dart';
import 'package:dogslivery/Widgets/ImagePicker.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

class ProfileClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          modalLoading(context);
        } else if (state is SuccessAuthState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Alteração de imagem com sucesso',
              () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: ProfileClientPage())));
          Navigator.pop(context);
        } else if (state is FailureAuthState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextDogsLivery(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              SizedBox(height: 20.0),
              Align(
                  alignment: Alignment.center, child: ImagePickerDogsLivery()),
              SizedBox(height: 20.0),
              Center(
                  child: TextDogsLivery(
                      text:
                          '${authBloc.state.user!.firstName} ${authBloc.state.user!.lastName}',
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 5.0),
              Center(
                  child: TextDogsLivery(
                      text: authBloc.state.user!.email,
                      fontSize: 20,
                      color: Colors.grey)),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Conta', color: Colors.grey),
              SizedBox(height: 10.0),
              ItemAccount(
                text: 'Configuração do Perfil',
                icon: Icons.person,
                colorIcon: 0xff01C58C,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: EditProfilePage())),
              ),
              ItemAccount(
                text: 'Mudar senha',
                icon: Icons.lock_rounded,
                colorIcon: 0xff1B83F5,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ChangePasswordPage())),
              ),
              ItemAccount(
                text: 'Adicionar Endereços',
                icon: Icons.my_location_rounded,
                colorIcon: 0xffFB5019,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ListAddressesPage())),
              ),
              ItemAccount(
                text: 'Pedidos',
                icon: Icons.shopping_bag_outlined,
                colorIcon: 0xffFBAD49,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ClientOrdersPage())),
              ),
              ItemAccount(
                text: 'Dark mode',
                icon: Icons.dark_mode_rounded,
                colorIcon: 0xff051E2F,
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Pessoal', color: Colors.grey),
              SizedBox(height: 10.0),
              ItemAccount(
                text: 'Política de Privacidade',
                icon: Icons.policy_rounded,
                colorIcon: 0xff6dbd63,
              ),
              ItemAccount(
                text: 'Segurança',
                icon: Icons.lock_outline_rounded,
                colorIcon: 0xff1F252C,
              ),
              ItemAccount(
                text: 'Termo e Condições',
                icon: Icons.description_outlined,
                colorIcon: 0xff458bff,
              ),
              ItemAccount(
                text: 'Ajuda',
                icon: Icons.help_outline,
                colorIcon: 0xff4772e6,
              ),
              // Divider(),
              ItemAccount(
                text: 'Sair da Conta',
                icon: Icons.power_settings_new_sharp,
                colorIcon: 0xffF02849,
                onPressed: () {
                  authBloc.add(LogOutEvent());
                  Navigator.pushAndRemoveUntil(
                      context,
                      routeDogsLivery(page: CheckingLoginPage()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationDogsLivery(3),
      ),
    );
  }
}
