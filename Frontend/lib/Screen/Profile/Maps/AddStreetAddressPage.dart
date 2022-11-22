// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dogslivery/Bloc/My%20Location/mylocationmap_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Screen/Profile/ListAddressesPage.dart';
import 'package:dogslivery/Screen/Profile/Maps/MapAddressPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class AddStreetAddressPage extends StatefulWidget {
  @override
  _AddStreetAddressPageState createState() => _AddStreetAddressPageState();
}

class _AddStreetAddressPageState extends State<AddStreetAddressPage> {
  late TextEditingController _streetAddressController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _streetAddressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _streetAddressController.clear();
    _streetAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final myLocationBloc = BlocProvider.of<MylocationmapBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Endereço adicionado com Sucesso',
              () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: ListAddressesPage())));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextDogsLivery(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextDogsLivery(text: 'Novo Endereço', fontSize: 19),
          centerTitle: true,
          elevation: 0,
          leadingWidth: 80,
          leading: TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: ListAddressesPage())),
              child: TextDogsLivery(
                  text: 'Cancelar',
                  color: ColorsDogsLivery.primaryColor,
                  fontSize: 17)),
          actions: [
            TextButton(
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    userBloc.add(OnAddNewAddressEvent(
                        _streetAddressController.text.trim(),
                        myLocationBloc.state.addressName,
                        myLocationBloc.state.locationCentral!));
                  }
                },
                child: TextDogsLivery(
                    text: 'Salvar',
                    color: ColorsDogsLivery.primaryColor,
                    fontSize: 17)),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDogsLivery(text: 'Complemento'),
                  SizedBox(height: 5.0),
                  FormFieldDogsLivery(
                    controller: _streetAddressController,
                    validator:
                        RequiredValidator(errorText: 'Endereço é Obrigatório'),
                  ),
                  SizedBox(height: 20.0),
                  TextDogsLivery(text: 'Lozalização'),
                  SizedBox(height: 5.0),
                  InkWell(
                    onTap: () async {
                      final permissionGPS = await Permission.location.isGranted;
                      final gpsActive =
                          await Geolocator.isLocationServiceEnabled();

                      if (permissionGPS && gpsActive) {
                        Navigator.push(
                            context,
                            navigatorPageFadeInDogsLivery(
                                context, MapLocationAddressPage()));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: .5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: BlocBuilder<MylocationmapBloc, MylocationmapState>(
                          builder: (_, state) =>
                              TextDogsLivery(text: state.addressName)),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextDogsLivery(
                          text: 'Selecione a Localização',
                          fontSize: 16,
                          color: Colors.grey))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
