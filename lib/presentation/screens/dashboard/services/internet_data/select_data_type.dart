import 'package:dataplug/core/enum.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/internet_data/buy_data_5.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/model/core/data_provider.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_container.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class SelectDataType extends StatelessWidget {
  const SelectDataType({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      color: ColorManager.kWhite,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Icon(CupertinoIcons.xmark,
                      size: 20, color: Colors.transparent),
                ),
              ),
              Text("Select Data Type", style: get18TextStyle()),

              //
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Icon(CupertinoIcons.xmark,
                      size: 20, color: ColorManager.kTextDark7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // const SizedBox(height: 16),
              CustomContainer(
                width: MediaQuery.sizeOf(context).width * .43,
                //padding: EdgeInsets.all(10),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context, RoutesManager.buyData4,
                    // arguments: DataPurchaseType.sme
                  );
                },
                leftSider: const SizedBox(width: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(ImageManager.kBuyData2, width: 44),
                    const SizedBox(height: 16),
                    Text("SME/CG Data",
                        textAlign: TextAlign.center,
                        style: get14TextStyle()
                            .copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              CustomContainer(
                width: MediaQuery.sizeOf(context).width * .43,
                onTap: () {
                  Navigator.popAndPushNamed(context, RoutesManager.buyData1,
                      arguments: DataPurchaseType.direct);
                },
                // footer: const SizedBox(width: 100, height: 10),
                rightSider: const SizedBox(width: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(ImageManager.kBuyData2, width: 44),
                    const SizedBox(height: 16),
                    Text("Direct Data",
                        style: get14TextStyle()
                            .copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              CustomContainer(
                width: MediaQuery.sizeOf(context).width * .43,
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuyData5(
                              param: DataProvider(
                                  id: "5",
                                  name: "SMILE",
                                  code: "smile",
                                  logo:
                                      "https://staging-api.dataapp.ng/assets/services/smile.png",
                                  type: ''))));
                },
                leftSider: const SizedBox(width: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Color(0xfff4f4f4),
                            borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          Assets.images.smile.path,
                          color: ColorManager.kPrimary,
                        )),
                    const SizedBox(height: 16),
                    Text("Smile Data",
                        style: get14TextStyle()
                            .copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              CustomContainer(
                width: MediaQuery.sizeOf(context).width * .43,
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuyData5(
                              param: DataProvider(
                                  id: "6",
                                  name: "SPECTRANET",
                                  code: "spectranet",
                                  logo:
                                      "https://staging-api.dataapp.ng/assets/services/spectranet.png",
                                  type: ''))));
                },
                // footer: const SizedBox(width: 100, height: 10),
                rightSider: const SizedBox(width: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Color(0xfff4f4f4),
                            borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          Assets.images.freeConnection.path,
                          color: ColorManager.kPrimary,
                        )),
                    const SizedBox(height: 16),
                    Text("Spectranet",
                        style: get14TextStyle()
                            .copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
