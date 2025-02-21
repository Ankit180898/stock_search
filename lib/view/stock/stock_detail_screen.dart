import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_search/controller/stock_controller.dart';
import 'package:stock_search/core/theme.dart';
import 'package:stock_search/model/search_stock_model.dart';
import 'package:stock_search/model/stock_model.dart';
import 'package:url_launcher/url_launcher.dart';

class StockDetailView extends StatelessWidget {
  const StockDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockController>();
    final searchStock = Get.arguments as SearchStockModel?;

    // Fetch stock details if searchStock is provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (searchStock != null) {
        controller.getStockDetails(searchStock.id.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: AppTheme.bodyText1.copyWith(
                    color: AppTheme.errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (searchStock != null) {
                      controller.getStockDetails(searchStock.id.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Retry', style: AppTheme.buttonText),
                ),
              ],
            ),
          );
        }
        final StockModel? stock = controller.selectedStock.value;

        if (stock == null) {
          return Center(
            child: Text(
              'Stock not found',
              style: AppTheme.bodyText1.copyWith(color: Colors.grey),
            ),
          );
        }

        final isPositive = (stock.changePercent ?? 0) >= 0;
        final changeColor =
            isPositive ? AppTheme.successColor : AppTheme.errorColor;
        final changeSign = isPositive ? '+' : '';

        final stockImg = searchStock?.image?.url;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.30,
              pinned: true,
              stretch: true,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    stock.symbol ?? 'N/A',
                    style: AppTheme.headline3.copyWith(
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stock.name ?? 'N/A',
                    style: AppTheme.bodyText2.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.cardColor,
              foregroundColor: AppTheme.textColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: SafeArea(
                    child: Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),

                            image:
                                stockImg != null
                                    ? DecorationImage(
                                      image: NetworkImage(stockImg),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              stockImg == null
                                  ? Center(
                                    child: Text(
                                      stock.symbol
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          '?',
                                      style: AppTheme.headline2.copyWith(
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              stock.price != null
                                  ? '\$${NumberFormat("#,##0.00").format(stock.price)}'
                                  : 'N/A',
                              style: AppTheme.headline1.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
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
                            style: AppTheme.bodyText1.copyWith(
                              color: changeColor,
                            ),
                          ),
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
                    // Stats Section
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _statCard(
                            'Market Cap',
                            stock.marketCap ?? 'N/A',
                            Icons.show_chart,
                            context,
                          ),
                          _statCard(
                            'Exchange',
                            stock.exchange ?? 'N/A',
                            Icons.business,
                            context,
                          ),
                          _statCard(
                            'Sector',
                            stock.sector ?? 'N/A',
                            Icons.category,
                            context,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDescriptionSection(stock.description ?? 'N/A'),

                    const SizedBox(height: 24),

                    // Company Information Section
                    infoCard(
                      title: 'Company Information',
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

                    const SizedBox(height: 24),

                    // ESG Metrics Section
                    if (stock.sustainableInvestment != null ||
                        stock.totalEmissions != null)
                      infoCard(
                        title: 'ESG Metrics',
                        child: Column(
                          children: [
                            if (stock.sustainableInvestment != null)
                              _buildInfoRow(
                                'Sustainable Investment',
                                stock.sustainableInvestment! ? 'Yes' : 'No',
                              ),
                            if (stock.totalEmissions != null)
                              _buildInfoRow(
                                'Total Emissions',
                                '${stock.totalEmissions} MT',
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (stock.scope1Emissions != null ||
                        stock.scope2Emissions != null ||
                        stock.scope3Emissions != null)
                      infoCard(
                        title: 'Emissions Metrics',
                        child: Column(
                          children: [
                            if (stock.scope1Emissions != null)
                              _buildMetricRow(
                                'Scope 1 Emissions',
                                '${stock.scope1Emissions} MT',
                              ),
                            if (stock.scope2Emissions != null)
                              _buildMetricRow(
                                'Scope 2 Emissions',
                                '${stock.scope2Emissions} MT',
                              ),
                            if (stock.scope3Emissions != null)
                              _buildMetricRow(
                                'Scope 3 Emissions',
                                '${stock.scope3Emissions} MT',
                              ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // ESG Ratings Section
                    if (_hasESGData(stock))
                      infoCard(
                        title: 'ESG Ratings',
                        child: Column(
                          children: [
                            if (stock.dnshAssessmentPass != null)
                              _buildInfoRow(
                                'DNHS Assessment',
                                stock.dnshAssessmentPass! ? 'Pass' : 'Fail',
                              ),
                            if (stock.goodGovernanceAssessment != null)
                              _buildInfoRow(
                                'Governance Assessment',
                                stock.goodGovernanceAssessment!
                                    ? 'Good'
                                    : 'Poor',
                              ),
                            if (stock
                                    .contributeToEnvironmentOrSocialObjective !=
                                null)
                              _buildInfoRow(
                                'Contribute to E/S Objective',
                                stock.contributeToEnvironmentOrSocialObjective!
                                    ? 'Yes'
                                    : 'No',
                              ),
                          ],
                        ),
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

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.caption.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(String description) {
    final isExpanded = false.obs;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExpanded.value
                ? description
                : (description.length > 100
                    ? '${description.substring(0, 100)}...'
                    : description),
            maxLines: isExpanded.value ? null : 3,
            style: AppTheme.bodyText1.copyWith(color: Colors.grey.shade600),
          ),
          if (description.length > 100)
            TextButton(
              onPressed: () {
                isExpanded.value = !isExpanded.value;
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                isExpanded.value ? 'Read Less' : 'Read More',
                style: AppTheme.buttonText.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyText2.copyWith(color: Colors.grey.shade600),
          ),
          label == 'Website'
              ? InkWell(
                onTap: () async {
                  var url = value;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    Get.snackbar(
                      'Error',
                      'Could not launch $url',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text(
                  value,

                  style: AppTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              : Text(
                value,
                style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
              ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyText2.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  bool _hasESGData(StockModel stock) {
    return stock.sustainableInvestment != null ||
        stock.dnshAssessmentPass != null ||
        stock.goodGovernanceAssessment != null ||
        stock.contributeToEnvironmentOrSocialObjective != null;
  }

  Widget infoCard({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headline3.copyWith(color: AppTheme.textColor),
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ],
    );
  }
}
