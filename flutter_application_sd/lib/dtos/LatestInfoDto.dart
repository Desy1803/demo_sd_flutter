class LatestInfoDto {
  final String symbol;
  final String assetType;
  final String name;
  final String description;
  final String cik;
  final String exchange;
  final String currency;
  final String country;
  final String sector;
  final String industry;
  final String address;
  final String officialSite;
  final String fiscalYearEnd;
  final String latestQuarter;
  final String marketCapitalization;
  final String ebitda;
  final String pERatio;
  final String pEGRatio;
  final String bookValue;
  final String dividendPerShare;
  final String dividendYield;
  final String eps;
  final String revenuePerShareTTM;
  final String profitMargin;
  final String operatingMarginTTM;
  final String returnOnAssetsTTM;
  final String returnOnEquityTTM;
  final String revenueTTM;
  final String grossProfitTTM;
  final String dilutedEPSTTM;
  final String quarterlyEarningsGrowthYOY;
  final String quarterlyRevenueGrowthYOY;
  final String analystTargetPrice;
  final String analystRatingStrongBuy;
  final String analystRatingBuy;
  final String analystRatingHold;
  final String analystRatingSell;
  final String analystRatingStrongSell;
  final String trailingPE;
  final String forwardPE;
  final String priceToSalesRatioTTM;
  final String priceToBookRatio;
  final String eVToRevenue;
  final String eVToEBITDA;
  final String beta;
  final String sharesOutstanding;
  final String dividendDate;
  final String exDividendDate;

  // Constructor
  LatestInfoDto({
    required this.symbol,
    required this.assetType,
    required this.name,
    required this.description,
    required this.cik,
    required this.exchange,
    required this.currency,
    required this.country,
    required this.sector,
    required this.industry,
    required this.address,
    required this.officialSite,
    required this.fiscalYearEnd,
    required this.latestQuarter,
    required this.marketCapitalization,
    required this.ebitda,
    required this.pERatio,
    required this.pEGRatio,
    required this.bookValue,
    required this.dividendPerShare,
    required this.dividendYield,
    required this.eps,
    required this.revenuePerShareTTM,
    required this.profitMargin,
    required this.operatingMarginTTM,
    required this.returnOnAssetsTTM,
    required this.returnOnEquityTTM,
    required this.revenueTTM,
    required this.grossProfitTTM,
    required this.dilutedEPSTTM,
    required this.quarterlyEarningsGrowthYOY,
    required this.quarterlyRevenueGrowthYOY,
    required this.analystTargetPrice,
    required this.analystRatingStrongBuy,
    required this.analystRatingBuy,
    required this.analystRatingHold,
    required this.analystRatingSell,
    required this.analystRatingStrongSell,
    required this.trailingPE,
    required this.forwardPE,
    required this.priceToSalesRatioTTM,
    required this.priceToBookRatio,
    required this.eVToRevenue,
    required this.eVToEBITDA,
    required this.beta,
    required this.sharesOutstanding,
    required this.dividendDate,
    required this.exDividendDate,
  });

  // Factory constructor to create an object from JSON
  factory LatestInfoDto.fromJson(Map<String, dynamic> json) {
    return LatestInfoDto(
      symbol: json['Symbol'] ?? '',
      assetType: json['AssetType'] ?? '',
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      cik: json['CIK'] ?? '',
      exchange: json['Exchange'] ?? '',
      currency: json['Currency'] ?? '',
      country: json['Country'] ?? '',
      sector: json['Sector'] ?? '',
      industry: json['Industry'] ?? '',
      address: json['Address'] ?? '',
      officialSite: json['OfficialSite'] ?? '',
      fiscalYearEnd: json['FiscalYearEnd'] ?? '',
      latestQuarter: json['LatestQuarter'] ?? '',
      marketCapitalization: json['MarketCapitalization']?.toString() ?? '',
      ebitda: json['EBITDA']?.toString() ?? '',
      pERatio: json['PERatio']?.toString() ?? '',
      pEGRatio: json['PEGRatio']?.toString() ?? '',
      bookValue: json['BookValue']?.toString() ?? '',
      dividendPerShare: json['DividendPerShare']?.toString() ?? '',
      dividendYield: json['DividendYield']?.toString() ?? '',
      eps: json['EPS']?.toString() ?? '',
      revenuePerShareTTM: json['RevenuePerShareTTM']?.toString() ?? '',
      profitMargin: json['ProfitMargin']?.toString() ?? '',
      operatingMarginTTM: json['OperatingMarginTTM']?.toString() ?? '',
      returnOnAssetsTTM: json['ReturnOnAssetsTTM']?.toString() ?? '',
      returnOnEquityTTM: json['ReturnOnEquityTTM']?.toString() ?? '',
      revenueTTM: json['RevenueTTM']?.toString() ?? '',
      grossProfitTTM: json['GrossProfitTTM']?.toString() ?? '',
      dilutedEPSTTM: json['DilutedEPSTTM']?.toString() ?? '',
      quarterlyEarningsGrowthYOY: json['QuarterlyEarningsGrowthYOY']?.toString() ?? '',
      quarterlyRevenueGrowthYOY: json['QuarterlyRevenueGrowthYOY']?.toString() ?? '',
      analystTargetPrice: json['AnalystTargetPrice']?.toString() ?? '',
      analystRatingStrongBuy: json['AnalystRatingStrongBuy']?.toString() ?? '',
      analystRatingBuy: json['AnalystRatingBuy']?.toString() ?? '',
      analystRatingHold: json['AnalystRatingHold']?.toString() ?? '',
      analystRatingSell: json['AnalystRatingSell']?.toString() ?? '',
      analystRatingStrongSell: json['AnalystRatingStrongSell']?.toString() ?? '',
      trailingPE: json['TrailingPE']?.toString() ?? '',
      forwardPE: json['ForwardPE']?.toString() ?? '',
      priceToSalesRatioTTM: json['PriceToSalesRatioTTM']?.toString() ?? '',
      priceToBookRatio: json['PriceToBookRatio']?.toString() ?? '',
      eVToRevenue: json['EVToRevenue']?.toString() ?? '',
      eVToEBITDA: json['EVToEBITDA']?.toString() ?? '',
      beta: json['Beta']?.toString() ?? '',
      sharesOutstanding: json['SharesOutstanding']?.toString() ?? '',
      dividendDate: json['DividendDate'] ?? '',
      exDividendDate: json['ExDividendDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Symbol': symbol,
      'AssetType': assetType,
      'Name': name,
      'Description': description,
      'CIK': cik,
      'Exchange': exchange,
      'Currency': currency,
      'Country': country,
      'Sector': sector,
      'Industry': industry,
      'Address': address,
      'OfficialSite': officialSite,
      'FiscalYearEnd': fiscalYearEnd,
      'LatestQuarter': latestQuarter,
      'MarketCapitalization': marketCapitalization,
      'EBITDA': ebitda,
      'PERatio': pERatio,
      'PEGRatio': pEGRatio,
      'BookValue': bookValue,
      'DividendPerShare': dividendPerShare,
      'DividendYield': dividendYield,
      'EPS': eps,
      'RevenuePerShareTTM': revenuePerShareTTM,
      'ProfitMargin': profitMargin,
      'OperatingMarginTTM': operatingMarginTTM,
      'ReturnOnAssetsTTM': returnOnAssetsTTM,
      'ReturnOnEquityTTM': returnOnEquityTTM,
      'RevenueTTM': revenueTTM,
      'GrossProfitTTM': grossProfitTTM,
      'DilutedEPSTTM': dilutedEPSTTM,
      'QuarterlyEarningsGrowthYOY': quarterlyEarningsGrowthYOY,
      'QuarterlyRevenueGrowthYOY': quarterlyRevenueGrowthYOY,
      'AnalystTargetPrice': analystTargetPrice,
      'AnalystRatingStrongBuy': analystRatingStrongBuy,
      'AnalystRatingBuy': analystRatingBuy,
      'AnalystRatingHold': analystRatingHold,
      'AnalystRatingSell': analystRatingSell,
      'AnalystRatingStrongSell': analystRatingStrongSell,
      'TrailingPE': trailingPE,
      'ForwardPE': forwardPE,
      'PriceToSalesRatioTTM': priceToSalesRatioTTM,
      'PriceToBookRatio': priceToBookRatio,
      'EVToRevenue': eVToRevenue,
      'EVToEBITDA': eVToEBITDA,
      'Beta': beta,
      'SharesOutstanding': sharesOutstanding,
      'DividendDate': dividendDate,
      'ExDividendDate': exDividendDate,
    };
  }
}
