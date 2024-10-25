class AnnualReport {
  final String fiscalDateEnding;
  final String reportedCurrency;
  final String totalAssets;
  final String totalCurrentAssets;
  final String cashAndCashEquivalentsAtCarryingValue;
  final String cashAndShortTermInvestments;
  final String inventory;
  final String currentNetReceivables;
  final String totalNonCurrentAssets;
  final String propertyPlantEquipment;
  final String accumulatedDepreciationAmortizationPPE;
  final String intangibleAssets;
  final String intangibleAssetsExcludingGoodwill;
  final String goodwill;
  final String investments;
  final String longTermInvestments;
  final String shortTermInvestments;
  final String otherCurrentAssets;
  final String otherNonCurrentAssets;
  final String totalLiabilities;
  final String totalCurrentLiabilities;
  final String currentAccountsPayable;
  final String deferredRevenue;
  final String currentDebt;
  final String shortTermDebt;
  final String totalNonCurrentLiabilities;
  final String capitalLeaseObligations;
  final String longTermDebt;
  final String currentLongTermDebt;
  final String longTermDebtNoncurrent;
  final String shortLongTermDebtTotal;
  final String otherCurrentLiabilities;
  final String otherNonCurrentLiabilities;
  final String totalShareholderEquity;
  final String treasuryStock;
  final String retainedEarnings;
  final String commonStock;
  final String commonStockSharesOutstanding;

  AnnualReport({
    required this.fiscalDateEnding,
    required this.reportedCurrency,
    required this.totalAssets,
    required this.totalCurrentAssets,
    required this.cashAndCashEquivalentsAtCarryingValue,
    required this.cashAndShortTermInvestments,
    required this.inventory,
    required this.currentNetReceivables,
    required this.totalNonCurrentAssets,
    required this.propertyPlantEquipment,
    required this.accumulatedDepreciationAmortizationPPE,
    required this.intangibleAssets,
    required this.intangibleAssetsExcludingGoodwill,
    required this.goodwill,
    required this.investments,
    required this.longTermInvestments,
    required this.shortTermInvestments,
    required this.otherCurrentAssets,
    required this.otherNonCurrentAssets,
    required this.totalLiabilities,
    required this.totalCurrentLiabilities,
    required this.currentAccountsPayable,
    required this.deferredRevenue,
    required this.currentDebt,
    required this.shortTermDebt,
    required this.totalNonCurrentLiabilities,
    required this.capitalLeaseObligations,
    required this.longTermDebt,
    required this.currentLongTermDebt,
    required this.longTermDebtNoncurrent,
    required this.shortLongTermDebtTotal,
    required this.otherCurrentLiabilities,
    required this.otherNonCurrentLiabilities,
    required this.totalShareholderEquity,
    required this.treasuryStock,
    required this.retainedEarnings,
    required this.commonStock,
    required this.commonStockSharesOutstanding,
  });

  factory AnnualReport.fromJson(Map<String, dynamic> json) {
    return AnnualReport(
      fiscalDateEnding: json['fiscalDateEnding'],
      reportedCurrency: json['reportedCurrency'],
      totalAssets: json['totalAssets'],
      totalCurrentAssets: json['totalCurrentAssets'],
      cashAndCashEquivalentsAtCarryingValue: json['cashAndCashEquivalentsAtCarryingValue'],
      cashAndShortTermInvestments: json['cashAndShortTermInvestments'],
      inventory: json['inventory'],
      currentNetReceivables: json['currentNetReceivables'],
      totalNonCurrentAssets: json['totalNonCurrentAssets'],
      propertyPlantEquipment: json['propertyPlantEquipment'],
      accumulatedDepreciationAmortizationPPE: json['accumulatedDepreciationAmortizationPPE'] ?? 'None',
      intangibleAssets: json['intangibleAssets'],
      intangibleAssetsExcludingGoodwill: json['intangibleAssetsExcludingGoodwill'],
      goodwill: json['goodwill'],
      investments: json['investments'],
      longTermInvestments: json['longTermInvestments'],
      shortTermInvestments: json['shortTermInvestments'],
      otherCurrentAssets: json['otherCurrentAssets'],
      otherNonCurrentAssets: json['otherNonCurrentAssets'] ?? 'None',
      totalLiabilities: json['totalLiabilities'],
      totalCurrentLiabilities: json['totalCurrentLiabilities'],
      currentAccountsPayable: json['currentAccountsPayable'],
      deferredRevenue: json['deferredRevenue'],
      currentDebt: json['currentDebt'],
      shortTermDebt: json['shortTermDebt'],
      totalNonCurrentLiabilities: json['totalNonCurrentLiabilities'],
      capitalLeaseObligations: json['capitalLeaseObligations'],
      longTermDebt: json['longTermDebt'],
      currentLongTermDebt: json['currentLongTermDebt'],
      longTermDebtNoncurrent: json['longTermDebtNoncurrent'],
      shortLongTermDebtTotal: json['shortLongTermDebtTotal'],
      otherCurrentLiabilities: json['otherCurrentLiabilities'],
      otherNonCurrentLiabilities: json['otherNonCurrentLiabilities'],
      totalShareholderEquity: json['totalShareholderEquity'],
      treasuryStock: json['treasuryStock'],
      retainedEarnings: json['retainedEarnings'],
      commonStock: json['commonStock'],
      commonStockSharesOutstanding: json['commonStockSharesOutstanding'],
    );
  }
}
