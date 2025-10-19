import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/faq.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../misc/settings_icon_tab.dart';

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
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: const BackIcon(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: ColorManager.kPrimaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            ImageManager.kFAQsIcon))),
                              ),
                              //
                              Text(
                                "FAQs",
                                textAlign: TextAlign.center,
                                style: get18TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),

                    //

                    //
                    customDivider(
                      height: 1,
                      margin: const EdgeInsets.only(top: 16, bottom: 30),
                      color: ColorManager.kBar2Color,
                    ),

                    loading
                        ? buildLoading()
                        : Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: faqs.length,
                              itemBuilder: (context, index) =>
                                  buildCard(faqs[index]),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Faq faq) {
    return CustomContainer(
      borderRadiusSize: 32,
      header: Text(faq.name.toUpperCase(), style: get14TextStyle()),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          for (int i = 0; i < faq.data.length; i++)
            buildTile(
              faq.data[i],
              margin: EdgeInsets.only(top: i > 0 ? 14 : 0),
            ),
        ],
      ),
    );
  }

  Widget buildTile(FaqData faqData, {EdgeInsetsGeometry? margin}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.faqDetails,
            arguments: faqData);
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: ColorManager.kBar2Color),
          borderRadius: BorderRadius.circular(19),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                faqData.question,
                style: get14TextStyle().copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, color: ColorManager.kBarColor)
          ],
        ),
      ),
    );
  }
}
