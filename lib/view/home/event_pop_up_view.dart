import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';

//Pop up che mostra un breve escurso sui dati dell'evento
class EventPopUpView extends StatefulWidget {
  final Event event;
  final Function()? onPressed;
  const EventPopUpView({required this.event, required this.onPressed});

  @override
  State<EventPopUpView> createState() => _EventPopUpViewState();
}

class _EventPopUpViewState extends State<EventPopUpView> {
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nomeController.text = widget.event.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        //width: MediaQuery.of(context).size.width - 900,
        //height: MediaQuery.of(context).size.height - 850,
        width: 100,
        height: 295,
        child: Column(
          children: [
            CircleAvatar(
              radius: 70.0,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: widget.event.imageUrl.isEmpty
                  ? Transform.scale(
                      scale: 4,
                      child: Icon(Icons.event),
                    )
                  : Transform.scale(
                      scale: 1,
                      child: ClipOval(
                        child: Image.network(
                          widget.event.imageUrl,
                          fit: BoxFit.cover,
                          width: 220,
                          height: 220,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            Text("Name: ${widget.event.name}"),
            SizedBox(height: 10),
            Text("Partecipants: ${widget.event.usersPartecipants.length}"),
            SizedBox(height: 10),
            Text("Price: ${widget.event.price} €"),
            SizedBox(height: 20),
            SizedBox(
              height: 35,
              width: 300,
              child: ElevatedButton(
                onPressed: widget.onPressed,
                child: Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
