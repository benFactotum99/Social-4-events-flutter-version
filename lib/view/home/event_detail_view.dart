import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/components/custom_text_date_form.dart';
import 'package:social_4_events/components/custom_text_form.dart';
import 'package:social_4_events/components/custom_text_location.dart';
import 'package:social_4_events/components/custom_text_time_format.dart';
import 'package:social_4_events/components/show_my_dialog.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/view/home/event_detail_location_view.dart';
import 'package:social_4_events/view/main_view.dart';

class EventDetailView extends StatefulWidget {
  final Event event;
  const EventDetailView({required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController maxNumberPartTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();
  bool userLoggedParticipate = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      nameTextController.text = widget.event.name;
      descriptionTextController.text = widget.event.description;
      maxNumberPartTextController.text =
          widget.event.maxNumPartecipants.toString();
      priceTextController.text = widget.event.price.toString();
      locationTextController.text = widget.event.locationName;
      startDateTextController.text = widget.event.start;
      startTimeTextController.text = widget.event.timeStart;
      endDateTextController.text = widget.event.end;
      endTimeTextController.text = widget.event.timeEnd;
      userLoggedParticipate = widget.event.usersPartecipants
          .contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventBlocState>(
      listener: (context, state) {
        if (state is EventBlocStatePartecipationAdded ||
            state is EventBlocStatePartecipationRemoved) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainView(),
            ),
          );
        } else if (state is EventBlocStatePartecipationError) {
          ShowMyDialog(context, "Errore", state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Evento",
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
          ],
        ),
      ),
    );
  }

  imageEventSection() => InkWell(
        onTap: () {},
        child: CircleAvatar(
          radius: 100.0,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: Transform.scale(
            scale: 5,
            child: Icon(Icons.event),
          ),
        ),
      );

  nameTextSection() => CustomTextForm(
        myLabelText: 'Nome',
        textController: nameTextController,
        readOnly: true,
        enable: false,
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
        readOnly: true,
        enable: false,
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
        readOnly: true,
        enable: false,
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
        enable: false,
        textController: priceTextController,
        readOnly: true,
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
              builder: (context) => EventDetailLocationView(
                location: MapLocation(
                  name: widget.event.locationName,
                  latitude: widget.event.locationLatitude,
                  longitude: widget.event.locationLongitude,
                ),
              ),
            ),
          );
        },
      );

  startDateTextSection() => CustomTextDateForm(
        myLabelText: 'Inizio',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        dateController: startDateTextController,
      );

  startTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora inizio',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        timeController: startTimeTextController,
      );

  endDateTextSection() => CustomTextDateForm(
        myLabelText: 'Fine',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        dateController: endDateTextController,
      );

  endTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora fine',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {},
        timeController: endTimeTextController,
      );

  saveButtonSection() => BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          return CustomButton(
            text: !userLoggedParticipate ? 'Partecipa' : 'Non parecipare più',
            colorButton: Colors.red,
            colorText: Colors.white,
            heightButton: 50,
            widthButton: 500,
            isLoading: !userLoggedParticipate
                ? state is EventBlocStatePartecipationAdding
                : state is EventBlocStatePartecipationRemoving,
            onPressed: () {
              !userLoggedParticipate
                  ? BlocProvider.of<EventBloc>(context)
                      .add(EventBlocEventAddPartecipation(widget.event))
                  : BlocProvider.of<EventBloc>(context)
                      .add(EventBlocEventRemovePartecipation(widget.event));
            },
          );
        },
      );
}
