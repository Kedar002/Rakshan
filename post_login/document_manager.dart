import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Rakshan/constants/COLORS.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/document_manager_controller.dart';
import 'package:Rakshan/screens/post_login/document_detail.dart';
import 'package:Rakshan/screens/post_login/user_document_list.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:path/path.dart' as dartPath;

class DocumentManager extends StatefulWidget {
  DocumentManager();

  @override
  State<DocumentManager> createState() => _DocumentManagerState();
}

class _DocumentManagerState extends State<DocumentManager> {
  final ImagePicker imagePicker = ImagePicker();
  final documentManager = DocumentMangerController();
  final titleController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? selectedDocumentType = null;

  bool isUploading = false;
  bool isLoading = false;
  File? selectedImage;
  String selectedImageType = "file";
  List documentTypes = [];

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
          selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {}
  }

  void handleEditButtonClick() {}

  void createNewUserDocument(context) async {
    // Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    // String base64string = base64.encode(imagebytes); //convert bytes to base64 string

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.get("userId");
    final clientId = sharedPreferences.get("clientId");

    if (selectedDocumentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pls select the document type"),
          duration: Duration(milliseconds: 3000),
        ),
      );
      return;
    }

    Uint8List imageBytes = await selectedImage!.readAsBytes();
    final documentData = {
      "DocumentId": 0,
      "DocumentTypeId": selectedDocumentType,
      "Name": titleController.text,
      "UserId": int.parse(userId as String), // from shared preferences
      "ClientId": int.parse(clientId as String), // from shared preferences
      "ImageBase64": base64.encode(imageBytes),
      "DocumentExtension": dartPath.extension(selectedImage!.path), //
    };

    setState(() {
      isUploading = true;
    });

    final uploadStatus = await documentManager.createNewDocument(documentData);

    if (uploadStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document Uploaded Successfully",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          duration: Duration(milliseconds: 3000),
        ),
      );
      setState(() {
        isUploading = false;
        selectedImage = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Document not uploaded...!",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isUploading = false;
      });
    }
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
    return Scaffold(
      //
      appBar: AppBarIndividual(
        title: 'Document Manager',
      ),
      body: ModalProgressHUD(
        inAsyncCall: isUploading,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyDropDown(
                            selectedDocumentType,
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

                            if (titleController.text.length <= 1) {
                              return "Please Enter Document Name";
                            }
                          },
                          decoration: ktextfieldDecoration('Title'),
                          controller: titleController,
                          onChanged: (value) {
                            // print(titleController.text);
                          },
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.84,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Where to get your documents'),
                                              actions: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: darkBlue,
                                                        ),
                                                        onPressed: () =>
                                                            pickImage(
                                                                    ImageSource
                                                                        .camera)
                                                                .whenComplete(
                                                                    () => {
                                                                          Navigator.pop(
                                                                              context)
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
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 24.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: darkBlue,
                                                        ),
                                                        onPressed: () {
                                                          pickImage(
                                                            ImageSource.gallery,
                                                          ).whenComplete(() => {
                                                                Navigator.pop(
                                                                    context),
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
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 0,
                                              ),
                                              child: selectedImage == null
                                                  ? const Text(
                                                      "UPLOAD",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    )
                                                  : const Text(
                                                      "CHANGE",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
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
                                  ],
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: selectedImage == null
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedImage != null
                              ? Colors.grey.shade200
                              : Colors.white,
                        ),
                        child: selectedImage == null
                            ? const SizedBox(
                                height: 0,
                              )
                            : Image.file(
                                selectedImage!,
                                fit: BoxFit.contain,
                                width: 350,
                                height: 300,
                              ),
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

                          onPressed: selectedImage == null
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    createNewUserDocument(context);
                                  }
                                },
                          child: const Text('SAVE'), // <-- Text
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                SizedBox(
                  height: 49,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 0.0,
                      primary: darkBlue,
                    ),
                    onPressed: isUploading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDocumentsList(),
                              ),
                            );
                          },
                    child: const Text("View My Documents"),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class Dropdown_Button extends StatefulWidget {
//   final String selectedDocumentType;
//   final Function handleDocumentTypeChange;

//   const Dropdown_Button(this.selectedDocumentType, this.handleDocumentTypeChange);
//   @override
//   State<Dropdown_Button> createState() => _Dropdown_ButtonState();
// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {}
// }

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

class Dropdown_Button extends StatelessWidget {
  final int selectedDocumentType;
  final Function handleDocumentTypeChange;
  final List documentTypes;

  Dropdown_Button(
    this.selectedDocumentType,
    this.handleDocumentTypeChange,
    this.documentTypes,
  );

  final documentManagerController = DocumentMangerController();

  @override
  Widget build(BuildContext context) {
    final myDpBtn = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade800,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: documentTypes.isEmpty
          ? const SizedBox(
              height: 36,
            )
          : DropdownButton(
              items: documentTypes.map((documentTypeMap) {
                final value = documentTypeMap["documentTypeId"];
                return DropdownMenuItem<String>(
                  value: '$documentTypeMap["documentTypeId"]',
                  child: Text(
                    documentTypeMap["documentTypeName"],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              }).toList(),
              isExpanded: true,
              hint: const Text(
                'Document Type',
                style: TextStyle(color: Colors.black),
              ),
              underline: const SizedBox(),
              value: selectedDocumentType,
              onChanged: (value) {
                // handleDocumentTypeChange(value);
              },
            ),
    );

    return myDpBtn;
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
                    SizedBox(
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
