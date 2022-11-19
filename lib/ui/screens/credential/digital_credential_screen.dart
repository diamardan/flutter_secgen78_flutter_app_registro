import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:secgen78_app_registro/src/models/user_model.dart';
import 'package:secgen78_app_registro/src/provider/user_provider.dart';
import 'package:secgen78_app_registro/ui/res/colors.dart';
import 'package:secgen78_app_registro/ui/screens/credential/render_crendetial_screen.dart';
import 'package:secgen78_app_registro/src/utils/imageUtil.dart';
import 'package:secgen78_app_registro/src/utils/widget_to_image.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class DigitalCredentialScreen extends StatefulWidget {
  @override
  _DigitalCredentialScreenState createState() =>
      _DigitalCredentialScreenState();
}

const timeout = const Duration(seconds: 5);

class _DigitalCredentialScreenState extends State<DigitalCredentialScreen> {
  GlobalKey key1;
  GlobalKey key2;
  Uint8List bytes1;
  Uint8List bytes2;
  bool visibleButton;
  Registration register;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getStudentData();
  }

  _getStudentData() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    register = userProvider.getRegistration;
  }

  startTimeout() {
    return new Timer(timeout, handleTimeout);
  }

  void handleTimeout() {
    if (mounted)
      setState(() {
        visibleButton = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credencial inteligente"),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: visibleButton == true ? true : false,
        child: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            //backgroundColor: canDownload == true ? Colors.blue : Colors.grey,
            label: Text("Descargar"),
            icon: Icon(Icons.download),
            /* child: 
                Icon(Icons.download),
            ), */
            onPressed: () async {
              _showSnackbar("Su descarga comenzará en breve");
              final bytes1 = await ImageUtils.capture(key1);
              final bytes2 = await ImageUtils.capture(key2);

              setState(() {
                this.bytes1 = bytes1;
                this.bytes2 = bytes2;
              });
              makePdf();
            }),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _anversoCredencial(),
            WidgetToImage(builder: (key) {
              this.key2 = key;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  height: 555,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        image: AssetImage(
                            'assets/img/credencial/reverso2022.png')),
                  ),
                  child: Column(
                    children: <Widget>[
                      _midReverso(),
                    ],
                  ),
                ),
              );
            }),
            /* buildImage(bytes1),
            buildImage(bytes2), */
          ]),
        ),
      )),
    );
  }

  Widget _midReverso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 120),
        Container(
            height: 140,
            width: 140,
            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
            child: _networkImageWidget(200, 150, register.qrDrive)),
        SizedBox(height: 145),
        Container(
          width: 250,
          child: Text(
            "18 OCTUBRE 2022",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        )
        /* Container(
            height: 50,
            width: 185,
            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
            child: _networkImageWidget(200, 150, register.firmaDrive)), */
      ],
    );
  }

  Widget _anversoCredencial() {
    String matricula = register.registrationCode.toString();
    return WidgetToImage(builder: (key) {
      this.key1 = key;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 10,
        child: Container(
          height: 555,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/img/credencial/anverso2022.png')),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 555,
                width: 345,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    _upperFront(),
                    SizedBox(
                      height: 30,
                    ),
                    _cintilla(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 350,
                      child: Text(
                        register.curp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /* Container(
                      width: 350,
                      child: Text(
                        register.career,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ), */
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 70),
                      width: 350,
                      child: Text(
                        register.registrationCode,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    matricula != null && matricula != ''
                        ? Container(
                            padding: EdgeInsets.only(left: 45, right: 45),
                            width: 350,
                            height: 40,
                            color: Colors.white,
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: '$matricula',
                              width: 130,
                              height: 20,
                              drawText: false,
                            ))
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _upperFront() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //left Column
          color: Colors.transparent,
          height: 216,
          width: 93,
          padding: EdgeInsets.only(
            top: 40,
          ),
          child: Column(children: <Widget>[
            SizedBox(
              height: 13,
            ),
            _networkImageWidget(100, 100, register.qrDrive),
            Container(
              margin: EdgeInsets.only(top: 30, right: 8),
              child: Text(
                register.idbio.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ]),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
            //Foto
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              _networkImageWidget(194, 128, register.fotoUsuarioDrive),
            ]),
        SizedBox(
          width: 20,
        ),
        Container(
          //RightColumn
          color: Colors.transparent,
          height: 206,
          width: 80,
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 40,
                  child: Text(
                    register.grade.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.transparent),
                  height: 90,
                  child: Center(
                    child: Text(
                      register.group.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 90,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      register.turn.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ]),
        )
      ],
    );
  }

  Widget _cintilla() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 70,
      width: 350,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
              fit: BoxFit.scaleDown,
              child: new Text(
                register.surnames,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                register.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Widget _networkImageWidget(double height, double width, String image,
      [bool transparency, bool margin, double marginTop]) {
    if (register.fotoUsuarioDrive == null || image == "") {
      image = "1TvA4s1r-c2NpsPCRdHozdk8dk0xQ_riY";
    }
    return Container(
        height: height,
        width: width,
        margin: margin == true ? EdgeInsets.fromLTRB(0, marginTop, 0, 0) : null,
        child: Image.network(
          'https://drive.google.com/uc?export=view&id=${image}',
          alignment: Alignment.center,
          fit: BoxFit.fill,
          color: transparency == true
              ? const Color.fromRGBO(255, 255, 255, 0.5)
              : null,
          colorBlendMode: transparency == true ? BlendMode.modulate : null,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) {
              startTimeout();
              return child;
            } /* else {
              if (loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes ==
                      1.0 &&
                  image == this.register.fotoUsuarioDrive) {
                startTimeout();
              }
            } */

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                  Text("Descargando imagen ")
                ],
              ),
            );
          },
        ));
  }

  Widget buildImage(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();

  void _showSnackbar(String content) {
    final snackBar = SnackBar(content: (Text(content)));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> makePdf() async {
    final pdf = pw.Document();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              pw.Image(
                pw.MemoryImage(
                  bytes1,
                ),
                height: 300,
                //fit: pw.BoxFit.fitHeight
              ),
              pw.SizedBox(width: 10),
              pw.Image(
                pw.MemoryImage(
                  bytes2,
                ),
                height: 300,
                //fit: pw.BoxFit.fitHeight
              ),
              // ImageImage(bytes1),
              //pw.Image(pw.MemoryImage(bytes1)),
            ]),
      ),
    );

// the downloads folder path
    //Directory output = await getDownloadsDirectory();
    // String tempPath = '/storage/emulated/0/Download';
    String tempPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String apellidos =
        register.surnames != null ? register.surnames : "SIN APELLIDOS";
    String nombre = register.name != null ? register.name : "SIN NOMBRE";
    //output.path;
    var pdfName = apellidos + " " + nombre + ".pdf";
    var filePath = tempPath + '/${pdfName.replaceAll(" ", "_")}';
    final file = File(filePath);
    //
    /* final output = await getExternalStorageDirectory();
    final path = "${output.path}/credencial.pdf";
    final file = File(path); */
    print(filePath);
    /* final file = File('example.pdf');*/
    await file.writeAsBytes(await pdf.save());
    print("hola");
    _showSnackbar("El PDF está en su carpeta de Descargas");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RenderCredentialScreen(
                  pdfPath: filePath,
                  pdfName: pdfName,
                )));
    //launch(filePath);
  }
}

/* class DigitalCredentialScreen extends StatelessWidget {
  final register register;
  
  const DigitalCredentialScreen(this.register, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey key1;
    GlobalKey key2;
    return Scaffold(
      appBar: AppBar(
        title: Text("MI CREDENCIAL"),
        centerTitle: true,
        backgroundColor: AppColors.morenaLightColor,
      ),
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: AppColors.morenaColor,
          child: Icon(Icons.download),
          onPressed: () {}),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            WidgetToImage(
              builder: (key) => Card(
                /* semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer, */
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  height: 490,
                  width: 310,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        image: AssetImage('assets/img/credencial/anverso.png')),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 128),
                      _cintillaFoto(),
                      _cintillaBlanca(),
                      _cintillaNombre(),
                      _cintillaEspecialidad(),
                      _cintillaNumeroControl(),
                      /* Container(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              //color: AppColors.morenaColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: double.infinity,
                          child: Text("hola 1"),
                        ), 
                      )*/
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Container(
                height: 490,
                width: 310,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/img/credencial/reverso.png')),
                ),
                child: Column(
                  children: <Widget>[
                    _cintillaTurno(),
                    _espacioQR(),
                    _firmaAlumno(),
                    _fotoReverso()
                  ],
                ),
              ),
            ),
          ]),
        ),
      )),
    );
  }

  Widget _cintillaFoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 174,
          width: 81,
          /* child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("IDBIO"),
                              Text("IDBIO"),
                            ],
                          ), */
        ),
        Container(
          height: 174,
          width: 148,
          child: Image.network(
            'https://drive.google.com/uc?export=view&id=${register.fotoUsuarioDrive}',
            alignment: Alignment.center,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 80,
              child: Text(
                register.grupo != null ? register.grupo : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "GRUPO",
              style: TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Widget _cintillaBlanca() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 70,
          //color: Colors.red,
          child: Column(
            children: [
              Text(
                register.idbio.toString() != null
                    ? register.idbio.toString()
                    : "-",
                style: TextStyle(color: AppColors.textoRojoCredencial),
              ),
              Text(
                "IDBIO",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        ),
        Container(
          width: 170,
          //color: Colors.blue,
          child: Column(
            children: [
              Text(
                register.id != null ? register.id : '-',
                style: TextStyle(color: AppColors.textoRojoCredencial),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "ALUMNO",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        ),
        Container(
          width: 70,
          //color: Colors.green,
          child: Column(
            children: [
              Text(
                register.grado != null ? register.grado : "-",
                style: TextStyle(color: AppColors.textoRojoCredencial),
              ),
              Text(
                "SEMESTRE",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoRojoCredencial),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cintillaNombre() {
    return Container(
      height: 60,
      width: double.infinity,
      //color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 30,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.nombre != null ? register.nombre : "-",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          Container(
            height: 30,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.apellidos != null ? register.apellidos : "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cintillaEspecialidad() {
    return Container(
      height: 40,
      width: double.infinity,
      //color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("ESPECIALIDAD",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoRojoCredencial)),
            ),
          ),
          Container(
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(register.carrera != null ? register.carrera : "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoRojoCredencial)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cintillaNumeroControl() {
    return Container(
      height: 35,
      child: Column(
        children: <Widget>[
          Text(
            'No. CONTROL   ${register.matricula != "" ? register.matricula : "NO CAPTURADO"}',
            style: TextStyle(color: AppColors.textoRojoCredencial),
          ),
          Image.asset(
            'assets/img/credencial/barcode.PNG',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget _cintillaTurno() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      //color: Colors.red,
      height: 30,
      width: double.infinity,
      child: Text(
        register.turno != null ? register.turno : "-",
        textAlign: TextAlign.right,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _espacioQR() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          //color: Colors.amber,
        ),
        Container(
          width: 150,
          height: 150,
          //color: Colors.redAccent,
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Image.network(
                'https://drive.google.com/uc?export=view&id=${register.qrDrive}',
                height: 110,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _firmaAlumno() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100,
          height: 90,
          //color: Colors.amber,
        ),
        Container(
          width: 200,
          height: 60,
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          //color: Colors.redAccent,
          child: Image.network(
            'https://drive.google.com/uc?export=view&id=${register.firmaDrive}',
            height: 50,
            //fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Widget _fotoReverso() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(0),
          //color: Colors.green,
          height: 90,
          width: 80,
          child: Image.network(
            'https://drive.google.com/uc?export=view&id=${register.fotoUsuarioDrive}',
            color: const Color.fromRGBO(255, 255, 255, 0.5),
            colorBlendMode: BlendMode.modulate,
            alignment: Alignment.center,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }
}
 */
