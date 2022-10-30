// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dogslivery/Bloc/My%20Location/mylocationmap_bloc.dart';
import 'package:dogslivery/Bloc/Orders/orders_bloc.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Models/Response/OrderDetailsResponse.dart';
import 'package:dogslivery/Models/Response/OrdersByStatusResponse.dart';
import 'package:dogslivery/Screen/Delivery/MapDeliveryPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class OrdersDetailsDeliveryPage extends StatefulWidget {
  final OrdersResponse order;

  const OrdersDetailsDeliveryPage({required this.order});

  @override
  _OrdersDetailsDeliveryPageState createState() =>
      _OrdersDetailsDeliveryPageState();
}

class _OrdersDetailsDeliveryPageState extends State<OrdersDetailsDeliveryPage> {
  late MylocationmapBloc mylocationmapBloc;

  @override
  void initState() {
    mylocationmapBloc = BlocProvider.of<MylocationmapBloc>(context);
    mylocationmapBloc.initialLocation();
    super.initState();
  }

  @override
  void dispose() {
    mylocationmapBloc.cancelLocation();
    super.dispose();
  }

  void accessGps(PermissionStatus status, BuildContext context) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacement(context,
            routeDogsLivery(page: MapDeliveryPage(order: widget.order)));
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

    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is LoadingOrderState) {
          modalLoading(context);
        } else if (state is SuccessOrdersState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'A CAMINHO',
              () async =>
                  accessGps(await Permission.location.request(), context));
        } else if (state is FailureOrdersState) {
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
          elevation: 0,
          title: TextDogsLivery(
              text: 'PEDIDO N# ${widget.order.orderId}',
              fontWeight: FontWeight.w500),
          centerTitle: true,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 17, color: ColorsDogsLivery.primaryColor),
                TextDogsLivery(
                    text: 'Voltar',
                    color: ColorsDogsLivery.primaryColor,
                    fontSize: 17)
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: FutureBuilder<List<DetailsOrder>?>(
                    future: ordersController
                        .gerOrderDetailsById(widget.order.orderId.toString()),
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
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'TOTAL',
                          color: ColorsDogsLivery.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      TextDogsLivery(
                          text: '\$ ${widget.order.amount}0',
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'FORMA DE PAGAMENTO',
                          color: ColorsDogsLivery.primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      TextDogsLivery(text: widget.order.payType!, fontSize: 16),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'CLIENTE',
                          color: ColorsDogsLivery.primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        (widget.order.clientImage != null)
                                            ? URLS.BASE_URL +
                                                widget.order.clientImage!
                                            : URLS.BASE_URL +
                                                'without-image.png'))),
                          ),
                          SizedBox(width: 10.0),
                          TextDogsLivery(text: '${widget.order.cliente}'),
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
                          color: ColorsDogsLivery.primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      TextDogsLivery(
                          text: DateDogsLivery.getDateOrder(
                              widget.order.currentDate.toString(),
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'ENDEREÇO',
                          color: ColorsDogsLivery.primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      TextDogsLivery(
                          text: widget.order.reference!,
                          maxLine: 1,
                          fontSize: 15),
                    ],
                  ),
                  SizedBox(height: 15.0)
                ],
              ),
            ),
            (widget.order.status != 'ENTREGUE')
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<MylocationmapBloc, MylocationmapState>(
                          builder: (context, state) => BtnDogsLivery(
                            text: widget.order.status == 'DESPACHOU'
                                ? 'INICIAR A ENTREGA'
                                : 'IR PARA O MAPA',
                            color: widget.order.status == 'DESPACHOU'
                                ? Color(0xff0C6CF2)
                                : Colors.indigo,
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              if (widget.order.status == 'DESPACHOU') {
                                if (state.location != null) {
                                  orderBloc.add(OnUpdateStatusOrderOnWayEvent(
                                      widget.order.orderId.toString(),
                                      state.location!));
                                }
                              }
                              if (widget.order.status == 'A CAMINHO') {
                                Navigator.push(
                                    context,
                                    routeDogsLivery(
                                        page: MapDeliveryPage(
                                            order: widget.order)));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
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
