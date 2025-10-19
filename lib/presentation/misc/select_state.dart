import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/shimmers/square_shimmer.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/generic_provider.dart';
import '../../core/constants.dart';
import '../../core/model/core/state.dart';
import 'custom_components/custom_back_icon.dart';
import 'custom_components/custom_input_field.dart';

class SelectState extends StatefulWidget {
  final String countryId;
  const SelectState({Key? key, required this.countryId}) : super(key: key);

  @override
  State<SelectState> createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  bool fetchingData = false;
  TextEditingController searchController = TextEditingController();
  List<AppState> filteredData = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);

      if (mounted) setState(() => fetchingData = true);
      await genericProvider
          .updateState(widget.countryId)
          .then((_) {})
          .catchError((_) {});
      if (mounted) setState(() => fetchingData = false);
    });
    super.initState();
  }

  void startSearch(String arg, List<AppState> lst) {
    try {
      filteredData = lst
          .where((el) =>
              (el.name?.toLowerCase() ?? "").contains(arg.toLowerCase()))
          .toList();
    } catch (e) {
      searchController.text = "";
      filteredData = [];
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider =
        Provider.of<GenericProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                  const BackIcon(),
                  Text('Select State',
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400))
                ],
              ),
            ),
            CustomInputField(
              hintText: "Search",
              textEditingController: searchController,
              onChanged: (e) => startSearch(e, genericProvider.state),
              decoration: getSearchInputDecoration(),
            ),
            Expanded(
              child: fetchingData
                  ? ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 5,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    )
                  : genericProvider.state.isEmpty
                      ? CustomEmptyState(
                          btnTitle: "Refresh",
                          title:
                              "An error occured while fetching state, please retry.",
                          onTap: () async {
                            if (mounted) setState(() => fetchingData = true);

                            await genericProvider
                                .updateState(widget.countryId)
                                .then((_) {})
                                .catchError((_) {});
                            if (mounted) setState(() => fetchingData = false);
                          },
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 27),
                          addAutomaticKeepAlives: false,
                          shrinkWrap: true,
                          itemCount: searchController.text.isNotEmpty
                              ? filteredData.length
                              : genericProvider.state.length,
                          itemBuilder: (_, int i) {
                            AppState item = searchController.text.isNotEmpty
                                ? filteredData[i]
                                : genericProvider.state[i];
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Navigator.pop(context, item),
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF0F0F0))),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                  )),
                            );
                          },
                          separatorBuilder: (_, i) =>
                              const SizedBox(height: 10),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
