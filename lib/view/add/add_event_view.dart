import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/components/custom_text_date_form.dart';
import 'package:social_4_events/components/custom_text_form.dart';
import 'package:social_4_events/components/custom_text_time_format.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
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
              padding: const EdgeInsets.only(
                  top: 30, left: 45, right: 45, bottom: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageEventSection(),
                    const SizedBox(height: 20),
                    nameTextSection(),
                    const SizedBox(height: 20),
                    descriptionTextSection(),
                    const SizedBox(height: 20),
                    numberPartTextSection(),
                    const SizedBox(height: 20),
                    priceTextSection(),
                    const SizedBox(height: 20),
                    locationSection(),
                    const SizedBox(height: 20),
                    startDateTextSection(),
                    const SizedBox(height: 20),
                    startTimeTextSection(),
                    const SizedBox(height: 20),
                    endDateTextSection(),
                    const SizedBox(height: 20),
                    endTimeTextSection(),
                    const SizedBox(height: 20),
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

  imageEventSection() => CircleAvatar(
        //backgroundImage: AssetImage('assets/images/avatar.png'),
        radius: 100.0,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        child: Transform.scale(
          scale: 5, // Aumenta la scala dell'icona di 1.5 volte
          child: Icon(Icons.event),
        ),
      );

  nameTextSection() => CustomTextForm(
        myLabelText: 'Nome',
        textController: nameTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
      );

  descriptionTextSection() => CustomTextForm(
        myLabelText: 'Descrizione',
        textController: descriptionTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
        maxLines: 5,
      );

  numberPartTextSection() => CustomTextForm(
        myLabelText: 'Numero partecipanti',
        textController: numberPartTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
      );

  priceTextSection() => CustomTextForm(
        myLabelText: 'Prezzo',
        textController: priceTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
      );

  locationSection() => CustomTextForm(
        myLabelText: 'Località',
        textController: locationTextController,
        onValidator: (String? value) {},
        onChanged: (String? value) {},
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
