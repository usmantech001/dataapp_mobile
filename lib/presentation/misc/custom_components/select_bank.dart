import 'dart:async';
import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/bank_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/generic_provider.dart';
import '../../../core/model/core/bank.dart';
import '../shimmers/square_shimmer.dart';
import '../style_manager/styles_manager.dart';
import 'custom_back_icon.dart';
import 'custom_input_field.dart';

class SelectBank extends StatefulWidget {
  const SelectBank({Key? key}) : super(key: key);

  @override
  State<SelectBank> createState() => _SearchBanksState();
}

class _SearchBanksState extends State<SelectBank> {
 
  

  @override
  void dispose() {
   // scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
     final controller = context.read<BankController>();
     final banks = controller.bankList;
     controller.clearSearchController();
     if(banks.isEmpty){
      controller.getBankList();
     }
    });
    
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<BankController>(
        builder: (context, controller, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            height: size.height - (size.height * .35),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Bank',
                          style: get16TextStyle()
                              .copyWith(fontWeight: FontWeight.w400)),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor: ColorManager.kGreyF8,
                              child: Icon(
                                Icons.close,
                                color: ColorManager.kGreyColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                CustomInputField(
                  hintText: "Search",
                  textEditingController: controller.searchController,
                  onChanged: controller.filterBanks,
                  decoration: getSearchInputDecoration(),
                ),
                Expanded(
                  child: controller.fetchingBanks
                      ? ListView.separated(
                          padding: const EdgeInsets.only(top: 27),
                          separatorBuilder: ((context, index) =>
                              const SizedBox(height: 20)),
                          itemCount: 5,
                          itemBuilder: (_, int i) => const SquareShimmer(
                              width: double.infinity, height: 50),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 27),
                          //controller: scrollController,
                          itemCount: controller.searchController.text.isNotEmpty
                              ? controller.filteredBanks.length
                              : controller.bankList.length,
                          itemBuilder: (_, int i) {
                            Bank bank = controller.searchController.text.isNotEmpty
                                ? controller.filteredBanks[i]
                                : controller.bankList[i];
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                controller.onBankSelected(bank);
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                decoration: const BoxDecoration(
          
                                ),
                                child: Row(
                                  spacing: 10.w,
                                  children: [
                                   bank.icon!=null? loadNetworkImage(bank.icon!, borderRadius: BorderRadius.circular(10)) : CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: ColorManager.kGreyE8,
                                   ),
                                    Flexible(
                                      child: Text(
                                        bank.name,
                                        style: get16TextStyle().copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, i) => Gap(8),
                        ),
                ),
                // _alreadyLoading
                //     ? const Padding(
                //         padding: EdgeInsets.only(bottom: 20),
                //         child: SquareShimmer(height: 40, width: double.infinity))
                //     : const SizedBox()
              ],
            ),
          );
        }
      ),
    );
  }
}
