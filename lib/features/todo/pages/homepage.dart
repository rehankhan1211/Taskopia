import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskoopia/common/helpers/notifications_helper.dart';
import 'package:taskoopia/common/widgets/appstyle.dart';
import 'package:taskoopia/common/widgets/custom_text.dart';
import 'package:taskoopia/common/widgets/height_spacer.dart';
import 'package:taskoopia/common/widgets/reusable_text.dart';
import 'package:taskoopia/common/widgets/width_spacer.dart';
import 'package:taskoopia/common/widgets/xpansion_tile.dart';
import 'package:taskoopia/features/todo/controllers/todo/todo_provider.dart';
import 'package:taskoopia/features/todo/controllers/xpansion_provider.dart';
import 'package:taskoopia/features/todo/pages/add.dart';
import 'package:taskoopia/features/todo/widgets/completed_task.dart';
import 'package:taskoopia/features/todo/widgets/dayAfterTomo.dart';
import 'package:taskoopia/features/todo/widgets/todo_tile.dart';
import 'package:taskoopia/features/todo/widgets/tomorrow_list.dart';

import '../../../common/models/task_model.dart';
import '../../../common/utils/constants.dart';
import '../widgets/todayTask.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin{

  late final TabController tabController = TabController(
      length: 2, vsync: this);
  late NotificationsHelper notifierHelper;
  late NotificationsHelper controller;
  final TextEditingController search = TextEditingController();
  @override

  void initState() {
    notifierHelper = NotificationsHelper(ref: ref);
    Future.delayed(const Duration(seconds: 0), (){
      controller = NotificationsHelper(ref: ref);
    });
     notifierHelper.initializeNotification();
     //notifierHelper.requestIOSPermissions();
    super.initState();
  }

  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(text: "Dashboard", 
                        style: appstyle(18, AppConst.kLight, FontWeight.bold)),
                    Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: const BoxDecoration(
                        color: AppConst.kLight,
                        borderRadius: BorderRadius.all(Radius.circular(9))
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddTask()));
                        },
                        child: const Icon(Icons.add, color: AppConst.kBkDark,),
                      ),
                    )
                  ],
                ),
              ),
              const HeightSpacer(value: 20),
              CustomTextField(
                  hintText: "Search",
                  controller: search,
                prefixIcon: Container(
                  padding: EdgeInsets.all(14.h),
                  child: GestureDetector(
                    onTap: null,
                    child: const Icon(
                      AntDesign.search1,
                      color: AppConst.kGreyLight,),
                  ),
                ),
                suffixIcon: const Icon(
                  FontAwesome.sliders,
                color: AppConst.kGreyLight,),

              ),
              const HeightSpacer(value: 15),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(padding:
        EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              const HeightSpacer(value: 25),
              
              Row(
                children: [
                  const Icon(FontAwesome.tasks, size: 20, color: AppConst.kLight,),

                  const WidthSpacer(wydth: 10),

                  ReusableText(text: "Today's Task",
                      style: appstyle(18, AppConst.kLight, FontWeight.bold))
                ],
              ),

              const HeightSpacer(value: 25),
              Container(
                decoration: BoxDecoration(
                  color: AppConst.kLight,
                  borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius))
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    color: AppConst.kGreyLight,
                    borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius))
                  ),
                  controller: tabController,
                  labelPadding: EdgeInsets.zero,
                  isScrollable: false,
                  labelStyle: appstyle(24, AppConst.kBlueLight, FontWeight.w700),
                  unselectedLabelColor: AppConst.kLight,
                  tabs: [
                    Tab(
                      child: SizedBox(
                        width: AppConst.kWidth*0.5,
                          child: Center(
                            child: ReusableText(
                                text: "Pending",
                                style: appstyle(
                                    16, AppConst.kBkDark, FontWeight.bold)),
                          ),
                      ),
                    ),

                    Tab(
                      child: Container(
                        padding: EdgeInsets.only(left: 30.w),
                        width: AppConst.kWidth*0.5,
                        child: Center(
                          child: ReusableText(
                              text: "Completed",
                              style: appstyle(
                                  16, AppConst.kBkDark, FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),


              ),
              const HeightSpacer(value: 20),
              SizedBox(
                height: AppConst.kHeight*0.3,
                width: AppConst.kWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Container(
                        color: AppConst.kBkLight,
                        height: AppConst.kHeight*0.3,

                        child: const TodaysTask()
                      ),

                      Container(
                        color: AppConst.kBkLight,
                        height: AppConst.kHeight*0.3,
                        child: const CompletedTasks(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const HeightSpacer(value: 20),
             const TomorrowList(),
              const HeightSpacer(value: 20),
              const DayAfta(),
            ],
          ),
        ),
      ),
    );
  }
}

