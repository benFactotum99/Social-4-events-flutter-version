import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/components/custom_text_date_form.dart';
import 'package:social_4_events/components/custom_text_form.dart';
import 'package:social_4_events/components/custom_text_location.dart';
import 'package:social_4_events/components/custom_text_time_format.dart';
import 'package:social_4_events/components/show_my_dialog.dart';
import 'package:social_4_events/view/add/add_event_location_view.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  File? _image;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController numberPartTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Nuovo Evento",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 45, right: 45, bottom: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageEventSection(),
                    SizedBox(height: 20),
                    nameTextSection(),
                    SizedBox(height: 20),
                    descriptionTextSection(),
                    SizedBox(height: 20),
                    numberPartTextSection(),
                    SizedBox(height: 20),
                    priceTextSection(),
                    SizedBox(height: 20),
                    locationSection(),
                    SizedBox(height: 20),
                    startDateTextSection(),
                    SizedBox(height: 20),
                    startTimeTextSection(),
                    SizedBox(height: 20),
                    endDateTextSection(),
                    SizedBox(height: 20),
                    endTimeTextSection(),
                    SizedBox(height: 20),
                    saveButtonSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  imageEventSection() => InkWell(
        onTap: () async {
          try {
            var pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                if (pickedFile != null) {
                  _image = File(pickedFile.path) as File?;
                } else {
                  print('No image selected.');
                }
              });
            } else {
              print('No image selected.');
            }
          } on PlatformException catch (_) {
            var error = "Formato immagine non valido.";
            ShowMyDialog(context, "Errore", error);
            print(error);
          }
        },
        child: CircleAvatar(
          radius: 100.0,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: _image == null
              ? Transform.scale(
                  scale: 5,
                  child: Icon(Icons.event),
                )
              : ClipOval(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
        ),
      );

  nameTextSection() => CustomTextForm(
        myLabelText: 'Nome',
        textController: nameTextController,
        onValidator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Il nome è obbligatorio';
          }
          return null;
        },
        onChanged: (String? value) {},
      );

  descriptionTextSection() => CustomTextForm(
        myLabelText: 'Descrizione',
        textController: descriptionTextController,
        onValidator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'La descrizione è obbligatoria';
          }
          return null;
        },
        onChanged: (String? value) {},
        maxLines: 5,
      );

  numberPartTextSection() => CustomTextForm(
        myLabelText: 'Numero partecipanti',
        textController: numberPartTextController,
        onValidator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Il numero dei partecipanti è obbligatorio';
          }
          return null;
        },
        onChanged: (String? value) {},
      );

  priceTextSection() => CustomTextForm(
        myLabelText: 'Prezzo',
        textController: priceTextController,
        onValidator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Il prezzo è obbligatorio';
          }
          return null;
        },
        onChanged: (String? value) {},
      );

  locationSection() => CustomTextLocationForm(
        myLabelText: 'Località',
        textController: locationTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
        readOnly: true,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEventLocationView(
                onLocationsUpdated: (mapLocation) {
                  if (mapLocation != null) {
                    print(
                        "${mapLocation.name} ${mapLocation.latitude} ${mapLocation.longitude}");

                    setState(() {
                      locationTextController.text = mapLocation.name;
                    });
                  }
                },
              ),
            ),
          );
        },
      );

  startDateTextSection() => CustomTextDateForm(
        myLabelText: 'Inizio',
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        dateController: startDateTextController,
      );

  startTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora inizio',
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        timeController: startTimeTextController,
      );

  endDateTextSection() => CustomTextDateForm(
        myLabelText: 'Fine',
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        dateController: endDateTextController,
      );

  endTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora fine',
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        timeController: endTimeTextController,
      );

  saveButtonSection() => CustomButton(
        text: 'Salva',
        colorButton: Colors.red,
        colorText: Colors.white,
        heightButton: 50,
        widthButton: 500,
        isLoading: false,
        onPressed: () {
          if (formKey.currentState!.validate()) {}
        },
      );
}
