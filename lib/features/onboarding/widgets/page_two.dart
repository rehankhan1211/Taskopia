import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskoopia/common/widgets/custom_otn_btn.dart';
import '../../../common/utils/constants.dart';
import '../../../common/widgets/height_spacer.dart';
import '../../auth/pages/login_page.dart';


class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConst.kHeight,
      width: AppConst.kWidth,
      color: AppConst.kBkDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Image.asset("assets/demo_2.png"),
          ),
          const HeightSpacer(value: 30),
          CustomOtlnBtn(
            onTap: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context)=>const LoginPage()));
            },
              width: AppConst.kWidth*0.9,
              height: AppConst.kHeight*0.06,
              color: AppConst.kLight,
              text: "Login with a phone number")
        ],
      ),
    );
  }
}