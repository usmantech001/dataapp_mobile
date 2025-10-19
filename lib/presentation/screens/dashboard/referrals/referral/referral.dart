import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/utils/utils.dart';

class ReferralMeta extends StatelessWidget {
  const ReferralMeta({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 15),
          child: Image.asset(ImageManager.kGiftIcon, width: 110),
        ),
        Text('Share DataApp with Friends', style: get18TextStyle()),
        const SizedBox(height: 9),
           Consumer<GenericProvider>(
          builder: (context, provider, child) {
            // Fetch the referral term data if not fetched already
            if (provider.refTerm == null) {
              provider.getRefTerm();
            }

            return provider.refTerm == null
                ? SizedBox.shrink()  // Show a loading spinner if the term is still fetching
                : SizedBox(width: MediaQuery.sizeOf(context).width* 8 , height: 40,
                  child: Text(
                      provider.refTerm?.body ?? 'Loading...',  // Display the referral term's body
                      style: get14TextStyle().copyWith(height: 1.3),
                      textAlign: TextAlign.center,
                    ),
                );
          },
        ),
        CustomContainer(
          borderRadiusSize: 32,
          margin: const EdgeInsets.only(top: 36),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 19),
          width: double.infinity,
          header: Text("CODE", style: get14TextStyle()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Referral Code", style: get14TextStyle()),
              CustomContainer(
                margin: const EdgeInsets.only(top: 10),
                borderRadiusSize: 19,
                padding: const EdgeInsets.only(
                    left: 16, top: 10, bottom: 14, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userProvider.user?.ref_code ?? "NA",
                        style: get14TextStyle()),

                    SizedBox(
                      width: 73,
                      child: CustomButton(
                          height: 30,
                          text: "Copy",
                          isActive: true,
                          onTap: () => copyToClipboard(
                              context, userProvider.user?.ref_code ?? "NA"),
                          loading: false),
                    ),
                    //
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
