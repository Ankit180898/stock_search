import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/model/search_stock_model.dart';
import 'package:stock_search/model/stock_model.dart';
import 'package:stock_search/service/stock_service.dart';

class StockController extends GetxController {
  final StockService _stockService;
  final TextEditingController searchController = TextEditingController();

  final searchStocks =
      <SearchStockModel>[].obs; 
  final stocks = <StockModel>[].obs; 
  final isLoading = false.obs; 
  final errorMessage = ''.obs; 
  final selectedStock = Rxn<StockModel>(); 
  final RxString searchQuery = ''.obs; 

  StockController(this._stockService) {
    // Debounce ti remove excess api calls
    debounce<String>(searchQuery, (query) {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        clearSearchResults();
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearchResults() {
    searchQuery.value = '';
    searchController.clear();
    searchStocks.clear();
  }

  // search stocks
  Future<void> _performSearch(String query) async {
    try {
      isLoading.value = true;
      searchStocks.clear(); 

      final response = await _stockService.searchStocks(query);
      if (response.statusCode == 200) {
        isLoading.value = false;
        final List<dynamic> dataList = response.data;
        searchStocks.value =
            dataList.map((item) => SearchStockModel.fromJson(item)).toList();
      } 
    } catch (e) {
      debugPrint('Error searching stocks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // details of stock by id
  Future<void> getStockDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedStock.value = null; 
      final response = await _stockService.getStockDetails(id);
      if (response.statusCode == 200) {
        isLoading.value = false;
        selectedStock.value = StockModel.fromJson(response.data);
      } else {
        errorMessage.value =
            'Error ${response.statusCode}: Unable to fetch stock details';
      }
    } catch (e, stacktrace) {
      debugPrint('Error fetching stock details: $e\n$stacktrace');
      selectedStock.value = null; 
      errorMessage.value =
          'Unable to load stock details. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }
}
