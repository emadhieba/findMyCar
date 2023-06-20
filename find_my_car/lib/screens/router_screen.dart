import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'LOGIN/loginScreen.dart';
import 'LOGIN/phone_cubit.dart';
import 'maps/mapsScreen.dart';
import 'onboarding/onBoarding.dart';
import 'otp_screen.dart';


const loginScreen = '/loginScreen';
const otpScreen = '/otp-screen';
const mapScreen = '/mapsScreen';
const onBoarding = '/onBoarding';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => MapsScreen(),
        );
      case onBoarding:
        return MaterialPageRoute(
          builder: (_) => OnBoarding(),
        );

      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );

      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber),
          ),
        );
      // case loginScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider<PhoneAuthCubit>(
      //       create: (context) => phoneAuthCubit!,
      //       child: LoginScreen(),
      //     ),
      //   );
      //   // return Provider<Example>(
      //   //     create: (_) => Example(),
      //   //     // we use `builder` to obtain a new `BuildContext` that has access to the provider
      //   //     builder: (context, child) {
      //   //       // No longer throws
      //   //       return Text(context.watch<Example>().toString());
      //   //     }
      //   // );
      // case otpScreen:
      //   final phoneNumber = settings.arguments;
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider<PhoneAuthCubit>(
      //       create: (context) => phoneAuthCubit!,
      //       child: OtpScreen(phoneNumber: phoneNumber),
      //     ),
      //   );
    }
  }
}