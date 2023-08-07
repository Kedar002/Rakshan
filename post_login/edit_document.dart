import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/document_manager_controller.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/user_document_list.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as dartPath;

class UserDocument {
  final int documentId;
  final int userDocumentId;
  final int clientId;
  final String documentTypeName;
  final String documentPath;
  final String documentName;
  final String name;

  UserDocument({
    required this.documentId,
    required this.documentTypeName,
    required this.userDocumentId,
    required this.clientId,
    required this.documentPath,
    required this.documentName,
    required this.name,
  });
}

enum Mode { create, edit }

class DocumentEditManager extends StatefulWidget {
  final UserDocument initialDocument;

  const DocumentEditManager({
    Key? key,
    required this.initialDocument,
  }) : super(key: key);

  @override
  State<DocumentEditManager> createState() => _DocumentManagerState();
}

class _DocumentManagerState extends State<DocumentEditManager> {
  final ImagePicker imagePicker = ImagePicker();
  final documentManager = DocumentMangerController();

  TextEditingController titleController = TextEditingController(text: "++RE");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? selectedDocumentType;
  bool isUploading = false;
  String selectedImageType = "file";
  // File? receivedImage;
  List documentTypes = [];

  String textFormValue = "";

  String initialImageUrl = "";
  File? changedImagePath;

  void setInitialValues() {
    setState(() {
      initialImageUrl = widget.initialDocument.documentPath;
      // receivedImage = File(widget.initialDocument.documentPath.toString());
    });
  }

  void handleDocumentTypeChange(value) {
    setState(() {
      selectedDocumentType = value;
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final pickedImage = await imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          changedImagePath = File(pickedImage.path);
        });
      }
    } catch (e) {}
  }

  void handleEditButtonClick() {}

  void updateUserDocument(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.get("userId");

    bool uploadStatus = false;
    if (changedImagePath != null) {
      Uint8List imageBytes = await changedImagePath!.readAsBytes();
      final documentData = {
        "DocumentId": widget.initialDocument.documentId,
        "DocumentTypeId":
            selectedDocumentType ?? widget.initialDocument.userDocumentId,
        "Name": titleController.text,
        "UserId": int.parse(userId as String), // from shared preferences
        "ClientId": 1, // from shared preferences
        "ImageBase64": base64.encode(imageBytes),
        "DocumentExtension": dartPath.extension(changedImagePath!.path), //
      };
      uploadStatus = await documentManager.updateUserDocument(documentData);
    } else {
      final documentData = {
        "DocumentId": widget.initialDocument.documentId,
        "DocumentTypeId":
            selectedDocumentType ?? widget.initialDocument.userDocumentId,
        "Name": titleController.text,
        "UserId": int.parse(userId as String), // from shared preferences
        "ClientId": 1, // from shared preferences
      };
      uploadStatus = await documentManager.updateUserDocument(documentData);
    }
    setState(() {
      isUploading = true;
    });
    if (uploadStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document Updated Successfully",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.blue,
        ),
      );
      setState(() {
        isUploading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document not uploaded...!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.blue,
        ),
      );

      setState(() {
        isUploading = false;
      });
    }
    Navigator.pop(context, true);
  }

  void fetchDocumentTypes() async {
    final fetchedDocumentTypes = await documentManager.getUserDocumentTypes();
    setState(() {
      documentTypes = fetchedDocumentTypes;
    });
  }

  @override
  void initState() {
    fetchDocumentTypes();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (titleController.text == "++RE") {
      titleController =
          TextEditingController(text: widget.initialDocument.name);
    } else {
      // if (titleController.text == "++RE") {
      //   titleController =
      //       TextEditingController(text: widget.initialDocument.name);
      // } else {
      //   titleController = TextEditingController(text: titleController.text);
      // }
    }
    return Scaffold(
      appBar: AppBarIndividual(
        title: 'Edit Document',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              isUploading
                  ? Column(
                      children: const [
                        LinearProgressIndicator(
                          minHeight: 3,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  : const SizedBox(
                      height: 13,
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200),
                      child: changedImagePath == null
                          ? Stack(
                              children: [
                                widget.initialDocument.documentPath == ""
                                    ? Image.asset(
                                        'assets/splash.png',
                                        // "assets/document-image.jpg",
                                        fit: BoxFit.contain,
                                        width: 350,
                                        height: 400,
                                      )
                                    : Image.network(
                                        '$kBaseUrl/${widget.initialDocument.documentPath}',
                                        fit: BoxFit.contain,
                                        width: 350,
                                        height: 400,
                                      ),
                              ],
                            )
                          : Image.file(
                              changedImagePath!,
                              fit: BoxFit.contain,
                              width: 350,
                              height: 400,
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyDropDown(
                          selectedDocumentType ??
                              widget.initialDocument.userDocumentId,
                          handleDocumentTypeChange,
                          documentTypes,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        validator: (value) {
                          if (titleController.text == "") {
                            return "Title cannot be empty";
                          }

                          // if ((titleController.text as String).length <= 1) {
                          //   return "Pls enter at least 3 letters";
                          // }
                        },
                        decoration: ktextfieldDecoration('Title'),
                        controller: titleController,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: DottedBorder(
                            color: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            strokeWidth: 1,
                            radius: const Radius.circular(5),
                            borderType: BorderType.RRect,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.86,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Select Image Source',
                                      ),
                                      actions: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: darkBlue,
                                                ),
                                                onPressed: () => pickImage(
                                                        ImageSource.camera)
                                                    .whenComplete(() => {
                                                          Navigator.pop(context)
                                                        }),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    const Text(
                                                      'Camera',
                                                    ), // <-- Text
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Icon(
                                                      // <-- Icon
                                                      Icons.camera_alt_outlined,
                                                      size: 24.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: darkBlue,
                                                ),
                                                onPressed: () {
                                                  pickImage(
                                                    ImageSource.gallery,
                                                  ).whenComplete(() => {
                                                        Navigator.pop(context),
                                                      });
                                                },
                                                child: Row(
                                                  children: const [
                                                    Text('Gallery'),
                                                    Icon(
                                                      Icons.image,
                                                      size: 24.0,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                      child: changedImagePath == null
                                          ? const Text(
                                              "Update The Image",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              textAlign: TextAlign.center,
                                            )
                                          : const Text(
                                              "CHANGE",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                    ),
                                    const Icon(
                                      Icons.add_box_outlined,
                                      size: 20.0,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 49,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          primary: darkBlue,
                        ),

                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateUserDocument(context);
                          }
                        },
                        child: const Text('Update'), // <-- Text
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDropDown extends StatelessWidget {
  final int? selectedDocumentType;
  final Function handleDocumentTypeChange;
  final List documentTypes;

  MyDropDown(
    this.selectedDocumentType,
    this.handleDocumentTypeChange,
    this.documentTypes,
  );

  final documentManagerController = DocumentMangerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade800,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: DropdownButton(
          isExpanded: true,
          hint: const Text(
            'Document Type',
            style: TextStyle(color: Colors.black),
          ),
          underline: const SizedBox(
            height: 0,
          ),
          value: selectedDocumentType,
          items: documentTypes.map((docType) {
            return DropdownMenuItem(
              value: docType["documentTypeId"],
              child: Text(docType["documentTypeName"]),
            );
          }).toList(),
          onChanged: (value) {
            handleDocumentTypeChange(value);
          }),
    );
  }
}

class Tile extends StatelessWidget {
  Tile({required this.title, required this.description});

  late final String title;
  late final String description;

  @override
  Widget build(BuildContext context) {
    return //temp(title: title, description: description);
        Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      width: MediaQuery.of(context).size.width * 0.94,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xffE5E5E5),
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        color: Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                  colors: [
                    Color(0xffA0CBFE),
                    Color(0xFF4E95E6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.4, 1])),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 15, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
