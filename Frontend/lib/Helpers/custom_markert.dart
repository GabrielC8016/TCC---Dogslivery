// ignore_for_file: prefer_const_constructors

part of 'Helpers.dart';

Future<BitmapDescriptor> getAssetImageMarker(String imagePath) async {
  return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), imagePath);
}
