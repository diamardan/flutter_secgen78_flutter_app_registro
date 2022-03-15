import 'package:cetis32_app_registro/src/screens/access/access_screen.dart';
import 'package:cetis32_app_registro/src/screens/credential/digital_credential_screen.dart';
import 'package:cetis32_app_registro/src/screens/home/home_screen.dart';
import 'package:cetis32_app_registro/src/screens/initial_screen.dart';
import 'package:cetis32_app_registro/src/screens/login/wrapper_auth.dart';
import 'package:cetis32_app_registro/src/screens/my_devices/my_devices_screen.dart';
import 'package:cetis32_app_registro/src/screens/notifications/attachments_screen.dart';
import 'package:cetis32_app_registro/src/screens/notifications/notifications_screen.dart';
import 'package:cetis32_app_registro/src/screens/pago/payment_wrapper.dart';
import 'package:cetis32_app_registro/src/screens/preregistro/create_form.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes(BuildContext context) {
  return <String, WidgetBuilder>{
    'inicio': (BuildContext context) => InitialScreen(),
    'formPreregistro': (BuildContext context) => PreregForm(),
    'pagar': (BuildContext context) => PaymentPage(),
    'wrapper': (BuildContext context) => Wrapper(),
    'access': (BuildContext context) => AccessesScreen(),
    'notifications': (BuildContext context) => NotificationsScreen(),
    'notifications-attachments': (BuildContext context) => AttachmentsScreen(),
    'credential': (BuildContext context) => DigitalCredentialScreen(),
    'my-devices': (BuildContext context) => MyDevicesScreen(),
    'home': (BuildContext context) => HomeScreen()

    //'verCredencialDigital': (BuildContext context) => DigitalCredentialScreen(),
  };
}
