import 'package:cetis32_app_registro/src/screens/login/login_options_screen.dart';
import 'package:flutter/material.dart';

class LastScreen extends StatelessWidget {
  const LastScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro finalizado"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return LoginOptionsScreen();
              }),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
                height: size.height * .4,
                child: Center(child: AppLogo(context))),
            //TextoFin(context),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Las instrucciones para recoger su credencial se han enviado al correo registrado.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: size.width * .2,
              right: size.width * .2,
              child: Center(
                  child: MaterialButton(
                minWidth: 200.0,
                height: 35,
                color: Color(0xFF801E48),
                child: new Text('Salir',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return LoginOptionsScreen();
                    }),
                  );
                  //Navigator.popUntil(context, ModalRoute.withName('login'));
                },
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget AppLogo(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .3,
          child: Image.asset('assets/img/cetis32logo.png'),
        )
      ],
    );
  }

  Widget TextoFin(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .4,
          child: Image.asset('assets/img/logo.png'),
        )
      ],
    );
  }
}
