import 'package:find_my_car/screens/LOGIN/phone_cubit.dart';
import 'package:find_my_car/screens/router_screen.dart';
import 'package:find_my_car/sheard/componant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../otp_screen.dart';


// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _phoneFormKey = GlobalKey();

  late String phoneNumber;

  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your phone number?',
          style: TextStyle(
              color: Colors.blueGrey, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Please enter yout phone number to verify your account.',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              generateCountryFlag() + ' +20',
              style: TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              decoration: InputDecoration(border: InputBorder.none),
              cursorColor: Colors.blueGrey,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter yout phone number!';
                } else if (value.length < 11) {
                  return 'Too short for a phone number!';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = 'eg';

    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
            (match) =>
            String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

    return flag;
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return ;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
     //BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
     PhoneAuthCubit.get(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);

          _register(context);
        },
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(110, 50),
          primary: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(

      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  Widget _buildPhoneNumberSubmitedBloc() {

    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          //Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
          navigateAndFinish(context,OtpScreen(phoneNumber: phoneNumber,));
        }
        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.blueGrey,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },

      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (BuildContext context) => PhoneAuthCubit(),
        child: BlocConsumer<PhoneAuthCubit,PhoneAuthState>(
          listener: (BuildContext context, PhoneAuthState state) {
    if (state is Loading) {
    showProgressIndicator(context);
    }
    if (state is PhoneNumberSubmited) {
    Navigator.pop(context);
    //Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
    navigateAndFinish(context,OtpScreen(phoneNumber: phoneNumber,));
    }
    if (state is ErrorOccurred) {
    Navigator.pop(context);
    String errorMsg = (state).errorMsg;
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(errorMsg),
    backgroundColor: Colors.blueGrey,
    duration: Duration(seconds: 3),
    ),
    );
    }
    },


          builder: (BuildContext context,PhoneAuthState State) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Form(
                  key: _phoneFormKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIntroTexts(),
                        SizedBox(
                          height: 110,
                        ),
                        _buildPhoneFormField(),
                        SizedBox(
                          height: 70,
                        ),
                        _buildNextButton(context),
                        _buildPhoneNumberSubmitedBloc(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },


        ),
      ),
    );
  }
}