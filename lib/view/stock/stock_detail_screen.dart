import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_search/controller/stock_controller.dart';
import 'package:stock_search/model/stock_model.dart';

class StockDetailView extends StatelessWidget {
  const StockDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockController>();
    final stockId = Get.arguments.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStockDetails(stockId);
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.getStockDetails(stockId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final StockModel? stock = controller.selectedStock.value;
        if (stock == null) {
          return const Center(
            child: Text(
              'Stock not found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final isPositive = (stock.changePercent ?? 0) >= 0;
        final changeColor =
            isPositive ? Colors.green.shade700 : Colors.red.shade700;
        final changeSign = isPositive ? '+' : '';

        return CustomScrollView(
          slivers: [
            // Appbar
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.23,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.symbol ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stock.name ?? 'N/A',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              stock.price != null
                                  ? '\$${NumberFormat("#,##0.00").format(stock.price)}'
                                  : 'N/A',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: changeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                stock.changePercent != null
                                    ? '$changeSign${stock.changePercent!.toStringAsFixed(2)}%'
                                    : 'N/A',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: changeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats Cards
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _statCard(
                            'Market Cap',
                            stock.marketCap ?? 'N/A',
                            Icons.show_chart,
                          ),
                          _statCard(
                            'Exchange',
                            stock.exchange ?? 'N/A',
                            Icons.business,
                          ),
                          _statCard(
                            'Sector',
                            stock.sector ?? 'N/A',
                            Icons.category,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildTitleSection('Company Information'),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow('Industry', stock.industry ?? 'N/A'),
                            _buildInfoRow(
                              'Employees',
                              stock.employees?.toString() ?? 'N/A',
                            ),
                            _buildInfoRow('Website', stock.website ?? 'N/A'),
                            _buildInfoRow(
                              'Listed Since',
                              stock.listingDate ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ESG Metrics Section
                    if (stock.sustainableInvestment != null ||
                        stock.totalEmissions != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleSection('ESG Metrics'),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  if (stock.sustainableInvestment != null)
                                    _buildInfoRow(
                                      'Sustainable Investment',
                                      stock.sustainableInvestment!
                                          ? 'Yes'
                                          : 'No',
                                    ),
                                  if (stock.totalEmissions != null)
                                    _buildInfoRow(
                                      'Total Emissions',
                                      '${stock.totalEmissions} MT',
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
