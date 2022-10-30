// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_is_empty, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Controller/UserController.dart';
import 'package:dogslivery/Models/Response/AddressesResponse.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class SelectAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextDogsLivery(
          text: 'Selecionar Endereço',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: ColorsDogsLivery.primaryColor, size: 21),
              TextDogsLivery(
                  text: 'Voltar',
                  fontSize: 16,
                  color: ColorsDogsLivery.primaryColor)
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ListAddress>?>(
          future: userController.getAddresses(),
          builder: (context, snapshot) => (!snapshot.hasData)
              ? ShimmerDogsLivery()
              : _ListAddresses(listAddress: snapshot.data!)),
    );
  }
}

class _ListAddresses extends StatelessWidget {
  final List<ListAddress> listAddress;

  const _ListAddresses({Key? key, required this.listAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return (listAddress.length != 0)
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            itemCount: listAddress.length,
            itemBuilder: (_, i) => Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                leading: BlocBuilder<UserBloc, UserState>(
                    builder: (_, state) =>
                        (state.uidAddress == listAddress[i].id)
                            ? Icon(Icons.radio_button_checked_rounded,
                                color: ColorsDogsLivery.primaryColor)
                            : Icon(Icons.radio_button_off_rounded)),
                title: TextDogsLivery(
                    text: listAddress[i].street!,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                subtitle: TextDogsLivery(
                    text: listAddress[i].reference!,
                    fontSize: 16,
                    color: ColorsDogsLivery.secundaryColor),
                onTap: () => userBloc.add(OnSelectAddressButtonEvent(
                    listAddress[i].id!, listAddress[i].reference!)),
              ),
            ),
          )
        : _WithoutListAddress();
  }
}

class _WithoutListAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('Assets/my-location.svg', height: 400),
          TextDogsLivery(
              text: 'Sem Endereço',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: ColorsDogsLivery.secundaryColor),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
