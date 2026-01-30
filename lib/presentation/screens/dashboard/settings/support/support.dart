import 'package:dataplug/gen/assets.gen.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/providers/generic_provider.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/shimmers/square_shimmer.dart';
import '../misc/settings_icon_tab.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final spacer = const SizedBox(height: 30);
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);

      if (genericProvider.supportEmail != null) {
        setState(() => loading = false);
      }
      await genericProvider.updateSupportInfo().then((_) {}).catchError((_) {
        if (mounted) {
          showCustomToast(
            context: context,
            description: "An error occured, please retry again.",
          );
        }
      });

      if (mounted) setState(() => loading = false);
    });
    super.initState();
  }

  ScrollController controller = ScrollController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(title: 'Support'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            loading
                ? Column(
                    children: const [
                      SquareShimmer(height: 95, width: double.infinity),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child:
                            SquareShimmer(height: 95, width: double.infinity),
                      ),
                      SquareShimmer(height: 95, width: double.infinity),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () => genericProvider.updateSupportInfo(),
                    child: genericProvider.supportEmail == null
                        ? Column(
                            children: [
                              CustomEmptyState(
                                btnTitle: "",
                                onTap: () {},
                                showBTn: false,
                              )
                            ],
                          )
                        : Column(
                          spacing: 8.h,
                            children: [
                              //
                              SettingsIconTab(
                                  onTap: () {
                                    Uri url = Uri.parse(
                                        "tel:${genericProvider.supportPhone}");
                                    launchUrl(url)
                                        .then((value) {})
                                        .catchError((onError) {});
                                  },
                                  text: "Call us",
                                  shortDesc: genericProvider.supportPhone ?? "",
                                  img: 'call-icon'),

                                  SettingsIconTab(
                                  onTap: () {
                                    Uri url = Uri.parse(
                                      "mailto:${genericProvider.supportEmail}");
                                  launchUrl(url)
                                      .then((value) {})
                                      .catchError((onError) {});
                                  },
                                  text: "Send us a mail",
                                  shortDesc: genericProvider.supportEmail ?? "",
                                  img: 'mail-icon'),  
                                   SettingsIconTab(
                                  onTap: () {
                                    Uri url = Uri.parse(
                                      "https://wa.me/${genericProvider.supportWhatsapp}");
                                  launchUrl(url)
                                      .then((value) {})
                                      .catchError((onError) {});
                                  },
                                  text: "Chat with us on Whatsapp",
                                  shortDesc: genericProvider.supportWhatsapp ?? "",
                                  img: 'whatsapp-icon'), 

                            

                              

                              
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
