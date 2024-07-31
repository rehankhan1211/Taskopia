import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:taskoopia/common/widgets/appstyle.dart';
import 'package:taskoopia/common/widgets/height_spacer.dart';

import '../../../common/utils/constants.dart';
import '../../../common/widgets/custom_otn_btn.dart';
import '../../../common/widgets/reusable_text.dart';
import '../../todo/pages/homepage.dart';
import '../controllers/auth_controller.dart';

class OtpPage extends ConsumerWidget {
  const OtpPage({Key? key, required this.smsCodeId, required this.phone}) : super(key: key);

  final String smsCodeId;
  final String phone;

  void verifyOtpCode(
      BuildContext context, WidgetRef ref, String smsCode
      ){
    ref.read(authControllerProvider).verifyOtpCode(
        context: context,
        smsCodeId: smsCodeId,
        smsCode: smsCode,
        mounted: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeightSpacer(value: AppConst.kHeight*0.12),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Image.asset("assets/demo_2.png",
                  width: AppConst.kWidth*0.5,),),

                const HeightSpacer(value: 11),

                ReusableText(
                    text: "Enter Your OTP code",
                    style: appstyle(18, AppConst.kLight, FontWeight.bold)),

                const HeightSpacer(value: 19),
                Pinput(
                  length: 6,
                  showCursor: true,
                    onCompleted: (value){
                    if(value.length == 6){
                      return verifyOtpCode(context, ref, value);
                    }
                    },
                    onSubmitted: (value){
                      if(value.length == 6){
                        return verifyOtpCode(context, ref, value);
                      }
                    },
                )
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomOtlnBtn(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  width: AppConst.kWidth*0.9,
                  height: AppConst.kHeight*0.075,
                  color: AppConst.kBlueLight,
                  text: "Submit"),
            )
      ]
        ),
      ),
    );
  }
}
