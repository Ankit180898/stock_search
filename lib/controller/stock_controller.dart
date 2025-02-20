import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/model/search_stock_model.dart';
import 'package:stock_search/model/stock_model.dart';
import 'package:stock_search/service/stock_service.dart';

class StockController extends GetxController {
  final StockService _stockService;
  
  final searchStocks = <SearchStockModel>[].obs;
  final stocks = <StockModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedStock = Rxn<StockModel>();
  final RxString _searchQuery = ''.obs;
  
  StockController(this._stockService) {
    // debounce
    debounce<String>(
      _searchQuery,
      (query) {
        if (query.isNotEmpty) {
          _performSearch(query);
        } else {
          searchStocks.clear();
        }
      },
      time: const Duration(milliseconds: 500),
    );
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  Future<void> _performSearch(String query) async {
    try {
      isLoading.value = true;
      final response = await _stockService.searchStocks(query);
      final List<dynamic> dataList = response.data;
      final results = dataList
          .map((item) => SearchStockModel.fromJson(item))
          .toList();

      searchStocks.value = results;
    } catch (e, stacktrace) {
      debugPrint('Error searching stocks: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStockDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _stockService.getStockDetails(id);
      selectedStock.value = StockModel.fromJson(response.data);
    } catch (e, stacktrace) {
      debugPrint('Error fetching stock details: $e\n$stacktrace');
      errorMessage.value = 'Unable to load stock details. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }
}