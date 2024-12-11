class StockDetailsDTO {
  String? symbol;
  String? assetType;
  String? name;
  String? description;
  String? cik;
  String? exchange;
  String? currency;
  String? country;
  String? sector;
  String? industry;
  String? address;
  String? officialSite;
  String? fiscalYearEnd;
  String? latestQuarter;
  String? marketCapitalization;
  String? ebitda;
  String? peRatio;
  String? pegRatio;
  String? bookValue;
  String? dividendPerShare;
  String? dividendYield;
  String? eps;
  String? revenuePerShareTTM;
  String? profitMargin;
  String? operatingMarginTTM;
  String? returnOnAssetsTTM;
  String? returnOnEquityTTM;
  String? revenueTTM;
  String? grossProfitTTM;
  String? dilutedEPSTTM;
  String? quarterlyEarningsGrowthYOY;
  String? quarterlyRevenueGrowthYOY;
  String? analystTargetPrice;
  int? analystRatingStrongBuy;
  int? analystRatingBuy;
  int? analystRatingHold;
  int? analystRatingSell;
  int? analystRatingStrongSell;
  String? trailingPE;
  String? forwardPE;
  String? priceToSalesRatioTTM;
  String? priceToBookRatio;
  String? evToRevenue;
  String? evToEbitda;
  String? beta;
  String? week52High;
  String? week52Low;
  String? movingAverage50Day;
  String? movingAverage200Day;
  String? sharesOutstanding;
  String? dividendDate;
  String? exDividendDate;

  StockDetailsDTO({
    this.symbol,
    this.assetType,
    this.name,
    this.description,
    this.cik,
    this.exchange,
    this.currency,
    this.country,
    this.sector,
    this.industry,
    this.address,
    this.officialSite,
    this.fiscalYearEnd,
    this.latestQuarter,
    this.marketCapitalization,
    this.ebitda,
    this.peRatio,
    this.pegRatio,
    this.bookValue,
    this.dividendPerShare,
    this.dividendYield,
    this.eps,
    this.revenuePerShareTTM,
    this.profitMargin,
    this.operatingMarginTTM,
    this.returnOnAssetsTTM,
    this.returnOnEquityTTM,
    this.revenueTTM,
    this.grossProfitTTM,
    this.dilutedEPSTTM,
    this.quarterlyEarningsGrowthYOY,
    this.quarterlyRevenueGrowthYOY,
    this.analystTargetPrice,
    this.analystRatingStrongBuy,
    this.analystRatingBuy,
    this.analystRatingHold,
    this.analystRatingSell,
    this.analystRatingStrongSell,
    this.trailingPE,
    this.forwardPE,
    this.priceToSalesRatioTTM,
    this.priceToBookRatio,
    this.evToRevenue,
    this.evToEbitda,
    this.beta,
    this.week52High,
    this.week52Low,
    this.movingAverage50Day,
    this.movingAverage200Day,
    this.sharesOutstanding,
    this.dividendDate,
    this.exDividendDate,
  });

  factory StockDetailsDTO.fromJson(Map<String, dynamic> json) {
    return StockDetailsDTO(
      symbol: json['symbol'],
      assetType: json['assetType'],
      name: json['name'],
      description: json['description'],
      cik: json['cik'],
      exchange: json['exchange'],
      currency: json['currency'],
      country: json['country'],
      sector: json['sector'],
      industry: json['industry'],
      address: json['address'],
      officialSite: json['officialSite'],
      fiscalYearEnd: json['fiscalYearEnd'],
      latestQuarter: json['latestQuarter'],
      marketCapitalization: json['marketCapitalization'],
      ebitda: json['ebitda'],
      peRatio: json['peRatio'],
      pegRatio: json['pegRatio'],
      bookValue: json['bookValue'],
      dividendPerShare: json['dividendPerShare'],
      dividendYield: json['dividendYield'],
      eps: json['eps'],
      revenuePerShareTTM: json['revenuePerShareTTM'],
      profitMargin: json['profitMargin'],
      operatingMarginTTM: json['operatingMarginTTM'],
      returnOnAssetsTTM: json['returnOnAssetsTTM'],
      returnOnEquityTTM: json['returnOnEquityTTM'],
      revenueTTM: json['revenueTTM'],
      grossProfitTTM: json['grossProfitTTM'],
      dilutedEPSTTM: json['dilutedEPSTTM'],
      quarterlyEarningsGrowthYOY: json['quarterlyEarningsGrowthYOY'],
      quarterlyRevenueGrowthYOY: json['quarterlyRevenueGrowthYOY'],
      analystTargetPrice: json['analystTargetPrice'],
      analystRatingStrongBuy: json['analystRatingStrongBuy'],
      analystRatingBuy: json['analystRatingBuy'],
      analystRatingHold: json['analystRatingHold'],
      analystRatingSell: json['analystRatingSell'],
      analystRatingStrongSell: json['analystRatingStrongSell'],
      trailingPE: json['trailingPE'],
      forwardPE: json['forwardPE'],
      priceToSalesRatioTTM: json['priceToSalesRatioTTM'],
      priceToBookRatio: json['priceToBookRatio'],
      evToRevenue: json['evToRevenue'],
      evToEbitda: json['evToEbitda'],
      beta: json['beta'],
      week52High: json['52WeekHigh'],
      week52Low: json['52WeekLow'],
      movingAverage50Day: json['50DayMovingAverage'],
      movingAverage200Day: json['200DayMovingAverage'],
      sharesOutstanding: json['sharesOutstanding'],
      dividendDate: json['dividendDate'],
      exDividendDate: json['exDividendDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'assetType': assetType,
      'name': name,
      'description': description,
      'cik': cik,
      'exchange': exchange,
      'currency': currency,
      'country': country,
      'sector': sector,
      'industry': industry,
      'address': address,
      'officialSite': officialSite,
      'fiscalYearEnd': fiscalYearEnd,
      'latestQuarter': latestQuarter,
      'marketCapitalization': marketCapitalization,
      'ebitda': ebitda,
      'peRatio': peRatio,
      'pegRatio': pegRatio,
      'bookValue': bookValue,
      'dividendPerShare': dividendPerShare,
      'dividendYield': dividendYield,
      'eps': eps,
      'revenuePerShareTTM': revenuePerShareTTM,
      'profitMargin': profitMargin,
      'operatingMarginTTM': operatingMarginTTM,
      'returnOnAssetsTTM': returnOnAssetsTTM,
      'returnOnEquityTTM': returnOnEquityTTM,
      'revenueTTM': revenueTTM,
      'grossProfitTTM': grossProfitTTM,
      'dilutedEPSTTM': dilutedEPSTTM,
      'quarterlyEarningsGrowthYOY': quarterlyEarningsGrowthYOY,
      'quarterlyRevenueGrowthYOY': quarterlyRevenueGrowthYOY,
      'analystTargetPrice': analystTargetPrice,
      'analystRatingStrongBuy': analystRatingStrongBuy,
      'analystRatingBuy': analystRatingBuy,
      'analystRatingHold': analystRatingHold,
      'analystRatingSell': analystRatingSell,
      'analystRatingStrongSell': analystRatingStrongSell,
      'trailingPE': trailingPE,
      'forwardPE': forwardPE,
      'priceToSalesRatioTTM': priceToSalesRatioTTM,
      'priceToBookRatio': priceToBookRatio,
      'evToRevenue': evToRevenue,
      'evToEbitda': evToEbitda,
      'beta': beta,
      '52WeekHigh': week52High,
      '52WeekLow': week52Low,
      '50DayMovingAverage': movingAverage50Day,
      '200DayMovingAverage': movingAverage200Day,
      'sharesOutstanding': sharesOutstanding,
      'dividendDate': dividendDate,
      'exDividendDate': exDividendDate,
    };
  }
}
