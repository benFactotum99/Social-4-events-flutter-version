import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/components/circle_image.dart';
import 'package:social_4_events/repository/user_repository.dart';
import 'package:social_4_events/view/home/home_view.dart';
import 'package:social_4_events/view/login/login_view.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;

  const App({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AuthenticationBlocEventAppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          splash: const CircleImage(
            imageUrl: 'assets/images/s4e_icon.jpg',
          ),
          nextScreen: const AuthChecker(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (context) => const LoginView(),
              );
            case '/home':
              return MaterialPageRoute(
                builder: (context) => HomeView(),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationBlocState>(
      builder: (context, state) {
        if (state is AuthenticationBlocStateAuthenticated) {
          return HomeView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
