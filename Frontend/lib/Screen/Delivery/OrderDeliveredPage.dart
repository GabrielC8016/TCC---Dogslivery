// ignore_for_file: prefer_is_empty, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Controller/DeliveryController.dart';
import 'package:dogslivery/Models/Response/OrdersByStatusResponse.dart';
import 'package:dogslivery/Screen/Delivery/DeliveryHomePage.dart';
import 'package:dogslivery/Screen/Delivery/OrderDetailsDeliveryPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class OrderDeliveredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextDogsLivery(text: 'Pedidos entregues'),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.push(
              context, routeDogsLivery(page: DeliveryHomePage())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  size: 17, color: ColorsDogsLivery.primaryColor),
              TextDogsLivery(
                  text: 'Voltar',
                  fontSize: 17,
                  color: ColorsDogsLivery.primaryColor)
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<OrdersResponse>?>(
          future: deliveryController.getOrdersForDelivery('ENTREGUE'),
          builder: (context, snapshot) => (!snapshot.hasData)
              ? Column(
                  children: [
                    ShimmerDogsLivery(),
                    SizedBox(height: 10.0),
                    ShimmerDogsLivery(),
                    SizedBox(height: 10.0),
                    ShimmerDogsLivery(),
                  ],
                )
              : _ListOrdersForDelivery(listOrdersDelivery: snapshot.data!)),
    );
  }
}

class _ListOrdersForDelivery extends StatelessWidget {
  final List<OrdersResponse> listOrdersDelivery;

  const _ListOrdersForDelivery({required this.listOrdersDelivery});

  @override
  Widget build(BuildContext context) {
    return (listOrdersDelivery.length != 0)
        ? ListView.builder(
            itemCount: listOrdersDelivery.length,
            itemBuilder: (_, i) => CardOrdersDelivery(
                  orderResponse: listOrdersDelivery[i],
                  onPressed: () => Navigator.push(
                      context,
                      routeDogsLivery(
                          page: OrdersDetailsDeliveryPage(
                              order: listOrdersDelivery[i]))),
                ))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: SvgPicture.asset('Assets/no-data.svg', height: 300)),
              SizedBox(height: 15.0),
              TextDogsLivery(
                  text: 'Sem pedidos entregues',
                  color: ColorsDogsLivery.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 21)
            ],
          );
  }
}
