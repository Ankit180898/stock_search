import 'package:dio/dio.dart';
import '../core/api_client.dart';

class StockService {
  final ApiClient _apiClient;

  StockService(this._apiClient);

  Future<Response> searchStocks(String query) async {
    try {
      return await _apiClient.get(
        '/stocks/search',
        queryParameters: {'query': query},
      );
    } catch (e) {
      throw 'Stock search failed: ${e.toString()}';
    }
  }

  Future<Response> getStockDetails(String id) async {
    try {
      return await _apiClient.get('/stocks/$id');
    } catch (e) {
      throw 'Failed to get stock details: ${e.toString()}';
    }
  }

  Future<Response> getStockPriceGraph(String id, String range) async {
    try {
      return await _apiClient.get(
        '/stocks/$id/price-graph',
        queryParameters: {'range': range},
      );
    } catch (e) {
      throw 'Failed to get price graph: ${e.toString()}';
    }
  }
}