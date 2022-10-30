// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Models/Response/OrderDetailsResponse.dart';
import 'package:dogslivery/Models/Response/OrdersClientResponse.dart';
import 'package:dogslivery/Screen/Client/ClientMapPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import '../../Bloc/Orders/orders_bloc.dart';
import 'ClientHomePage.dart';

class ClientDetailsOrderPage extends StatelessWidget {
  final OrdersClient orderClient;

  const ClientDetailsOrderPage({required this.orderClient});

  void accessGps(PermissionStatus status, BuildContext context) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacement(context,
            routeDogsLivery(page: ClientMapPage(orderClient: orderClient)));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderBloc = BlocProvider.of<OrdersBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextDogsLivery(
            text: 'PEDIDO # ${orderClient.id}',
            fontSize: 17,
            fontWeight: FontWeight.w500),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: ColorsDogsLivery.primaryColor, size: 17),
              TextDogsLivery(
                  text: 'Voltar',
                  fontSize: 17,
                  color: ColorsDogsLivery.primaryColor)
            ],
          ),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10.0),
            child: TextDogsLivery(
              text: orderClient.status!,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: (orderClient.status == 'DESPACHOU'
                  ? ColorsDogsLivery.primaryColor
                  : ColorsDogsLivery.secundaryColor),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: FutureBuilder<List<DetailsOrder>?>(
                  future: ordersController
                      .gerOrderDetailsById(orderClient.id.toString()),
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
                      : _ListProductsDetails(
                          listProductDetails: snapshot.data!))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDogsLivery(
                        text: 'TOTAL',
                        fontWeight: FontWeight.w500,
                        color: ColorsDogsLivery.primaryColor),
                    TextDogsLivery(
                        text: '\$ ${orderClient.amount}0',
                        fontWeight: FontWeight.w500),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDogsLivery(
                        text: 'ENTREGA',
                        fontWeight: FontWeight.w500,
                        color: ColorsDogsLivery.primaryColor,
                        fontSize: 17),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      (orderClient.imageDelivery != null)
                                          ? URLS.BASE_URL +
                                              orderClient.imageDelivery!
                                          : URLS.BASE_URL +
                                              'without-image.png'))),
                        ),
                        SizedBox(width: 10.0),
                        TextDogsLivery(
                            text: (orderClient.deliveryId != 0)
                                ? orderClient.delivery!
                                : 'Não atribuído',
                            fontSize: 17),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDogsLivery(
                        text: 'DATA',
                        fontWeight: FontWeight.w500,
                        color: ColorsDogsLivery.primaryColor,
                        fontSize: 17),
                    TextDogsLivery(
                        text: DateDogsLivery.getDateOrder(
                            orderClient.currentDate.toString(),
                            fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDogsLivery(
                        text: 'ENDEREÇO',
                        fontWeight: FontWeight.w500,
                        color: ColorsDogsLivery.primaryColor,
                        fontSize: 16),
                    TextDogsLivery(
                        text: orderClient.reference!, fontSize: 16, maxLine: 1),
                  ],
                ),
                SizedBox(height: 20.0),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Confirmar cancelamento'),
                            content: const Text(
                                'Tem certeza que deseja cancelar seu pedido?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Não'),
                                child: const Text('Não'),
                              ),
                              TextButton(
                                onPressed: () => {
                                  orderBloc.add(OnCancelOrderEvent(
                                      orderClient.id.toString())),
                                  Navigator.push(context,
                                      routeDogsLivery(page: ClientHomePage())),
                                },
                                child: const Text('Sim'),
                              ),
                            ],
                          )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel,
                          color: ColorsDogsLivery.primaryColor, size: 17),
                      TextDogsLivery(
                          text: 'Cancelar pedido',
                          fontSize: 17,
                          color: ColorsDogsLivery.primaryColor)
                    ],
                  ),
                ),
              ],
            ),
          ),
          (orderClient.status == 'A CAMINHO')
              ? Container(
                  padding: EdgeInsets.all(15.0),
                  child: BtnDogsLivery(
                    text: 'RASTREAR ENTREGA',
                    fontWeight: FontWeight.w500,
                    onPressed: () async =>
                        accessGps(await Permission.location.request(), context),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class _ListProductsDetails extends StatelessWidget {
  final List<DetailsOrder> listProductDetails;

  const _ListProductsDetails({required this.listProductDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: listProductDetails.length,
      separatorBuilder: (_, index) => Divider(),
      itemBuilder: (_, i) => Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          URLS.BASE_URL + listProductDetails[i].picture!))),
            ),
            SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextDogsLivery(
                    text: listProductDetails[i].nameProduct!,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 5.0),
                TextDogsLivery(
                    text: 'Quantidade: ${listProductDetails[i].quantity}',
                    color: Colors.grey,
                    fontSize: 17),
              ],
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: TextDogsLivery(text: '\$ ${listProductDetails[i].total}'),
            ))
          ],
        ),
      ),
    );
  }
}
