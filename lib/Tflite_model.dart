import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


class TfliteModel extends StatefulWidget {

  const TfliteModel({Key? key}) : super(key: key);

  @override
  State<TfliteModel> createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  File? image;
  var _output;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then(value){
      setState()
    };
  }

  runModelOnImage(){
    Tflite.runModelOnImage(path: image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: ListView(
        children: [
          image != null ? Image.file(
              image!,
            width: 224,
            height: 224,
            fit: BoxFit.cover,
          ) : const FlutterLogo(size: 160),

          const Center(
            child: Text('Label', style: TextStyle(fontSize: 20),),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          pickImage();
        },
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null){
        return;
      }
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e){
      print('Fail to pick image:  $e');
    }

  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt'
    );
  }

  @override
  void dispose(){
    Tflite.close();
    super.dispose();
  }

}


