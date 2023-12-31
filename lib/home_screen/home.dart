import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:practice2/SearchProduct/search_product.dart';
import 'package:practice2/WelcomeScreen/welcomeScreen.dart';
import 'package:practice2/profileScreen/profile_screen.dart';
import 'package:practice2/uploadAdScreen/upload_ad.dart';
import 'package:practice2/widgets/global_variable.dart';
import 'package:practice2/widgets/list_view_widget.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  getMyData()
  {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((results) 
    {
      setState(() {
        userImageUrl = results.data()!['userImage'];
        getUserName = results.data()!['userName'];
      });
    });
  }

  getUserAddress() async
  {
    Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    position = newPosition;

    placemarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark placemark = placemarks![0];

    String newCompleteAddress = '${placemark.subThoroughfare} ${placemark.thoroughfare},'
                                '${placemark.subThoroughfare} ${placemark.locality},'
                                '${placemark.subAdministrativeArea},'
                                '${placemark.administrativeArea} ${placemark.postalCode},'
                                '${placemark.country},';  

                                completeAddress = newCompleteAddress;

                                print(completeAddress);

                                return completeAddress;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAddress();

    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
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
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.person_2_rounded,
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchProduct()));
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: ()
              {
                _auth.signOut().then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                });
                
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        title: Text('Home Screen',
        style: TextStyle(
          color: Colors.black54,
          fontFamily: 'Signatra',
          fontSize: 30,
        ),
        ),
        centerTitle: false,
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Items').orderBy('time', descending: true).snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.data!.docs.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return ListViewWidget(
                      docId: snapshot.data!.docs[index].id,
                      itemColor: snapshot.data!.docs[index]['itemColor'],
                      img1: snapshot.data!.docs[index]['urlImage1'],
                      img2: snapshot.data!.docs[index]['urlImage2'],
                      img3: snapshot.data!.docs[index]['urlImage3'],
                      img4: snapshot.data!.docs[index]['urlImage4'],
                      img5: snapshot.data!.docs[index]['urlImage5'],
                      userImg: snapshot.data!.docs[index]['imgPro'],
                      name: snapshot.data!.docs[index]['userName'],
                      date: snapshot.data!.docs[index]['time'].toDate(),
                      userId: snapshot.data!.docs[index]['id'],
                      itemModel: snapshot.data!.docs[index]['itemModel'],
                      postId: snapshot.data!.docs[index]['postId'],
                      itemPrice: snapshot.data!.docs[index]['itemPrice'],
                      description: snapshot.data!.docs[index]['description'],
                      lat: snapshot.data!.docs[index]['lat'],
                      lng: snapshot.data!.docs[index]['lng'],
                      address: snapshot.data!.docs[index]['address'],
                      userNumber: snapshot.data!.docs[index]['userNumber'],
                    );
                  },
                );
              }
              else
              {
                return Center(
                  child: Text('There is no data'),
                );
              }
            }
            return Center(
              child: Text(
                'Something Went Wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Post',
          child: Icon(
            Icons.cloud_upload,
            color: Colors.white54,
          ),
          backgroundColor: Colors.deepPurple,
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadAd()));           
          },
        ),
      ),
    );
  }
}