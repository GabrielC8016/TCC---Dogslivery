// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Screen/Admin/Category/CategoriesAdminPage.dart';
import 'package:dogslivery/Screen/Admin/Delivery/ListDeliverysPage.dart';
import 'package:dogslivery/Screen/Admin/OrdersAdmin/OrdersAdminPage.dart';
import 'package:dogslivery/Screen/Admin/Products/ListProductsPage.dart';
import 'package:dogslivery/Screen/Profile/ChangePasswordPage.dart';
import 'package:dogslivery/Screen/Profile/EditProdilePage.dart';
import 'package:dogslivery/Screen/Home/SelectRolePage.dart';
import 'package:dogslivery/Screen/Intro/CheckingLoginPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/ImagePicker.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Alteração de Imagem com Sucesso',
              () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: AdminHomePage())));
          Navigator.pop(context);
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              Align(
                  alignment: Alignment.center, child: ImagePickerDogsLivery()),
              SizedBox(height: 10.0),
              Center(
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (_, state) => TextDogsLivery(
                          text: (state.user != null)
                              ? '${state.user!.firstName.toUpperCase()} ${state.user!.lastName.toUpperCase()}'
                              : '',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                          textAlign: TextAlign.center,
                          color: ColorsDogsLivery.secundaryColor))),
              SizedBox(height: 5.0),
              Center(
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (_, state) => TextDogsLivery(
                          text: (state.user != null) ? state.user!.email : '',
                          fontSize: 20,
                          color: ColorsDogsLivery.secundaryColor))),
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
                text: 'Alterar Função',
                icon: Icons.swap_horiz_rounded,
                colorIcon: 0xffE62755,
                onPressed: () => Navigator.pushAndRemoveUntil(context,
                    routeDogsLivery(page: SelectRolePage()), (route) => false),
              ),
              ItemAccount(
                text: 'Dark mode',
                icon: Icons.dark_mode_rounded,
                colorIcon: 0xff051E2F,
              ),
              SizedBox(height: 15.0),
              TextDogsLivery(text: 'Petshop', color: Colors.grey),
              SizedBox(height: 10.0),
              ItemAccount(
                text: 'Categorias',
                icon: Icons.category_rounded,
                colorIcon: 0xff5E65CD,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: CategoriesAdminPage())),
              ),
              ItemAccount(
                text: 'Produtos',
                icon: Icons.add,
                colorIcon: 0xff355773,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ListProductsPage())),
              ),
              ItemAccount(
                text: 'Entregadores',
                icon: Icons.delivery_dining_rounded,
                colorIcon: 0xff469CD7,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ListDeliverysPage())),
              ),
              ItemAccount(
                text: 'Pedidos',
                icon: Icons.checklist_rounded,
                colorIcon: 0xffFFA136,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: OrdersAdminPage())),
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
              Divider(),
              ItemAccount(
                  text: 'Sair A',
                  icon: Icons.power_settings_new_sharp,
                  colorIcon: 0xffF02849,
                  onPressed: () {
                    authBloc.add(LogOutEvent());
                    Navigator.pushAndRemoveUntil(
                        context,
                        routeDogsLivery(page: CheckingLoginPage()),
                        (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
