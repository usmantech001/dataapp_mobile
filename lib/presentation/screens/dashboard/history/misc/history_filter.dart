import 'package:dataplug/presentation/misc/custom_components/custom_back_icon.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_small_btn.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class HistoryFilter extends StatefulWidget {
  const HistoryFilter({super.key});

  @override
  State<HistoryFilter> createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool servicePurposeExpanded = false;
  bool statusExpanded = false;
  bool priceRangeExpanded = false;
  bool dateExpanded = false;

  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    cashFlowType = userProvider.filterCashFlowType;
    status = userProvider.filterStatus;
    purpose = userProvider.filterPurpose;
    startDate = userProvider.filterStartDate;
    endDate = userProvider.filterEndDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  void clearFilter(UserProvider userProvider) {
    cashFlowType = null;
    status = null;
    purpose = null;
    startDate = null;
    endDate = null;
    userProvider.clearTxnFilter();
    setState(() {});
  }

  CashFlowType? cashFlowType;
  Status? status;
  ServicePurpose? purpose;

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: size.height - 65,
          color: ColorManager.kWhite,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackIcon(onTap: () => applyFilter(userProvider))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Filter",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomSmallBtn(
                              text: "Clear Filter",
                              isActive: true,
                              onTap: () => clearFilter(userProvider),
                              loading: false,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                customDivider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    controller: controller,
                    children: [
                      //

                      ExpansionPanelList(
                        dividerColor: Colors.white,
                        elevation: 0,
                        expandedHeaderPadding: const EdgeInsets.only(),
                        expansionCallback: (int index, bool isExpanded) {
                          if (index == 0) {
                            setState(
                                () => servicePurposeExpanded = !isExpanded);
                          } else if (index == 1) {
                            setState(() => statusExpanded = !isExpanded);
                          } else if (index == 2) {
                            setState(() => priceRangeExpanded = !isExpanded);
                          } else if (index == 3) {
                            setState(() => dateExpanded = !isExpanded);
                          }
                        },
                        children: [
                          ExpansionPanel(
                            backgroundColor: Colors.white,
                            canTapOnHeader: false,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTileTheme(
                                contentPadding: const EdgeInsets.all(0),
                                dense: true,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('CASHFLOW', style: titleTextStyle),
                                  ],
                                ),
                              );
                            },
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildTxnTypeItem(
                                  "All",
                                  cashFlowType == null,
                                  onTap: () {
                                    setState(() => cashFlowType = null);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Inflows",
                                  cashFlowType == CashFlowType.credit,
                                  onTap: () {
                                    setState(() =>
                                        cashFlowType = CashFlowType.credit);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Outflows",
                                  cashFlowType == CashFlowType.debit,
                                  onTap: () {
                                    setState(() =>
                                        cashFlowType = CashFlowType.debit);
                                  },
                                ),
                              ],
                            ),
                            
                            isExpanded: servicePurposeExpanded,
                          ),

                          //
                          ExpansionPanel(
                            canTapOnHeader: false,
                            backgroundColor: Colors.white,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('STATUS', style: titleTextStyle),
                                ],
                              );
                            },
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildTxnTypeItem(
                                  "All",
                                  status == null,
                                  onTap: () {
                                    setState(() => status = null);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Successful",
                                  status == Status.successful,
                                  onTap: () {
                                    setState(
                                      () => status = Status.successful,
                                    );
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Failed",
                                  status == Status.failed,
                                  onTap: () {
                                    setState(
                                      () => status = Status.failed,
                                    );
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Pending",
                                  status == Status.pending,
                                  onTap: () {
                                    setState(
                                      () => status = Status.pending,
                                    );
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Reversed",
                                  status == Status.reversed,
                                  onTap: () {
                                    setState(
                                      () => status = Status.reversed,
                                    );
                                  },
                                ),
                              ],
                            ),
                            isExpanded: true,
                          ),
 ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: Colors.white,

                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('DATE', style: titleTextStyle)],
                              );
                            },
                            body: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
                                    color: ColorManager.kBar2Color, width: .8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () =>
                                            _showDateSelectorBottomSheet(true),
                                        behavior: HitTestBehavior.translucent,
                                        child: Row(
                                          children: [
                                            dateIcon(
                                              size: 24,
                                              padding: const EdgeInsets.only(
                                                  right: 9),
                                              color: ColorManager.kTextDark
                                                  .withOpacity(.6),
                                            ),
                                            Text(
                                              "${startDate == null ? "Start Date" : formatDateSlash(startDate)}",
                                              style: get14TextStyle().copyWith(
                                                  color: ColorManager.kTextDark
                                                      .withOpacity(.7)),
                                            )
                                          ],
                                        )),
                                  ),
                                  //

                                  Image.asset(ImageManager.kInterTwainIcon,
                                  color: ColorManager.kPrimary,
                                      width: 16),

                                  //
                                  Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () =>
                                            _showDateSelectorBottomSheet(false),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${endDate == null ? "End Date" : formatDateSlash(endDate)}",
                                              style: get14TextStyle().copyWith(
                                                  color: ColorManager.kTextDark
                                                      .withOpacity(.7)),
                                            ),
                                            dateIcon(
                                              size: 24,
                                              color: ColorManager.kPrimary
                                                  .withOpacity(.6),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            isExpanded: true,
                          ),
                          //
                          ExpansionPanel(
                            canTapOnHeader: false,
                            backgroundColor: Colors.white,

                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('TRANSACTION TYPE',
                                      style: titleTextStyle),
                                ],
                              );
                            },
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //

                                buildTxnTypeItem(
                                  "All",
                                  purpose == null,
                                  onTap: () {
                                    setState(() => purpose = null);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Withdrawal",
                                  purpose == ServicePurpose.withdrawal,
                                  onTap: () {
                                    setState(() =>
                                        purpose = ServicePurpose.withdrawal);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Transfer",
                                  purpose == ServicePurpose.transfer,
                                  onTap: () {
                                    setState(() =>
                                        purpose = ServicePurpose.transfer);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Top Up",
                                  purpose == ServicePurpose.deposit,
                                  onTap: () {
                                    setState(
                                        () => purpose = ServicePurpose.deposit);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Data",
                                  purpose == ServicePurpose.data,
                                  onTap: () {
                                    setState(
                                        () => purpose = ServicePurpose.data);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Airtime",
                                  purpose == ServicePurpose.airtime,
                                  onTap: () {
                                    setState(
                                        () => purpose = ServicePurpose.airtime);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "TV/Cable",
                                  purpose == ServicePurpose.tvSubscription,
                                  onTap: () {
                                    setState(() => purpose =
                                        ServicePurpose.tvSubscription);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "E-PIN",
                                  purpose == ServicePurpose.education,
                                  onTap: () {
                                    setState(() =>
                                        purpose = ServicePurpose.education);
                                  },
                                ),
                                buildTxnTypeItem(
                                  "Electricity",
                                  purpose == ServicePurpose.electricity,
                                  onTap: () {
                                    setState(() =>
                                        purpose = ServicePurpose.electricity);
                                  },
                                ),
                              ],
                            ),
                            isExpanded: true,
                          ),

                          //
                         
                        ],
                      ),

                      //
                    ],
                  ),
                ),
                customDivider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
                  child: CustomButton(
                    text: "Apply",
                    isActive: true,
                    onTap: () => applyFilter(userProvider),
                    loading: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTxnTypeItem(String title, bool selected,
          {required Function onTap}) =>
      GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: get14TextStyle().copyWith(
                    color: ColorManager.kTextDark.withOpacity(.9),
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                size: 22,
                color: selected
                    ? ColorManager.kPrimary
                    : ColorManager.kSmallText.withOpacity(.5),
              ),
              const SizedBox(width: 22),
            ],
          ),
        ),
      );

  _showDateSelectorBottomSheet(bool isStartDate) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        height: 300,
        padding:
            const EdgeInsets.only(top: 19, bottom: 19, left: 24, right: 24),
        child: Column(
          children: [
            Container(
              height: 250,
              margin: const EdgeInsets.only(bottom: 12),
              child: CupertinoDatePicker(
                minimumYear: 1900,
                maximumYear: DateTime.now().year,
                use24hFormat: true,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) {
                  if (isStartDate) {
                    startDate = val;
                  } else {
                    endDate = val;
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle titleTextStyle =
      get14TextStyle().copyWith(color: ColorManager.kTextDark.withOpacity(.7));

  void applyFilter(UserProvider userProvider) {
    try {
      if (startDate != null || endDate != null) {
        if ((startDate == null && endDate != null) ||
            (startDate != null && endDate == null)) {
          throw "Please select both start and end date";
        }
      }
      userProvider.resetTxnFilter(
          status: status,
          purpose: purpose,
          cashFlowType: cashFlowType,
          startDate: startDate,
          endDate: endDate,
          preventRefresh: false);

      Navigator.pop(context);
    } catch (e) {
      showCustomToast(context: context, description: e.toString());
    }
  }
}
