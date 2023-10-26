import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:practice2/ImageSliderScreen/image_slider_screen.dart';
import 'package:practice2/widgets/global_variable.dart';

class ListViewWidget extends StatefulWidget {

  final String docId, itemColor, img1, img2, img3, img4, img5, userImg, name, userId, itemModel, postId;
  final String itemPrice, description, address, userNumber;
  final DateTime date;
  final double lat,lng;

  ListViewWidget({
    required this.docId,
    required this.itemColor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.userImg,
    required this.name,
    required this.userId,
    required this.itemModel,
    required this.postId,
    required this.itemPrice,
    required this.description,
    required this.address,
    required this.userNumber,
    required this.date,
    required this.lat,
    required this.lng,
  });

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}


class _ListViewWidgetState extends State<ListViewWidget> {

  Future<Future> showDialogForUpdateData(selectedDoc, oldUserName, oldPhoneNumber, oldItemPrice, oldItemName, oldItemColor, oldItemDescription) async
{
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context)
    {
      return SingleChildScrollView(
        child: AlertDialog(
          title: Text('Update Data',
          style: TextStyle(
            fontFamily: 'Bebas',
            fontSize: 24,
            letterSpacing: 2.0,
          ),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: oldUserName,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldUserName = value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                initialValue: oldPhoneNumber,
                decoration: InputDecoration(
                  hintText: 'Enter Your PhoneNumber'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldPhoneNumber = value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                initialValue: oldItemPrice,
                decoration: InputDecoration(
                  hintText: 'Enter Your Items Price'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldItemPrice = value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                initialValue: oldItemName,
                decoration: InputDecoration(
                  hintText: 'Enter Your Items Name'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldItemName = value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                initialValue: oldItemColor,
                decoration: InputDecoration(
                  hintText: 'Enter Your Items Color'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldItemColor = value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                initialValue: oldItemDescription,
                decoration: InputDecoration(
                  hintText: 'Enter Your Items Description'
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    oldItemDescription = value;
                  });
                },
              ),
              SizedBox(height: 5,),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel'
              ),
            ),
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pop(context); 
                UpdateProfileNameOnExistingPosts(oldUserName);
                _updateUserName(oldUserName, oldPhoneNumber);

                FirebaseFirestore.instance.collection('Items').doc(selectedDoc).update({
                  'userName' : oldUserName,
                  'userNumber' : oldPhoneNumber,
                  'itemPrice' : oldItemPrice,
                  'itemModel' : oldItemName,
                  'itemColor' : oldItemColor,
                  'description' : oldItemDescription,
                }).catchError((onError){
                  print(onError);
                });
                Fluttertoast.showToast(msg: 'Updated...',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.blueGrey,
                fontSize: 18
                );
              },
              child: Text(
                'Update Now'
              ),
            )
          ],
        ),
      );
    } 
  );
}

UpdateProfileNameOnExistingPosts(oldUserName) async
{
  await FirebaseFirestore.instance.collection('Items').where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  .get().then((snapshot) 
  {
    for(int index = 0; index< snapshot.docs.length; index++)
    {
      String userProfileNameInPost = snapshot.docs[index]['userName'];

      if(userProfileNameInPost != oldUserName)
      {
        FirebaseFirestore.instance.collection('Items').doc(snapshot.docs[index].id).update(
          {
            'userName' : oldUserName,
          }
        );
      }
    }
  });
}

Future _updateUserName(oldUserName, oldPhoneNumber) async
{
  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
    {
      'userName': oldUserName,
      'userNumber': oldPhoneNumber,
    }
  );
}




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white24,
        child: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ImageSliderScreen(
                  title: widget.itemModel,
                  itemColor: widget.itemColor,
                  userNumber: widget.userNumber,
                  description: widget.description,
                  lat: widget.lat,
                  lng: widget.lng,
                  address: widget.address,
                  itemPrice: widget.itemPrice,
                  urlImage1: widget.img1,
                  urlImage2: widget.img2,
                  urlImage3: widget.img3,
                  urlImage4: widget.img4,
                  urlImage5: widget.img5,
                )));
              },
              child: Image.network(
                widget.img1,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8,),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      widget.userImg,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        widget.itemModel,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                      SizedBox(height: 5,),
                      Text(
                        DateFormat('dd, MMM, yyyy - hh:mm a').format(widget.date).toString(),
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                      ),                      
                    ],
                  ),
                  widget.userId != uid
                  ?
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Column(),
                  )
                  :
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialogForUpdateData(
                            widget.docId,
                            widget.name,
                            widget.userNumber,
                            widget.itemColor,
                            widget.itemModel,
                            widget.itemPrice,
                            widget.description,
                          );
                        },
                        icon: Padding(

                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('Items').doc(widget.postId).delete();

                          Fluttertoast.showToast(
                            msg: 'Post has been Deleted',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.blueGrey,
                            fontSize: 18,
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.delete_forever,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        ),
      ), 
    );
  }
}