import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
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
                                            ImageManager.kSupportIcon))),
                              ),
                              //
                              Text(
                                "Support",
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
                      margin: const EdgeInsets.only(top: 16, bottom: 26),
                      color: ColorManager.kBar2Color,
                    ),

                    Expanded(
                      child: loading
                          ? ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              children: const [
                                SquareShimmer(
                                    height: 95, width: double.infinity),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 35),
                                  child: SquareShimmer(
                                      height: 95, width: double.infinity),
                                ),
                                SquareShimmer(
                                    height: 95, width: double.infinity),
                              ],
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  genericProvider.updateSupportInfo(),
                              child: genericProvider.supportEmail == null
                                  ? ListView(
                                      padding: const EdgeInsets.all(16),
                                      children: [
                                        CustomEmptyState(
                                          btnTitle: "",
                                          onTap: () {},
                                          showBTn: false,
                                        )
                                      ],
                                    )
                                  : ListView(
                                      controller: controller,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      children: [
                                        //
                                        CustomContainer(
                                          onTap: () {
                                            Uri url = Uri.parse(
                                                "tel:${genericProvider.supportPhone}");
                                            launchUrl(url)
                                                .then((value) {})
                                                .catchError((onError) {});
                                          },
                                          padding: const EdgeInsets.all(20),
                                          borderRadiusSize: 32,
                                          child: Row(
                                            children: [
                                              //
                                              Image.asset(ImageManager.kCallUs,
                                                  width: 44),
                                              const SizedBox(width: 11),

                                              //
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Call us",
                                                        style: get14TextStyle()
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Text(
                                                        genericProvider
                                                                .supportPhone ??
                                                            "",
                                                        style:
                                                            get12TextStyle()),
                                                  ],
                                                ),
                                              ),

                                              Icon(Icons.chevron_right,
                                                  color: ColorManager.kBarColor)
                                            ],
                                          ),
                                        ),

                                        CustomContainer(
                                          onTap: () {
                                            Uri url = Uri.parse(
                                                "mailto:${genericProvider.supportEmail}");
                                            launchUrl(url)
                                                .then((value) {})
                                                .catchError((onError) {});
                                          },
                                          padding: const EdgeInsets.all(20),
                                          borderRadiusSize: 32,
                                          child: Row(
                                            children: [
                                              //
                                              Image.asset(
                                                  ImageManager.kSendUsMail,
                                                  width: 44),
                                              const SizedBox(width: 11),

                                              //
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Send us a mail",
                                                        style: get14TextStyle()
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Text(
                                                        genericProvider
                                                                .supportEmail ??
                                                            "",
                                                        style:
                                                            get12TextStyle()),
                                                  ],
                                                ),
                                              ),

                                              Icon(Icons.chevron_right,
                                                  color: ColorManager.kBarColor)
                                            ],
                                          ),
                                        ),

                                        CustomContainer(
                                          onTap: () {
                                            Uri url = Uri.parse(
                                                "https://wa.me/${genericProvider.supportWhatsapp}");
                                            launchUrl(url)
                                                .then((value) {})
                                                .catchError((onError) {});
                                          },
                                          padding: const EdgeInsets.all(20),
                                          borderRadiusSize: 32,
                                          child: Row(
                                            children: [
                                              //
                                              Image.asset(
                                                  ImageManager
                                                      .kChatWithUsOnWhatsapp,
                                                  width: 44),
                                              const SizedBox(width: 11),

                                              //
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Chat with us on whatsapp",
                                                        style: get14TextStyle()
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Text(
                                                      genericProvider
                                                              .supportWhatsapp ??
                                                          "",
                                                      style: get12TextStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Icon(Icons.chevron_right,
                                                  color: ColorManager.kBarColor)
                                            ],
                                          ),
                                        ),

                                        //
                                        const SizedBox(height: 50),
                                      ],
                                    ),
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
}
