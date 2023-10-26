import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice2/dialog_box/loading_dialog.dart';
import 'package:practice2/home_screen/home.dart';
import 'package:practice2/widgets/global_variable.dart';
import 'package:uuid/uuid.dart';

class UploadAd extends StatefulWidget {

  @override
  State<UploadAd> createState() => _UploadAdState();
}

class _UploadAdState extends State<UploadAd> {

  String postId = Uuid().v4();

  bool uploading = false, next = false;

  final List<File> _image = [];

  List<String> urlsList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String phoneNo = '';
 
  double val = 0;
 
  // CollectionReference? imgRef;

  String itemPrice = '';
  String itemModel = '';
  String itemColor = '';
  String itemDescription = '';

  chooseImage() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async
  {
    int i = 1;
    for(var img in _image)
    {
      setState(() {
        val =  i / _image.length;
      });

      var ref = FirebaseStorage.instance.ref().child('image/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });        
      });
    }
  }

  getNameofUser()
  {
    FirebaseFirestore.instance.collection('users')
    .doc(uid)
    .get()
    .then((snapshot) async {
      if(snapshot.exists)
      {
        setState(() {
          name = snapshot.data()!['userName'];
          phoneNo = snapshot.data()!['userNumber'];
        });
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getNameofUser();
    // imgRef = FirebaseFirestore.instance.collection('imageUrls');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            
            title: Text(
              next ? 'Add the detail about your product'
            : 'Select Images',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'Signatra',
                fontSize: 30,
              ),
            ),
            actions: [
              next ? Container()
              : ElevatedButton(
                onPressed: ()
                {
                  if(_image.length > 0)
                  {
                    setState(() {
                      uploading = true;
                      next = true;
                    });
                  }
                  else
                  {
                    Fluttertoast.showToast(
                      msg: 'Please Select the image',
                      gravity: ToastGravity.CENTER,
                    );
                  }
                },
                child: Text('Next',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 25,
                  fontFamily: 'Signatra'
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent
                ),
              )
            ],
           flexibleSpace: Container(
                  decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
           ),
          ),
          body: next
          ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 5,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the Items Price'
                    ),
                    onChanged: (value)
                    {
                      itemPrice = value;
                    },
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the Item Name'
                    ),
                    onChanged: (value)
                    {
                      itemModel = value;
                    },
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the Item Color'
                    ),
                    onChanged: (value)
                    {
                      itemColor = value;
                    },
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write the Discription about the Item'
                    ),
                    onChanged: (value)
                    {
                      itemDescription = value;
                    },
                  ),
                  SizedBox(height: 25,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        showDialog(context: context, builder: (context){
                          return LoadingAlertDialog(
                            message: 'Uploading....',
                          );
                        });
                        uploadFile().whenComplete(() {
                          FirebaseFirestore.instance.collection('Items').doc(postId).set({
                            'userName' : name,
                            'id' : _auth.currentUser!.uid,
                            'postId' : postId,
                            'userNumber' : phoneNo,
                            'itrmPrice' : itemPrice,
                            'itemModel' : itemModel,
                            'itemColor' : itemColor,
                            'itemDescription' : itemDescription,
                            'urlImage1' : urlsList[0].toString(),
                            'urlImage2' : urlsList[1].toString(),
                            'urlImage3' : urlsList[2].toString(),
                            'urlImage4' : urlsList[3].toString(),
                            'urlImage5' : urlsList[4].toString(),
                            'imgPro' : userImageUrl,
                            'Lat' : position!.latitude,
                            'Lng' : position!.longitude,
                            'address' : completeAddress,
                            'time' : DateTime.now(),
                            'status' : 'approved',
                          });
                          Fluttertoast.showToast(
                            msg: 'Data uploaded Successfully....',
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).catchError((onError){
                          print(onError);
                        });
                      },
                      child: Text(
                        'Upload',
                        style: TextStyle(
                  color: Colors.black54,
                  fontSize: 27,
                  fontFamily: 'Signatra'
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
          : Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index)
                  {
                    return index == 0
                    ? Center(
                      child: IconButton(
                        icon: Icon(Icons.add,),
                        onPressed: ()
                        {
                           !uploading ? chooseImage() : null;
                        },
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image[index - 1]),
                          fit: BoxFit.cover, 
                        )
                      ),
                    );
                  },
                ),
              ),
              uploading
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Uploading',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10,),
                    CircularProgressIndicator(
                      value: val,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  ],
                ),
              )
              : Container(),
            ],
          )
        ),
    );
  }
}