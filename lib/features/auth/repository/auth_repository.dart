import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskoopia/common/helpers/db_helper.dart';
import 'package:taskoopia/common/widgets/showDialogue.dart';
import '../../../common/routes/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

final authRepositoryProvider = Provider((ref){
  return AuthRepository(auth: FirebaseAuth.instance);
});



class AuthRepository {
  final FirebaseAuth auth;

  AuthRepository({required this.auth});

  void verifyOtp({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  })async {
    try{
      final credential = PhoneAuthProvider.credential(
        verificationId: smsCodeId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      if(!mounted){
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
   }/*on FirebaseAuth catch(e){
      showAlertDialog(context: context, message: e.toString());
    }*/
    catch(e) {
      showAlertDialog(
          context: context,
          message: "Verification Failed",
      );
    }

}

/*void showCustomToast(String message)
{
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}*/

  void sendOtp({
    required BuildContext context,
    required String phone,
}) async {
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async{
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e){
            showAlertDialog(context: context, message: e.toString());
          },
          codeSent: (smsCodeId, resendCodeId){
          DBHelper.createUser(1);
          Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.otp,
                  (route) => false,
            arguments: {
               'phone' : phone,
               'smsCodeId' : smsCodeId,
            }
          );
          },
          codeAutoRetrievalTimeout: (String smsCodeId){});
    } on FirebaseAuth catch(e){
      showAlertDialog(context: context, message: e.toString());
    }
  }
}