import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/faq.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  final spacer = const SizedBox(height: 30);

  bool loading = true;
  List<Faq> faqs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchFAQ();
    });
    super.initState();
  }

  Future<void> fetchFAQ() async {
    faqs = await GenericHelper.getFaqs().catchError((err) {

      showCustomToast(context: context, description: err.toString());
    });
    loading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'FAQs'),
      body: SafeArea(
        bottom: false,
        child: loading
            ? 
            Center(child: CircularProgressIndicator())
            
            // buildLoading()
            : ListView.builder(
              shrinkWrap: true,
              padding:
                   EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
              itemCount: faqs.length,
              itemBuilder: (context, indexx) {
                return Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   if(faqs[indexx].data.isNotEmpty) Text(faqs[indexx].name, style: get16TextStyle().copyWith(fontWeight: FontWeight.w500, color: ColorManager.kGreyColor),),
                   faqs[indexx].data.isNotEmpty? ListView.separated(
                    
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                      final faq = faqs[indexx].data[index];
                      return FAQsWidget(question: faq.question, answer: faq.answer);
                    }, separatorBuilder: (context, index)=> Gap(10), itemCount: faqs[indexx].data.length): SizedBox()
                  ],
                );
              },
            ),
      ),
    );
  }



}



class FAQsWidget extends StatefulWidget {
  const FAQsWidget({super.key, required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  State<FAQsWidget> createState() => _FAQsWidgetState();
}

class _FAQsWidgetState extends State<FAQsWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: ColorManager.kWhite,
          border: Border.all(color: isExpanded? ColorManager.kGreyColor.withValues(alpha: .09): ColorManager.kGreyE5)),
      child: ExpansionTile(
        enableFeedback: false,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        shape: Border.all(color: Colors.transparent),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        collapsedIconColor: ColorManager.kGreyColor.withValues(alpha: .7),
        iconColor: ColorManager.kGreyColor.withValues(alpha: 2),
        childrenPadding: EdgeInsets.only(left: 15.w, right: 10.w, bottom: 20.h),
        trailing: isExpanded? RotatedBox(
          quarterTurns: 1,
          child: Icon( Icons.arrow_back_ios)) : RotatedBox(
          quarterTurns: -1,
          child: Icon( Icons.arrow_back_ios, color: ColorManager.kGreyColor.withValues(alpha: 02),)),
        title: Text(
           widget.question,
        ),
        children: [
          Text(
             widget.answer,
          )
        ],
      ),
    );
  }
}

/*
class FAQsWidget extends StatelessWidget {
  const FAQsWidget({super.key, required this.question, required this.answer});
  final String question;
  final String answer;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.kWhite,
          border: Border.all(color: AppColors.kGreyD0)),
      child: ExpansionTile(
        enableFeedback: false,
        onExpansionChanged: (value) {
          print(value);
        },
        shape: Border.all(color: Colors.transparent),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        collapsedIconColor: AppColors.kGrey7F,
        iconColor: AppColors.kGrey7F,
        childrenPadding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
        trailing: const Icon(Icons.add),
        title: CustomText(
          text: question,
          fontSize: 14,
          color: AppColors.kGrey34,
        ),
        children: [
          CustomText(
            text: answer,
            color: AppColors.kGrey66,
            fontSize: 12,
          )
        ],
      ),
    );
  }
}

*/
