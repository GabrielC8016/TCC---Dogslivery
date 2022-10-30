import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Screen/Delivery/ListOrdersDeliveryPage.dart';
import 'package:dogslivery/Screen/Delivery/OrderDeliveredPage.dart';
import 'package:dogslivery/Screen/Delivery/OrderOnWayPage.dart';
import 'package:dogslivery/Screen/Profile/ChangePasswordPage.dart';
import 'package:dogslivery/Screen/Profile/EditProdilePage.dart';
import 'package:dogslivery/Screen/Home/SelectRolePage.dart';
import 'package:dogslivery/Screen/Intro/CheckingLoginPage.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/ImagePicker.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

// ignore: use_key_in_widget_constructors
class DeliveryHomePage extends StatelessWidget {
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
                  context, routeDogsLivery(page: DeliveryHomePage())));
          Navigator.pop(context);
        } else if (state is FailureAuthState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              const SizedBox(height: 20.0),
              Align(
                  alignment: Alignment.center, child: ImagePickerDogsLivery()),
              const SizedBox(height: 20.0),
              Center(
                  child: TextDogsLivery(
                      text:
                          '${authBloc.state.user!.firstName} ${authBloc.state.user!.lastName}',
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 5.0),
              Center(
                  child: TextDogsLivery(
                      text: authBloc.state.user!.email,
                      fontSize: 20,
                      color: Colors.grey)),
              const SizedBox(height: 15.0),
              const TextDogsLivery(text: 'Conta', color: Colors.grey),
              const SizedBox(height: 10.0),
              ItemAccount(
                text: 'Configuração do perfil',
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
                text: 'Alterar função',
                icon: Icons.swap_horiz_rounded,
                colorIcon: 0xffE62755,
                onPressed: () => Navigator.pushAndRemoveUntil(context,
                    routeDogsLivery(page: SelectRolePage()), (route) => false),
              ),
              const ItemAccount(
                text: 'Dark mode',
                icon: Icons.dark_mode_rounded,
                colorIcon: 0xff051E2F,
              ),
              const SizedBox(height: 15.0),
              const TextDogsLivery(text: 'Delivery', color: Colors.grey),
              const SizedBox(height: 10.0),
              ItemAccount(
                text: 'Pedidos',
                icon: Icons.checklist_rounded,
                colorIcon: 0xff5E65CD,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: ListOrdersDeliveryPage())),
              ),
              ItemAccount(
                text: 'A caminho',
                icon: Icons.delivery_dining_rounded,
                colorIcon: 0xff1A60C1,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: OrderOnWayPage())),
              ),
              ItemAccount(
                text: 'Entregue',
                icon: Icons.check_rounded,
                colorIcon: 0xff4BB17B,
                onPressed: () => Navigator.push(
                    context, routeDogsLivery(page: OrderDeliveredPage())),
              ),
              const SizedBox(height: 15.0),
              const TextDogsLivery(text: 'Pessoal', color: Colors.grey),
              const SizedBox(height: 10.0),
              const ItemAccount(
                text: 'Política de Privacidade',
                icon: Icons.policy_rounded,
                colorIcon: 0xff6dbd63,
              ),
              const ItemAccount(
                text: 'Segurança',
                icon: Icons.lock_outline_rounded,
                colorIcon: 0xff1F252C,
              ),
              const ItemAccount(
                text: 'Termo e Condições',
                icon: Icons.description_outlined,
                colorIcon: 0xff458bff,
              ),
              const ItemAccount(
                text: 'Ajuda',
                icon: Icons.help_outline,
                colorIcon: 0xff4772e6,
              ),
              const Divider(),
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
      ),
    );
  }
}
