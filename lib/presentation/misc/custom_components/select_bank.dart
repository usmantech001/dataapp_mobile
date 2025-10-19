import 'dart:async';
import 'package:flutter/material.dart';
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
  bool fetchingBanks = false;
  TextEditingController searchController = TextEditingController();
  List<Bank> filteredBanks = [];
  bool _alreadyLoading = false;
  ScrollController scrollController = ScrollController();

  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !_alreadyLoading)) {
      if (mounted) setState(() => _alreadyLoading = true);
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      await genericProvider.updateBankList();
      if (mounted) setState(() => _alreadyLoading = false);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollController.addListener(pagination);
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      if (genericProvider.banks.isEmpty) {
        if (mounted) setState(() => fetchingBanks = true);
      }
      await genericProvider.updateBankList();
      if (mounted) setState(() => fetchingBanks = false);
    });
    super.initState();
  }

  Timer? timer;
  void startSearch(String arg, List<Bank> lst) {
    filteredBanks = [];
    if (arg.isEmpty) {
      if (mounted) setState(() {});
      return;
    }
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 150), () async {
      for (Bank el in lst) {
        if ((el.name.toLowerCase()).contains(arg.toLowerCase())) {
          filteredBanks.add(el);
        }
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider =
        Provider.of<GenericProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        height: size.height - (size.height * .35),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                        padding: EdgeInsets.only(right: 14), child: BackIcon()),
                  ),
                  Text('Select Bank',
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400))
                ],
              ),
            ),
            CustomInputField(
              hintText: "Search",
              textEditingController: searchController,
              onChanged: (e) => startSearch(e, genericProvider.banks),
              decoration: getSearchInputDecoration(),
            ),
            Expanded(
              child: fetchingBanks
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
                      controller: scrollController,
                      itemCount: searchController.text.isNotEmpty
                          ? filteredBanks.length
                          : genericProvider.banks.length,
                      itemBuilder: (_, int i) {
                        Bank bank = searchController.text.isNotEmpty
                            ? filteredBanks[i]
                            : genericProvider.banks[i];
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context, bank),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Color(0xffF0F0F0))),
                            ),
                            child: Text(
                              bank.name,
                              style: get16TextStyle().copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, i) => const SizedBox(height: 10),
                    ),
            ),
            _alreadyLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SquareShimmer(height: 40, width: double.infinity))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
