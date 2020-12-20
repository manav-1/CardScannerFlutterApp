import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as Io;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

class ScanningPage extends StatefulWidget {
  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  Io.File imageFile;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  Future _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _uploadFile(image);
    setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
  }

  _openGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadFile(image);
    setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> showChoiceDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select one'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  final String endPoint = 'http://10.0.2.2:5000/';

  Future _uploadFile(filename) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endPoint));
      request.files.add(http.MultipartFile(
          'img', filename.readAsBytes().asStream(), filename.lengthSync(),
          filename: filename.path.split("/").last));

      var res = await request.send();
      final respstring = await res.stream.bytesToString();
      print(respstring);
      print(res.statusCode);
      print(res.toString());
      print(res.stream.toStringStream());
      //print(res.stream.bytesToString());
      print(res.contentLength);
      print(res.request);
      print(res.reasonPhrase);
      // print(res.body);
      if (res.contentLength == 230) {
        print("updated");
        Fluttertoast.showToast(
            msg: "Details Updated", toastLength: Toast.LENGTH_LONG);
      } else {
        print("Not able to update");
        Fluttertoast.showToast(
            msg: "Details not updated please do again",
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _scaffoldstate,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Visiting Card Scanner',
            style: GoogleFonts.lato(
              fontSize: 40.0,
            ),
          ),
          centerTitle: true,
          titleSpacing: 2.0,
          flexibleSpace: Container(),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                    1.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: FlatButton.icon(
                      onPressed: () {
                        showChoiceDialogue(context);
                      },
                      icon: Center(
                          child: Icon(
                        Icons.camera_alt,
                        size: 60.0,
                        color: Colors.white,
                      )),
                      label: Text('CLICK HERE TO SCAN',
                          style: GoogleFonts.roboto(fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
