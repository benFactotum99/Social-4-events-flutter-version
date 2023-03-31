import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_4_events/bloc/event/event_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/components/custom_show_my_dialog.dart';
import 'package:social_4_events/components/custom_text_date_form.dart';
import 'package:social_4_events/components/custom_text_form.dart';
import 'package:social_4_events/components/custom_text_location.dart';
import 'package:social_4_events/components/custom_text_time_format.dart';
import 'package:social_4_events/components/show_my_dialog.dart';
import 'package:social_4_events/helpers/generic_functions_helpers/generic_functions.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/add_event_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/view/add/add_event_location_view.dart';
import 'package:social_4_events/view/main_view.dart';
import 'package:path/path.dart' as p;

class AddEventView extends StatefulWidget {
  static String route = '/add_event_view';
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  File? _image = null;
  late MapLocation? mapLocation;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController maxNumberPartTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventBlocState>(
      listener: (context, state) {
        if (state is EventBlocStateCreated) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainView(),
            ),
          );
        } else if (state is EventBlocStateError) {
          print(state.errorMessage);
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainView(),
            ),
          );
        } else if (state is EventBlocStateImageError) {
          //ShowMyDialog();
          CustomShowMyDialog(context, "Errore",
              "L'evento è stato creato con successo, ma il caricamento dell'immagine non è andato a buon fine, se l'errore persiste contattare gli sviluppatori.",
              () {
            Navigator.of(context).pop();
            Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MainView(),
              ),
            );
            //TODO: sarebbe meglio usare la rotta anche in questo caso ma non funziona per il momento
            //Navigator.of(context, rootNavigator: true)
            //  .pushReplacementNamed(MainView.route);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.red),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Nuovo Evento",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 45, right: 45, bottom: 30),
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
                  //final extension = p.extension(_image!.path);
                  /*if (extension != ".jpg") {
                    _image = null;
                    throw PlatformException(code: '400');
                  }*/
                } else {
                  print('No image selected.');
                }
              });
            } else {
              print('No image selected.');
            }
          } on PlatformException catch (_) {
            var error =
                "Formato immagine non valido. Si prega di inserire solo immagini in formato jpg";
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
                  child: Icon(Icons.event, color: Colors.white),
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
        myLabelText: 'Max num di partecipanti',
        textController: maxNumberPartTextController,
        onValidator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Il numero dei partecipanti è obbligatorio';
          }
          if (!isNumeric(value)) {
            return 'Formato errato';
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
          if (!isNumeric(value)) {
            return 'Formato errato';
          }
          return null;
        },
        onChanged: (String? value) {},
      );

  locationSection() => CustomTextLocationForm(
        myLabelText: 'Località',
        textController: locationTextController,
        onValidator: (String? value) {
          return null;
        },
        onChanged: (String? value) {},
        readOnly: true,
        onTap: () {
          Navigator.of(context).pushNamed(
            AddEventLocationView.route,
            arguments: AddEventLocationViewArguments(
              (mapLocation) {
                if (mapLocation != null) {
                  print(
                      "${mapLocation.name} ${mapLocation.latitude} ${mapLocation.longitude}");
                  setState(() {
                    locationTextController.text = mapLocation.name;
                    this.mapLocation = MapLocation(
                      name: mapLocation.name,
                      latitude: mapLocation.latitude,
                      longitude: mapLocation.longitude,
                    );
                  });
                }
              },
            ),
          );
        },
      );

  startDateTextSection() => CustomTextDateForm(
        myLabelText: 'Inizio',
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        dateController: startDateTextController,
      );

  startTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora inizio',
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        timeController: startTimeTextController,
      );

  endDateTextSection() => CustomTextDateForm(
        myLabelText: 'Fine',
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        dateController: endDateTextController,
      );

  endTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora fine',
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        timeController: endTimeTextController,
      );

  saveButtonSection() => BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          return CustomButton(
            text: 'Salva',
            colorButton: Colors.red,
            colorText: Colors.white,
            heightButton: 50,
            widthButton: 500,
            isLoading: state is EventBlocStateCreating,
            onPressed: () {
              if (_image == null) {
                ShowMyDialog(context, "Errore", "L'immagine è obbligatoria.");
                return;
              }

              if (locationTextController.text.isEmpty) {
                ShowMyDialog(context, "Errore", "Location mancante.");
                return;
              }

              if (startDateTextController.text.isEmpty) {
                ShowMyDialog(context, "Errore", "Data di inizio mancante.");
                return;
              }

              if (startTimeTextController.text.isEmpty) {
                ShowMyDialog(context, "Errore", "Ora di inizio mancante.");
                return;
              }

              if (endDateTextController.text.isEmpty) {
                ShowMyDialog(context, "Errore", "Data di fine mancante.");
                return;
              }

              if (endTimeTextController.text.isEmpty) {
                ShowMyDialog(context, "Errore", "Ora di fine mancante.");
                return;
              }

              String dateStartStr =
                  "${startDateTextController.text} ${startTimeTextController.text}";
              String dateEndStr =
                  "${endDateTextController.text} ${endTimeTextController.text}";

              if (!compareDate(dateStartStr, dateEndStr)) {
                ShowMyDialog(context, "Errore",
                    "Non si possono creare eventi che iniziano prima che finiscano o avere stessa data e ora di inizio e fine.");
                return;
              }

              if (formKey.currentState!.validate()) {
                var event = Event(
                  name: nameTextController.text,
                  description: descriptionTextController.text,
                  locationLatitude: mapLocation!.latitude,
                  locationLongitude: mapLocation!.longitude,
                  locationName: mapLocation!.name,
                  maxNumPartecipants:
                      int.parse(maxNumberPartTextController.text),
                  price: double.parse(priceTextController.text),
                  start: startDateTextController.text,
                  timeStart: startTimeTextController.text,
                  end: endDateTextController.text,
                  timeEnd: endTimeTextController.text,
                  userCreator: FirebaseAuth.instance.currentUser!.uid,
                );

                BlocProvider.of<EventBloc>(context).add(
                  EventBlocEventCreate(_image!, event),
                );
              }
            },
          );
        },
      );
}
