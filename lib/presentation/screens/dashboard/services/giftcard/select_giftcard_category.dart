import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/model/core/giftcard_category_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class GiftcardCategorySelector extends StatefulWidget {
  final List<GiftcardCategory> categories;
  final String? labelText;
    final Function onChanged;

  const GiftcardCategorySelector({super.key, required this.categories, this.labelText, required this.onChanged});

  @override
  State<GiftcardCategorySelector> createState() =>
      _GiftcardCategorySelectorState();
}

class _GiftcardCategorySelectorState extends State<GiftcardCategorySelector> {
  GiftcardCategory? selectedCategory;
  void _showCategoryBottomSheet() async {
    final result = await showModalBottomSheet<GiftcardCategory>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CategoryBottomSheet(
        categories: widget.categories,
        selected: selectedCategory,
        onChanged: widget.onChanged()
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.labelText ?? "",
                  style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kFadedTextColor),
                ),
              ),
        GestureDetector(
          onTap: _showCategoryBottomSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.kFormInactiveBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: loadNetworkImage(
                        selectedCategory?.icon ?? "",
                        width: 19,
                        height: 19,
                        borderRadius: BorderRadius.circular(78),
                      ),
                    ),
                    Text(
                      selectedCategory?.name ?? 'Select Giftcard Category',
                      style: TextStyle(
                        color: selectedCategory == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_down_sharp,
                    color: ColorManager.kFormHintText, size: 25)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryBottomSheet extends StatefulWidget {
  final List<GiftcardCategory> categories;
  final GiftcardCategory? selected;
    final Function(int) onChanged;
  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.onChanged,
    this.selected,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late List<GiftcardCategory> filteredCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.categories;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCategories = widget.categories
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        maxChildSize: .9,
        initialChildSize: .9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: ColorManager.kFormInactiveBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search category...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorManager.kFormInactiveBorder,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorManager.kFormInactiveBorder,
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filteredCategories.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return ListTile(
                        title: Row(
                          children: [
                            ///
                            if (category.hasIcon())
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: loadNetworkImage(
                                  category.icon,
                                  width: 19,
                                  height: 19,
                                  borderRadius: BorderRadius.circular(78),
                                ),
                              ),
                            Gap(10),
                            Expanded(
                              child: Text(
                                category.toName(),
                              ),
                            )

                            ///
                          ],
                        ),
                        // trailing: category == widget.selected
                        //     ? const Icon(Icons.check, color: Colors.green)
                        //     : null,
                        onTap: () {
                            final index = widget.categories.indexOf(category);

                       widget.onChanged(index);
                          Navigator.pop(context, category);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
