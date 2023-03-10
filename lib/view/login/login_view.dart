import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/components/show_my_dialog.dart';
import 'package:social_4_events/view/home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationBlocState>(
      listener: (context, state) {
        if (state is AuthenticationBlocStateSuccessAuth) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );
        } else if (state is AuthenticationBlocStateErrorAuth) {
          ShowMyDialog(context, "Errore", state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Social4Events"),
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 40),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  emalTextFormSection(),
                  const SizedBox(height: 20),
                  passwordTextFormSection(),
                  const SizedBox(height: 20),
                  buttonLoginSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emalTextFormSection() => TextFormField(
        controller: emailTextController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'L\'email è obbligatoria';
          } else if (!EmailValidator.validate(value)) {
            return 'Inserire un\'email valida';
          }
          return null;
        },
        cursorColor: Colors.red,
        decoration: const InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Icon(Icons.account_circle, size: 30),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
        ),
        onChanged: (text) {},
      );

  Widget passwordTextFormSection() => TextFormField(
        controller: passwordTextController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'La password è obbligatoria';
          }
          return null;
        },
        cursorColor: Colors.red,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Icon(Icons.key, size: 30),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
        ),
        onChanged: (text) {},
      );

  Widget buttonLoginSection() =>
      BlocBuilder<AuthenticationBloc, AuthenticationBlocState>(
          builder: (context, state) {
        return CustomButton(
          text: 'Accedi',
          colorButton: Colors.red,
          colorText: Colors.white,
          heightButton: 50,
          widthButton: 500,
          isLoading: state is AuthenticationBlocStateLoadingAuth,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationBlocEventLogin(
                  emailTextController.text,
                  passwordTextController.text,
                ),
              );
            }
          },
        );
      });
}