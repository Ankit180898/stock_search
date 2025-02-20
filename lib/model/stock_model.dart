class StockModel {
  int? id;
  String? name;
  String? symbol;
  String? createdAt;
  String? updatedAt;
  String? alpacaId;
  String? exchange;
  String? description;
  String? assetType;
  String? isin;
  String? industry;
  String? sector;
  int? employees;
  String? website;
  String? address;
  String? netZeroProgress;
  double? carbonIntensityScope3;
  double? carbonIntensityScope1And2;
  double? carbonIntensityScope1And2And3;
  String? tempAlignmentScopes1And2;
  bool? dnshAssessmentPass;
  bool? goodGovernanceAssessment;
  bool? contributeToEnvironmentOrSocialObjective;
  bool? sustainableInvestment;
  int? scope1Emissions;
  int? scope2Emissions;
  int? scope3Emissions;
  int? totalEmissions;
  String? listingDate;
  String? marketCap;
  int? ibkrConnectionId;
  double? price;
  double? changePercent;
  List<dynamic>? holdings;
  List<dynamic>? sectorAllocation;
  int? sustainableInvestmentHoldingPercentage;
  bool? inPortfolio;

  StockModel({
    this.id,
    this.name,
    this.symbol,
    this.createdAt,
    this.updatedAt,
    this.alpacaId,
    this.exchange,
    this.description,
    this.assetType,
    this.isin,
    this.industry,
    this.sector,
    this.employees,
    this.website,
    this.address,
    this.netZeroProgress,
    this.carbonIntensityScope3,
    this.carbonIntensityScope1And2,
    this.carbonIntensityScope1And2And3,
    this.tempAlignmentScopes1And2,
    this.dnshAssessmentPass,
    this.goodGovernanceAssessment,
    this.contributeToEnvironmentOrSocialObjective,
    this.sustainableInvestment,
    this.scope1Emissions,
    this.scope2Emissions,
    this.scope3Emissions,
    this.totalEmissions,
    this.listingDate,
    this.marketCap,
    this.ibkrConnectionId,
    this.price,
    this.changePercent,
    this.holdings,
    this.sectorAllocation,
    this.sustainableInvestmentHoldingPercentage,
    this.inPortfolio,
  });

  StockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    symbol = json['symbol'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    alpacaId = json['alpaca_id'];
    exchange = json['exchange'];
    description = json['description'];
    assetType = json['asset_type'];
    isin = json['isin'];
    industry = json['industry'];
    sector = json['sector'];
    employees = json['employees'] is int ? json['employees'] : int.tryParse(json['employees']?.toString() ?? '');
    website = json['website'];
    address = json['address'];
    netZeroProgress = json['net_zero_progress'];
    
    // Convert carbon intensity fields to double:
    carbonIntensityScope3 = json['carbon_intensity_scope_3'] is num
        ? (json['carbon_intensity_scope_3'] as num).toDouble()
        : double.tryParse(json['carbon_intensity_scope_3']?.toString() ?? '');
    carbonIntensityScope1And2 = json['carbon_intensity_scope_1_and_2'] is num
        ? (json['carbon_intensity_scope_1_and_2'] as num).toDouble()
        : double.tryParse(json['carbon_intensity_scope_1_and_2']?.toString() ?? '');
    carbonIntensityScope1And2And3 = json['carbon_intensity_scope_1_and_2_and_3'] is num
        ? (json['carbon_intensity_scope_1_and_2_and_3'] as num).toDouble()
        : double.tryParse(json['carbon_intensity_scope_1_and_2_and_3']?.toString() ?? '');
    
    tempAlignmentScopes1And2 = json['temp_alignment_scopes_1_and_2'];
    dnshAssessmentPass = json['dnsh_assessment_pass'];
    goodGovernanceAssessment = json['good_governance_assessment'];
    contributeToEnvironmentOrSocialObjective = json['contribute_to_environment_or_social_objective'];
    sustainableInvestment = json['sustainable_investment'];
    
    scope1Emissions = json['scope_1_emissions'] is int
        ? json['scope_1_emissions']
        : int.tryParse(json['scope_1_emissions']?.toString() ?? '');
    scope2Emissions = json['scope_2_emissions'] is int
        ? json['scope_2_emissions']
        : int.tryParse(json['scope_2_emissions']?.toString() ?? '');
    scope3Emissions = json['scope_3_emissions'] is int
        ? json['scope_3_emissions']
        : int.tryParse(json['scope_3_emissions']?.toString() ?? '');
    totalEmissions = json['total_emissions'] is int
        ? json['total_emissions']
        : int.tryParse(json['total_emissions']?.toString() ?? '');
    
    listingDate = json['listing_date'];
    marketCap = json['market_cap'];
    ibkrConnectionId = json['ibkr_connection_id'] is int
        ? json['ibkr_connection_id']
        : int.tryParse(json['ibkr_connection_id']?.toString() ?? '');
    
    // Convert price and changePercent to double
    price = json['price'] is num 
        ? (json['price'] as num).toDouble() 
        : double.tryParse(json['price']?.toString() ?? '');
    changePercent = json['change_percent'] is num
        ? (json['change_percent'] as num).toDouble()
        : double.tryParse(json['change_percent']?.toString() ?? '');

    holdings = json['holdings'];
    sectorAllocation = json['sector_allocation'];

    sustainableInvestmentHoldingPercentage = json['sustainable_investment_holding_percentage'] is int
        ? json['sustainable_investment_holding_percentage']
        : int.tryParse(json['sustainable_investment_holding_percentage']?.toString() ?? '');
    inPortfolio = json['in_portfolio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['alpaca_id'] = alpacaId;
    data['exchange'] = exchange;
    data['description'] = description;
    data['asset_type'] = assetType;
    data['isin'] = isin;
    data['industry'] = industry;
    data['sector'] = sector;
    data['employees'] = employees;
    data['website'] = website;
    data['address'] = address;
    data['net_zero_progress'] = netZeroProgress;
    data['carbon_intensity_scope_3'] = carbonIntensityScope3;
    data['carbon_intensity_scope_1_and_2'] = carbonIntensityScope1And2;
    data['carbon_intensity_scope_1_and_2_and_3'] = carbonIntensityScope1And2And3;
    data['temp_alignment_scopes_1_and_2'] = tempAlignmentScopes1And2;
    data['dnsh_assessment_pass'] = dnshAssessmentPass;
    data['good_governance_assessment'] = goodGovernanceAssessment;
    data['contribute_to_environment_or_social_objective'] = contributeToEnvironmentOrSocialObjective;
    data['sustainable_investment'] = sustainableInvestment;
    data['scope_1_emissions'] = scope1Emissions;
    data['scope_2_emissions'] = scope2Emissions;
    data['scope_3_emissions'] = scope3Emissions;
    data['total_emissions'] = totalEmissions;
    data['listing_date'] = listingDate;
    data['market_cap'] = marketCap;
    data['ibkr_connection_id'] = ibkrConnectionId;
    data['price'] = price;
    data['change_percent'] = changePercent;
    data['holdings'] = holdings;
    data['sector_allocation'] = sectorAllocation;
    data['sustainable_investment_holding_percentage'] = sustainableInvestmentHoldingPercentage;
    data['in_portfolio'] = inPortfolio;
    return data;
  }
}
