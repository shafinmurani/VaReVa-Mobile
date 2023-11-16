import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/components/successful.dart';
import 'package:vartarevarta_magazine/components/text_input_widget.dart';

class CompetitionWidget extends StatefulWidget {
  const CompetitionWidget({super.key});

  @override
  State<CompetitionWidget> createState() => _CompetitionWidgetState();
}

class _CompetitionWidgetState extends State<CompetitionWidget> {
  TextEditingController nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName);

  TextEditingController emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);

  TextEditingController addressController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String numController = "";

  FilePickerResult? pickedFile;
  bool isPickedFile = false;
  bool isLoading = false;
  String fileUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: const Text("Competition"),
      ),
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(
                          "${FirebaseAuth.instance.currentUser?.photoURL}",
                        )),
                    const Gap(20),
                    Input(
                      placeholder: "Full Name",
                      controller: nameController,
                      keyboardType: TextInputType.name,
                    ),
                    Input(
                      placeholder: "Email Address",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Input(
                      placeholder: "Address",
                      controller: addressController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 6,
                    ),
                    IntlPhoneField(
                      onChanged: (phone) {
                        numController = phone.completeNumber;
                      },
                      initialCountryCode: 'IN',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Input(
                      placeholder: "Title of the story",
                      controller: titleController,
                      keyboardType: TextInputType.text,
                    ),
                    const Gap(20),
                    isPickedFile
                        ? Center(
                            child: Text(
                              "File Name : ${pickedFile?.files.first.name}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Select File...",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            pickedFile = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            setState(() {
                              isPickedFile = true;
                            });
                          },
                          child: const Icon(Icons.file_copy),
                        ),
                      ],
                    ),
                    const Gap(20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[400]),
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (!isPickedFile ||
                                  addressController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  titleController.text.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select all the inputs...",
                                    ),
                                  ),
                                );
                                return;
                              }

                              Reference referenceMagazineRoot = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child("competition");
                              var uniqname =
                                  "${DateTime.now().millisecondsSinceEpoch}.pdf";
                              Reference referenceFileToUpload =
                                  referenceMagazineRoot.child(uniqname);
                              //Image

                              try {
                                //file
                                await referenceFileToUpload.putFile(
                                    File("${pickedFile!.files.first.path}"));
                                fileUrl = await referenceFileToUpload
                                    .getDownloadURL();

                                //firestore
                                CollectionReference collectionRef =
                                    FirebaseFirestore.instance
                                        .collection("competition");
                                Map<String, dynamic> dataToSend = {
                                  'title': titleController.text,
                                  'name': nameController.text,
                                  'uid': FirebaseAuth.instance.currentUser?.uid,
                                  'pdf': fileUrl,
                                  'email': emailController.text,
                                  'address': addressController.text,
                                  'phone': numController,
                                  'status': "Under Review"
                                };
                                collectionRef.add(dataToSend);
                                setState(() {
                                  isLoading = false;
                                });

                                pickedFile = null;
                                isPickedFile = false;

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SuccessFulWidget(),
                                    ));
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Some error occured...")));
                              }
                            },
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: secondary,
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
