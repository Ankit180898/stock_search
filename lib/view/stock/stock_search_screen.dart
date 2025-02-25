import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/controller/auth_controller.dart';
import 'package:stock_search/controller/stock_controller.dart';
import 'package:stock_search/core/theme.dart';

class StockSearchView extends GetView<StockController> {
  const StockSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // AppBar with Search Field
          SliverAppBar(
            title: Text(
              'Stocks Search',
              style: AppTheme.headline2.copyWith(color: AppTheme.textColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.find<AuthController>().logout();
                },
                icon: const Icon(Icons.logout, color: AppTheme.textColor),
              ),
            ],
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppTheme.cardColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.cardColor,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Obx(() {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600), 
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: (value) => controller.updateSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Search stocks, ETFs, mutual funds...',
                          hintStyle: AppTheme.caption.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: controller.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    controller.searchQuery.value = '';
                                    controller.searchController.clear();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Search Results
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              );
            }

            if (controller.searchStocks.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for stocks',
                        style: AppTheme.bodyText1.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching by company name or symbol',
                        style: AppTheme.caption.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final stock = controller.searchStocks[index];
                final imgUrl = stock.image?.url;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        controller.selectedStock.value = null;
                        Get.toNamed('/stock-details', arguments: stock);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Stock Logo
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                image: imgUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(imgUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: imgUrl == null
                                  ? Center(
                                      child: Text(
                                        stock.symbol?.substring(0, 1).toUpperCase() ?? '?',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),

                            // Stock Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        stock.symbol ?? 'Unknown',
                                        style: AppTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          stock.exchange ?? '',
                                          style: AppTheme.caption.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    stock.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.bodyText2.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (stock.description?.isNotEmpty ?? false) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      stock.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.caption.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: controller.searchStocks.length),
            );
          }),
        ],
      ),
    );
  }
}