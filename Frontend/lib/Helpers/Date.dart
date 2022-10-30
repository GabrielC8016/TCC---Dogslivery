// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, prefer_const_constructors, unnecessary_new

import 'package:intl/intl.dart';

class DateDogsLivery {
  static String getDateDogsLivery() {
    int time = DateTime.now().hour;

    if (time < 12)
      return 'Bom Dia';
    else if (time > 12 && time < 18)
      return 'Boa tarde';
    else if (time < 24 && time > 18)
      return 'Boa noite';
    else
      return 'Tudo Bem!';
  }

  static String getDateOrder(String date, {required int fontSize}) {
    var newStr = date.substring(0, 10) + ' ' + date.substring(11, 23);

    DateTime dt = DateTime.parse(newStr);
    dt = dt.subtract(new Duration(hours: 3));
    return DateFormat("d/MM/yyyy HH:mm:ss").format(dt);
  }
}
