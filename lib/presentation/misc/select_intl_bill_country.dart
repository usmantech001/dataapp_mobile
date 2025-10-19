import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/shimmers/square_shimmer.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../core/constants.dart';
import '../../core/helpers/service_helper.dart';
import '../../core/model/core/country.dart';
import 'custom_components/custom_back_icon.dart';
import 'custom_components/custom_elements.dart';
import 'custom_components/custom_input_field.dart';
import 'custom_snackbar.dart';

class SelectIntlBillCountry extends StatefulWidget {
  final String type;
  const SelectIntlBillCountry({super.key, required this.type});

  @override
  State<SelectIntlBillCountry> createState() => _SelectIntlBillCountryState();
}

class _SelectIntlBillCountryState extends State<SelectIntlBillCountry> {
  bool fetchingCountries = false;
  TextEditingController searchController = TextEditingController();
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];

  Future<void> getDataList() async {
    setState(() => fetchingCountries = true);
    await ServicesHelper.getIntlBillCountries(type: widget.type)
        .then((value) {
      allCountries = value;
      filteredCountries = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });
    if (mounted) setState(() => fetchingCountries = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getDataList());
  }

  void startSearch(String arg) {
    if (arg.isEmpty) {
      filteredCountries = allCountries;
    } else {
      filteredCountries = allCountries
          .where((el) =>
              (el.name?.toLowerCase() ?? "").contains(arg.toLowerCase()))
          .toList();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        height: Constants.get650ModalHeight(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  BackIcon(),
                  Text('Select Country',
                      style:
                          get16TextStyle().copyWith(fontWeight: FontWeight.w400))
                ],
              ),
            ),
            CustomInputField(
              hintText: "Search",
              textEditingController: searchController,
              onChanged: (e) => startSearch(e),
              decoration: getSearchInputDecoration(),
            ),
            Expanded(
              child: fetchingCountries
                  ? ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemCount: 5,
                      itemBuilder: (_, __) =>
                          const SquareShimmer(width: double.infinity, height: 50),
                    )
                  : allCountries.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: CustomEmptyState(
                            title:
                                "An error occurred while fetching countries. Please retry.",
                            btnTitle: "Refresh",
                            onTap: getDataList,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 27),
                          itemCount: filteredCountries.length,
                          itemBuilder: (_, i) {
                            final item = filteredCountries[i];
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Navigator.pop(context, item),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xffF0F0F0)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                           width: 20,
                                        height: 20,
                                      child: loadNetworkImage(
                                        item.flagUrl ?? "",
                                        width: 20,
                                        height: 30,
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item.name ?? "",
                                        overflow: TextOverflow.ellipsis,
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
