import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helpers/service_helper.dart';
import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';
import 'custom_back_icon.dart';
import 'custom_input_field.dart';

class CustomDropdownButtonFormField extends StatefulWidget {
  List<BaseCustomDropdownButtonFormFieldList> items;
  BaseCustomDropdownButtonFormFieldList? selectedItem;
  final String labelText;
  final ValueChanged<int> onChanged;

  ///
  final bool enabled;
  final int? maxLength;
  final String? formHolderName;
  final TextEditingController? textEditingController;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final bool? obscureText;
  final bool? readOnly;
  final String? counterText;
  final Function? forceRefresh;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isPasswordField;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BoxConstraints? suffixConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? hintStyle;
  final Function? onTap;
  final Iterable<String>? autofillHints;
  bool fetchingItems;

  ScrollController? scrollController;
  final VoidCallback? onLoadMore;

  CustomDropdownButtonFormField({
    super.key,
    required this.items,
    required this.labelText,
    required this.onChanged,
    required this.selectedItem,
    this.fetchingItems = false,
    this.scrollController,
    this.onLoadMore,

    ///
    ///
    this.textEditingController,
    this.textInputAction,
    this.textInputType,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.hintText,
    this.forceRefresh,
    this.decoration,
    this.obscureText,
    this.readOnly,
    this.style,
    this.onFieldSubmitted,
    this.cursorColor,
    this.inputFormatters,
    this.isPasswordField = false,
    this.suffixConstraints,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.onTap,
    this.autofillHints,
    this.formHolderName,
    this.prefixIconConstraints,
    this.enabled = true,
    this.maxLength,
    this.counterText,
    this.maxLines,
  });

  @override
  _CustomDropdownButtonFormFieldState createState() =>
      _CustomDropdownButtonFormFieldState();
}

class _CustomDropdownButtonFormFieldState
    extends State<CustomDropdownButtonFormField> {
  List<BaseCustomDropdownButtonFormFieldList> filteredItems = [];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Removed duplicate didUpdateWidget to fix duplicate definition error

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropdownButtonFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() {
        filteredItems = List.from(widget.items);
      });
    }
  }

  void _showBottomSheetDropdown() {
    if (widget.items.isEmpty) return; // Prevent opening if items are empty
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<BaseCustomDropdownButtonFormFieldList> filteredItems =
            List.from(widget.items);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void filter(String value) {
              setModalState(() {
                filteredItems = widget.items
                    .where((item) => item
                        .toName()
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            }

            // void search(String value) {
            //   ServicesHelper.getGiftcardCategories(search: value, page:1).then((value) {
            //     setModalState(() {
            //       widget.items = value.data;
            //     });
            //   });
            // }

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        children: [
                          BackIcon(),
                          Text("Select ${widget.formHolderName ?? "Item"}",
                              style: get16TextStyle()
                                  .copyWith(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    CustomInputField(
                      hintText: "Search",
                      textEditingController: searchController,
                      onChanged: (v) {
                        filter(v);
                        // if (widget.formHolderName == "Giftcard Category") {
                        //   search(v);
                        // }
                      },
                      decoration: getSearchInputDecoration(),
                    ),
                    // const SizedBox(height: 10),
                    // TextField(
                    //   controller: searchController,
                    //   onChanged: (v) {
                    //     filter(v);
                    //     if (widget.formHolderName == "Giftcard Category") {
                    //       search(v);
                    //     }
                    //   },
                    //   decoration: InputDecoration(
                    //     hintText: "Search...",
                    //     contentPadding: const EdgeInsets.only(
                    //         top: 17, bottom: 17, left: 16, right: 7),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: borderRadius,
                    //       borderSide: BorderSide(
                    //           color: ColorManager.kFormInactiveBorder,
                    //           width: 1),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: borderRadius,
                    //       borderSide: BorderSide(
                    //         width: 0.57,
                    //         color: ColorManager.kTextColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.atEdge) {
                            if (scrollNotification.metrics.pixels != 0) {
                              if (widget.scrollController != null &&
                                  widget.onLoadMore != null) {
                                widget.onLoadMore!();
                              }
                            }
                          }
                          return false;
                        },
                        child: filteredItems.isEmpty
                            ? Center(child: Text("No item found."))
                            : ListView.builder(
                                controller: widget
                                    .scrollController, // <-- Attach the scrollController here
                                itemCount: filteredItems.length,
                                itemBuilder: (_, idx) {
                                  final item = filteredItems[idx];
                                  return ListTile(
                                    leading: item.hasIcon() && widget.formHolderName != "Giftcard Category"
                                        ? SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: loadNetworkImage(
                                              item.toIcon(),
                                              width: 24,
                                              height: 24,
                                              borderRadius:
                                                  BorderRadius.circular(78),
                                            ),
                                          )
                                        : null,
                                    title: Text(item.toName().split("(Rate").first),
                                    onTap: () {
                                      final selectedIndex =
                                          widget.items.indexOf(item);
                                      setState(() => widget.selectedItem = item);
                                      widget.onChanged(selectedIndex);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry!.remove();
              _overlayEntry = null;
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy + size.height + 5.0,
            child: Material(
              color: ColorManager.kWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19)),
              elevation: 1.0,
              child: SizedBox(
                height: widget.items.length > 5 ? 300 : null,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.atEdge) {
                      if (scrollNotification.metrics.pixels != 0) {
                        if (widget.scrollController != null &&
                            widget.onLoadMore != null) {
                          widget.onLoadMore!();
                        }
                        // if (widget.scrollController != null) {
                        //   // Trigger a callback or event to load more items
                        //   if (widget.onTap != null) {
                        //     // widget.onTap!();
                        //     widget.onLoadMore!();
                        //   }
                        // }
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (_, idx) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  ///
                                  if (widget.items[idx].hasIcon())
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: loadNetworkImage(
                                        widget.items[idx].toIcon(),
                                        width: 24,
                                        height: 24,
                                        borderRadius: BorderRadius.circular(78),
                                      ),
                                    ),

                                  Expanded(
                                    child: Text(widget.items[idx].toName()),
                                  )

                                  ///
                                ],
                              ),
                            ),
                            ((widget.items.length - 1) != idx)
                                ? customDivider(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 1.5)
                                : const SizedBox(height: 20)
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() => widget.selectedItem = widget.items[idx]);
                        widget.onChanged(idx);
                        _toggleDropdown();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius borderRadius = BorderRadius.circular(19);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.formHolderName != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.formHolderName!,
                  style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kFadedTextColor),
                ),
              )
            : const SizedBox(),

        //
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            // onTap: widget.enabled ? _toggleDropdown : null,
            onTap: widget.enabled ? _showBottomSheetDropdown : null,

            child: InputDecorator(
              decoration: widget.decoration ??
                  InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: widget.suffixIcon ??
                          (widget.fetchingItems
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorManager.kPrimary),
                                  ),
                                )
                              : Icon(Icons.keyboard_arrow_down_sharp,
                                  color: ColorManager.kFormHintText, size: 25)),
                    ),
                    prefixIcon: widget.prefixIcon,
                    suffixIconConstraints: widget.suffixConstraints ??
                        const BoxConstraints(minHeight: 0, minWidth: 0),
                    prefixIconConstraints: widget.prefixIconConstraints ??
                        const BoxConstraints(minHeight: 0, minWidth: 0),
                    filled: true,
                    fillColor: ColorManager.kWhite,
                    contentPadding: const EdgeInsets.only(
                        top: 17, bottom: 17, left: 16, right: 7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                          color: ColorManager.kFormInactiveBorder, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        width: 0.57,
                        color: ColorManager.kTextColor,
                      ),
                    ),
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle ?? getHintTextStyle(),
                    errorStyle:
                        getHintTextStyle().copyWith(color: ColorManager.kError),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: ColorManager.kError),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: ColorManager.kError),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: ColorManager.kFormBg.withOpacity(0.5),
                      ),
                    ),
                  ),
              child: (widget.selectedItem != null)
                  ? Row(
                      children: [
                        ///
                        if (widget.selectedItem!.hasIcon())
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: loadNetworkImage(
                              widget.selectedItem!.toIcon(),
                              width: 19,
                              height: 19,
                              borderRadius: BorderRadius.circular(78),
                            ),
                          ),

                        Expanded(
                          child: Text(
                            widget.selectedItem!.toName().split("(Rate").first,
                          ),
                        )

                        ///
                      ],
                    )
                  : Text(widget.hintText ?? "", style: get14TextStyle()),
            ),
          ),
        ),
      ],
    );
  }
}

abstract class BaseCustomDropdownButtonFormFieldList {
  String toIcon();
  String toName();
  bool hasIcon();
}
