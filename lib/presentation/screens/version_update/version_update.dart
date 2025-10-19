import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VersionUpdate extends StatelessWidget {
  const VersionUpdate({super.key});

  final spacer = const SizedBox(height: 30);

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
                    Text("New Update Available",
                        textAlign: TextAlign.center, style: get18TextStyle()),
                    customDivider(
                      height: 1,
                      margin: const EdgeInsets.only(top: 16, bottom: 55),
                      color: ColorManager.kBar2Color,
                    ),

                    //
                    Image.asset(ImageManager.kAppUpdateIcon, width: 106),

                    //
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Text(
                        "Our app has a newer version that is faster and better than ever!",
                        textAlign: TextAlign.center,
                        style: get14TextStyle().copyWith(),
                      ),
                    ),
                    //

                    const SizedBox(height: 23),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButton(
                          text: "Update App",
                          isActive: true,
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManager.passwordReset3);
                          },
                          loading: false),
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButton(
                          text: "Remind me later",
                          isActive: !true,
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManager.passwordReset3);
                          },
                          loading: false),
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
}
