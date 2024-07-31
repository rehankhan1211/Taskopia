import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskoopia/common/widgets/appstyle.dart';
import 'package:taskoopia/common/widgets/height_spacer.dart';
import 'package:taskoopia/common/widgets/reusable_text.dart';
import '../../../common/utils/constants.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

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
          Padding(padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Image.asset("assets/demo_1.png"),
          ),
          const HeightSpacer(value: 100),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ReusableText(text: "Taskopia",
                  style: appstyle(30, AppConst.kLight, FontWeight.w600)),

              const HeightSpacer(value: 10),

              Padding(padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text("Welcome!! Do You want to create a task fast and with ease",
                textAlign: TextAlign.center,
                style: appstyle(16, AppConst.kGreyLight, FontWeight.normal),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
