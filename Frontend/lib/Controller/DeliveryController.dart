// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dogslivery/Helpers/secure_storage.dart';
import 'package:dogslivery/Models/Response/GetAllDeliveryResponse.dart';
import 'package:dogslivery/Models/Response/OrdersByStatusResponse.dart';
import 'package:dogslivery/Services/url.dart';

class DeliveryController {
  Future<List<Delivery>?> getAlldelivery() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${URLS.URL_API}/get-all-delivery'),
        headers: {'Accept': 'application/json', 'xx-token': token!});

    return GetAllDeliveryResponse.fromJson(jsonDecode(resp.body)).delivery;
  }

  Future<List<OrdersResponse>?> getOrdersForDelivery(String statusOrder) async {
    final token = await secureStorage.readToken();

    // ignore: prefer_interpolation_to_compose_strings
    final resp = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse('${URLS.URL_API}/get-all-orders-by-delivery/' + statusOrder),
        headers: {'Accept': 'application/json', 'xx-token': token!});

    return OrdersByStatusResponse.fromJson(jsonDecode(resp.body))
        .ordersResponse;
  }
}

final deliveryController = DeliveryController();
