class CompanyDetails {
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
  final String peRatio;
  final String pegRatio;
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
  final String evToRevenue;
  final String evToEBITDA;
  final String beta;
  final String week52High;
  final String week52Low;
  final String day50MovingAverage;
  final String day200MovingAverage;
  final String sharesOutstanding;
  final String dividendDate;
  final String exDividendDate;

  // Constructor
  CompanyDetails({
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
    required this.peRatio,
    required this.pegRatio,
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
    required this.evToRevenue,
    required this.evToEBITDA,
    required this.beta,
    required this.week52High,
    required this.week52Low,
    required this.day50MovingAverage,
    required this.day200MovingAverage,
    required this.sharesOutstanding,
    required this.dividendDate,
    required this.exDividendDate,
  });

  // Metodo fromJson per deserializzazione
  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      symbol: json['Symbol'],
      assetType: json['AssetType'],
      name: json['Name'],
      description: json['Description'],
      cik: json['CIK'],
      exchange: json['Exchange'],
      currency: json['Currency'],
      country: json['Country'],
      sector: json['Sector'],
      industry: json['Industry'],
      address: json['Address'],
      officialSite: json['OfficialSite'],
      fiscalYearEnd: json['FiscalYearEnd'],
      latestQuarter: json['LatestQuarter'],
      marketCapitalization: json['MarketCapitalization'],
      ebitda: json['EBITDA'],
      peRatio: json['PERatio'],
      pegRatio: json['PEGRatio'],
      bookValue: json['BookValue'],
      dividendPerShare: json['DividendPerShare'],
      dividendYield: json['DividendYield'],
      eps: json['EPS'],
      revenuePerShareTTM: json['RevenuePerShareTTM'],
      profitMargin: json['ProfitMargin'],
      operatingMarginTTM: json['OperatingMarginTTM'],
      returnOnAssetsTTM: json['ReturnOnAssetsTTM'],
      returnOnEquityTTM: json['ReturnOnEquityTTM'],
      revenueTTM: json['RevenueTTM'],
      grossProfitTTM: json['GrossProfitTTM'],
      dilutedEPSTTM: json['DilutedEPSTTM'],
      quarterlyEarningsGrowthYOY: json['QuarterlyEarningsGrowthYOY'],
      quarterlyRevenueGrowthYOY: json['QuarterlyRevenueGrowthYOY'],
      analystTargetPrice: json['AnalystTargetPrice'],
      analystRatingStrongBuy: json['AnalystRatingStrongBuy'],
      analystRatingBuy: json['AnalystRatingBuy'],
      analystRatingHold: json['AnalystRatingHold'],
      analystRatingSell: json['AnalystRatingSell'],
      analystRatingStrongSell: json['AnalystRatingStrongSell'],
      trailingPE: json['TrailingPE'],
      forwardPE: json['ForwardPE'],
      priceToSalesRatioTTM: json['PriceToSalesRatioTTM'],
      priceToBookRatio: json['PriceToBookRatio'],
      evToRevenue: json['EVToRevenue'],
      evToEBITDA: json['EVToEBITDA'],
      beta: json['Beta'],
      week52High: json['52WeekHigh'],
      week52Low: json['52WeekLow'],
      day50MovingAverage: json['50DayMovingAverage'],
      day200MovingAverage: json['200DayMovingAverage'],
      sharesOutstanding: json['SharesOutstanding'],
      dividendDate: json['DividendDate'],
      exDividendDate: json['ExDividendDate'],
    );
  }

  // Metodo toJson per serializzazione
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
      'PERatio': peRatio,
      'PEGRatio': pegRatio,
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
      'EVToRevenue': evToRevenue,
      'EVToEBITDA': evToEBITDA,
      'Beta': beta,
      '52WeekHigh': week52High,
      '52WeekLow': week52Low,
      '50DayMovingAverage': day50MovingAverage,
      '200DayMovingAverage': day200MovingAverage,
      'SharesOutstanding': sharesOutstanding,
      'DividendDate': dividendDate,
      'ExDividendDate': exDividendDate,
    };
  }
}
