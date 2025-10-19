import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/service_helper.dart';
import '../custom_snackbar.dart';

class PaginatedGiftcardBottomSheet extends StatefulWidget {
  const PaginatedGiftcardBottomSheet({Key? key}) : super(key: key);

  @override
  _PaginatedGiftcardBottomSheetState createState() => _PaginatedGiftcardBottomSheetState();
}

class _PaginatedGiftcardBottomSheetState extends State<PaginatedGiftcardBottomSheet> {
  late List<GiftcardCategory> categories;
  List<GiftcardCategory> _filteredGiftcards = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _loading = true;
  bool _hasMoreItems = true;



    Future<void> getDataList1({int page = 1}) async {
    if (page > 1) {
      setState(() {
        _isLoadingMore = true;
      });
    }
    await ServicesHelper.getGiftcardCategories(search: '', page: page)
        .then((value) {
      if (mounted) {
        setState(() {
          categories.addAll(value.data); // Add more categories to the list
          if (page == 1) {
            _loading = false; // Set loading to false after initial data is fetched
          } else {
            _isLoadingMore = false; // Pagination loading done
          }
        });
      }
    }).catchError((msg) {
      print(msg); // Handle error here
      if (mounted) {
        setState(() {
          if (page == 1) {
            _loading = false; // Set loading to false if there is an error
          } else {
            _isLoadingMore = false;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    categories = [];
    _filteredGiftcards = [];
    _scrollController.addListener(_handleScroll);
    _loadMoreGiftcards();
  }

  // Method to load more data
  Future<void> _loadMoreGiftcards() async {
    if (_isLoadingMore || !_hasMoreItems) return;  // Avoid unnecessary calls
    setState(() {
      _isLoadingMore = true;
    });

    try {
  await getDataList1(page: _currentPage);
      if (categories.isNotEmpty ) {
        setState(() {
          categories.addAll(categories);
          _filteredGiftcards = categories
              .where((item) => item.toName().toLowerCase().contains(_searchController.text.toLowerCase()))
              .toList();
          _currentPage++;
        });
      } else {
        setState(() {
          _hasMoreItems = false;  // No more items to load
        });
      }
    } catch (e) {
      // Handle error
      showCustomToast(context: context, description: e.toString());
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // Scroll listener to detect when the user reaches the end
  void _handleScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore && _hasMoreItems) {
      _loadMoreGiftcards();
    }
  }

  // Filter giftcards based on search
  void _filterGiftcards(String value) {
    setState(() {
      _filteredGiftcards = categories
          .where((item) => item.toName().toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showGiftcardBottomSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Giftcard",
          border: const OutlineInputBorder(),
        ),
        child: Text("Select Giftcard"),
      ),
    );
  }

  // Show bottom sheet with paginated and searchable giftcards
  void _showGiftcardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 600,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                    Text("Select Giftcard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: "Search...", border: OutlineInputBorder()),
                  onChanged: _filterGiftcards,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredGiftcards.isEmpty
                      ? const Center(child: Text("No items found"))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredGiftcards.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoadingMore && index == _filteredGiftcards.length) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final item = _filteredGiftcards[index];
                            return ListTile(
                              title: Text(item.toName()),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
