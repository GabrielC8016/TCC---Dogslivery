// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, file_names

part of 'Widgets.dart';

class CardOrdersDelivery extends StatelessWidget {
  final OrdersResponse orderResponse;
  final VoidCallback? onPressed;

  const CardOrdersDelivery({required this.orderResponse, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: -5)
          ]),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextDogsLivery(text: 'Pedido Nº: ${orderResponse.orderId}'),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDogsLivery(
                      text: 'Data:',
                      fontSize: 16,
                      color: ColorsDogsLivery.secundaryColor),
                  TextDogsLivery(
                      text: DateDogsLivery.getDateOrder(
                          orderResponse.currentDate.toString(),
                          fontSize: 16)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDogsLivery(
                      text: 'Cliente:',
                      fontSize: 16,
                      color: ColorsDogsLivery.secundaryColor),
                  TextDogsLivery(text: orderResponse.cliente!, fontSize: 16),
                ],
              ),
              SizedBox(height: 10.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextDogsLivery(
                    text: 'Endereço:',
                    fontSize: 16,
                    color: ColorsDogsLivery.secundaryColor),
                TextDogsLivery(
                    text: orderResponse.reference!, fontSize: 16, maxLine: 2),
                //SizedBox(height: 5.0)
              ]),
              /*Align(
                  alignment: Alignment.centerRight,
                  child: TextDogsLivery(
                      text: orderResponse.reference!,
                      fontSize: 12,
                      maxLine: 2)),
              */
              //SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
