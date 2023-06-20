

import 'package:bloc/bloc.dart';
import 'package:find_my_car/screens/router_screen.dart';
import 'package:find_my_car/sheard/componant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../sheard/componant.dart';
import '../otp_screen.dart';

part 'phone_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {


  PhoneAuthCubit() : super(PhoneAuthInitial());


  static PhoneAuthCubit get(context) => BlocProvider.of(context);



  Future submitPhoneNumber(String phoneNumber) async {
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

   Future<void> submitOTP(String otpCode,String vid ) async {
     // verificationId = 'AK-jXHAlP9C0cqj7OSZgpt-9EOvE38bos3mrOWXeeD8eSzhgRu0Pf1-i5AZOpsxLZgIvs2jq-F_SgVoFYw5suQosk_FX3wCW4v3xNCeTKRU5pId9GXVkW4yRkouVh-RDWq4E8ueOrG3dCV_avaehHjqEZx56yrf2vDIijibqr1pFc8KHw9NIE-AjLV-a-s-AkXfG-14uuk29TI6lsalDk2l_8WWHuwLKZbrwd_8KO1jPjcmsCD-874E';
     print('$verificationId');
     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid, smsCode: otpCode);
     await signIn(credential);
   }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    print('verificationFailed : ${error.toString()}');
    emit(ErrorOccurred(errorMsg: error.toString()));
  }
   Future codeSent( String verifiId, int? resendToken) async{
    print('codeSent');
   verificationId = verifiId;
    print('$verificationId');
    emit(PhoneNumberSubmited());
  }
  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout  ${verificationId}');
  }



  Future<void> signIn(PhoneAuthCredential credential) async {

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
      // if (credential == null) {emit(ErrorOccurred( errorMsg: 'null'));}
    } catch (error) {
      emit(ErrorOccurred(errorMsg: error.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}