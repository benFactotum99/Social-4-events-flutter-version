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
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_users_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';
import 'package:social_4_events/view/home/event_detail_location_view.dart';
import 'package:social_4_events/view/home/event_users_view.dart';
import 'package:social_4_events/view/main_view.dart';

class EventDetailView extends StatefulWidget {
  static String route = '/event_detail_view';
  final EventDetailViewArguments eventDetailViewArguments;
  const EventDetailView({required this.eventDetailViewArguments});

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
  bool userPartecipationsClose = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      nameTextController.text = widget.eventDetailViewArguments.event.name;
      descriptionTextController.text =
          widget.eventDetailViewArguments.event.description;
      maxNumberPartTextController.text =
          widget.eventDetailViewArguments.event.maxNumPartecipants.toString();
      priceTextController.text =
          widget.eventDetailViewArguments.event.price.toString();
      locationTextController.text =
          widget.eventDetailViewArguments.event.locationName;
      startDateTextController.text =
          widget.eventDetailViewArguments.event.start;
      startTimeTextController.text =
          widget.eventDetailViewArguments.event.timeStart;
      endDateTextController.text = widget.eventDetailViewArguments.event.end;
      endTimeTextController.text =
          widget.eventDetailViewArguments.event.timeEnd;
      userLoggedParticipate = widget
          .eventDetailViewArguments.event.usersPartecipants
          .contains(FirebaseAuth.instance.currentUser!.uid);

      userPartecipationsClose =
          widget.eventDetailViewArguments.event.maxNumPartecipants ==
              widget.eventDetailViewArguments.event.usersPartecipants.length;
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
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.red),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Evento",
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
                    SizedBox(height: 25),
                    partecipantsListButtonSection(),
                    SizedBox(height: 25),
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
          child: widget.eventDetailViewArguments.event.imageUrl.isEmpty
              ? Transform.scale(
                  scale: 5,
                  child: Icon(Icons.event),
                )
              : Transform.scale(
                  scale: 1,
                  child: ClipOval(
                    child: Image.network(
                      widget.eventDetailViewArguments.event.imageUrl,
                      fit: BoxFit.cover,
                      width: 220,
                      height: 220,
                    ),
                  ),
                ),
        ),
      );

  nameTextSection() => CustomTextForm(
        myLabelText: 'Nome',
        textController: nameTextController,
        readOnly: true,
        enable: false,
        onValidator: (String? value) {
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
            EventDetailLocationView.route,
            arguments: EventDetialLocationViewArguments(
              MapLocation(
                name: widget.eventDetailViewArguments.event.locationName,
                latitude:
                    widget.eventDetailViewArguments.event.locationLatitude,
                longitude:
                    widget.eventDetailViewArguments.event.locationLongitude,
              ),
            ),
          );
        },
      );

  startDateTextSection() => CustomTextDateForm(
        myLabelText: 'Inizio',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        dateController: startDateTextController,
      );

  startTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora inizio',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        timeController: startTimeTextController,
      );

  endDateTextSection() => CustomTextDateForm(
        myLabelText: 'Fine',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        dateController: endDateTextController,
      );

  endTimeTextSection() => CustomTextTimeForm(
        myLabelText: 'Ora fine',
        disableTap: true,
        onChanged: (String? value) {},
        onValidator: (String? value) {
          return null;
        },
        timeController: endTimeTextController,
      );

  saveButtonSection() => BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          return CustomButton(
            text: !userLoggedParticipate
                ? userPartecipationsClose
                    ? 'Partecipazioni chiuse'
                    : 'Partecipa'
                : 'Non parecipare più',
            colorButton: Colors.red,
            colorText: Colors.white,
            heightButton: 50,
            widthButton: 500,
            isLoading: !userLoggedParticipate
                ? state is EventBlocStatePartecipationAdding
                : state is EventBlocStatePartecipationRemoving,
            onPressed: () {
              if (!userLoggedParticipate) {
                if (!userPartecipationsClose) {
                  BlocProvider.of<EventBloc>(context).add(
                      EventBlocEventAddPartecipation(
                          widget.eventDetailViewArguments.event));
                }
              } else {
                BlocProvider.of<EventBloc>(context).add(
                    EventBlocEventRemovePartecipation(
                        widget.eventDetailViewArguments.event));
              }
            },
          );
        },
      );

  partecipantsListButtonSection() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SizedBox(
          height: 50,
          width: 500,
          child: CustomButton(
            text: 'Partecipanti',
            colorButton: Colors.red,
            colorText: Colors.white,
            heightButton: 50,
            widthButton: 500,
            isLoading: false,
            onPressed: () {
              Navigator.of(context).pushNamed(EventUsersView.route,
                  arguments: EventUsersViewArguments(
                      widget.eventDetailViewArguments.event));
            },
          ),
        ),
      );
}
