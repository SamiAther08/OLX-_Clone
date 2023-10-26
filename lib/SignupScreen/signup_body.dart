import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice2/ForgetPassword/forget_password.dart';
import 'package:practice2/LoginScreen/login_screen.dart';
import 'package:practice2/SignupScreen/signup_background.dart';
import 'package:practice2/dialog_box/error_dialog.dart';
import 'package:practice2/home_screen/home.dart';
import 'package:practice2/widgets/already_have_an_account_check.dart';
import 'package:practice2/widgets/global_variable.dart';
import 'package:practice2/widgets/rounded_button.dart';
import 'package:practice2/widgets/rounded_input_field.dart';
import 'package:practice2/widgets/rounded_paassword_feild.dart';

class SignupBody extends StatefulWidget {
  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {

  String userPhotoUrl = '';

  File? _image;

  bool _isLoading = false;

  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    XFile? PickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(PickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(PickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void submitFormOnSignUp() async {
    final isValid = signupFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorAletDialog(
                message: 'Please choose an Image',
              );
            });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(), 
            password: _passwordController.text.trim(),
            );
            final User? user = _auth.currentUser;
            uid = user!.uid; 

            final ref = FirebaseStorage.instance.ref().child('UserImages').child(uid + '.jpg');
            await ref.putFile(_image!);
            userPhotoUrl = await ref.getDownloadURL();
            FirebaseFirestore.instance.collection('users').doc(uid).set(
              {
              'userName' : _nameController.text.trim(),
              'id': uid,
              'userNumber': _phoneController.text.trim(),
              'userEmail': _emailController.text.trim(),
              'userImage': userPhotoUrl,
              'time': DateTime.now(),
              'status': 'approved',
            }
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

      } catch (error) 
      {
        setState(() {
          _isLoading = false;
        });
        ErrorAletDialog(message: error.toString(),);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return SignupBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: signupFormKey,
              child: InkWell(
                onTap: () {
                  _showImageDialog();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.white24,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                          Icons.camera_enhance,
                          size: screenWidth * 0.18,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            RoundedInputFeild(
                hintText: 'Name',
                icon: Icons.person,
                onChanged: (value) {
                  _nameController.text = value;
                }),
            RoundedInputFeild(
                hintText: 'Email',
                icon: Icons.person_2,
                onChanged: (value) {
                  _emailController.text = value;
                }),
            RoundedInputFeild(
                hintText: 'Phone Number',
                icon: Icons.phone,
                onChanged: (value) {
                  _phoneController.text = value;
                }),
            RoundedPasswordFeild(onChanged: (value) {
              _passwordController.text = value;
            }),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                },
                child: Text(
                  'Forget Password',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : RoundedButton(
                    text: 'SignUp',
                    press: () {
                      submitFormOnSignUp();
                    },
                  ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            AlreadyHaveAccountCheck(
              login: false,
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
