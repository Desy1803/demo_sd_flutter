import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/LatestInfoDto.dart';
import 'package:flutter_application_sd/pagesAuth/WriteArticle.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class LatestInformationPage extends StatefulWidget {
  final String symbol;
  final String companyName;
  const LatestInformationPage({Key? key, required this.symbol, required this.companyName}) : super(key: key);

  @override
  _LatestInformationPageState createState() => _LatestInformationPageState();
}

class _LatestInformationPageState extends State<LatestInformationPage> {
  LatestInfoDto? latestInfo;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLatestInfo();
  }

  Future<void> _fetchLatestInfo() async {
    try {
      LatestInfoDto? details = await Model.sharedInstance.getLatestInfo(widget.symbol);
      setState(() {
        latestInfo = details;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to fetch data: $error';
        isLoading = false;
      });
    }
  }

  void _showInfoDialog(String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Field Information"),
          content: Text(info),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String formatNumber(double value) {
    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M'; // Format to millions (M)
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K'; // Format to thousands (K)
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.companyName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F3F),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Financial Data Section
            _buildSection('Financial Data', [
              _buildFieldRow('Market Capitalization', '${formatNumber(latestInfo!.marketCapitalization as double)} USD', 'The total market value of the company\'s outstanding shares.'),
              _buildFieldRow('EBITDA', '${formatNumber(latestInfo!.ebitda as double)} USD', 'Earnings before interest, taxes, depreciation, and amortization.'),
              _buildFieldRow('PE Ratio', latestInfo!.pERatio.toString(), 'Price-to-Earnings ratio, calculated as stock price divided by earnings per share.'),
              _buildFieldRow('PEG Ratio', latestInfo!.pEGRatio.toString(), 'Price/Earnings-to-Growth ratio, a valuation metric that considers growth.'),
              _buildFieldRow('Book value', formatNumber(latestInfo!.bookValue as double), 'Value of the company\'s net assets per share.'),
              _buildFieldRow('Trailing P/E', latestInfo!.trailingPE.toString(), 'P/E ratio based on the company\'s trailing 12-month earnings.'),
              _buildFieldRow('Forward P/E', latestInfo!.forwardPE.toString(), 'P/E ratio based on the company\'s estimated future earnings.'),
              _buildFieldRow('Price to Sales Ratio', latestInfo!.priceToSalesRatioTTM.toString(), 'A ratio comparing the company\'s stock price to its revenue per share.'),
              _buildFieldRow('Price to Book Ratio', latestInfo!.priceToBookRatio.toString(), 'A ratio comparing the company\'s market price to its book value.'),
              _buildFieldRow('EV to Revenue', formatNumber(latestInfo!.eVToRevenue as double), 'Enterprise Value to Revenue, a valuation metric for comparing a company\'s revenues.'),
              _buildFieldRow('EV to EBITDA', formatNumber(latestInfo!.eVToEBITDA as double), 'Enterprise Value to EBITDA, a valuation metric that considers debt.'),
            ]),
            
            _buildSection('Profitability & Margins', [
              _buildFieldRow('Profit Margin', '${latestInfo!.profitMargin}%', 'The percentage of revenue that becomes profit.'),
              _buildFieldRow('Operating Margin (TTM)', latestInfo!.operatingMarginTTM, 'The company\'s operating income divided by its revenue over the trailing 12 months.'),
              _buildFieldRow('Return on Assets (TTM)', latestInfo!.returnOnAssetsTTM, 'A profitability ratio showing net income relative to total assets.'),
              _buildFieldRow('Return on Equity (TTM)', latestInfo!.returnOnEquityTTM, 'A profitability ratio showing net income relative to shareholder\'s equity.'),
            ]),

            // Revenue & Growth Section
            _buildSection('Revenue & Growth', [
              _buildFieldRow('Revenue (TTM)', formatNumber(latestInfo!.revenueTTM as double), 'The total revenue generated over the trailing 12 months.'),
              _buildFieldRow('Gross Profit (TTM)', formatNumber(latestInfo!.grossProfitTTM as double), 'Total revenue minus the cost of goods sold over the trailing 12 months.'),
              _buildFieldRow('Revenue per Share (TTM)', formatNumber(latestInfo!.revenuePerShareTTM as double), 'Total revenue divided by the total number of shares.'),
              _buildFieldRow('EPS', latestInfo!.eps, 'Earnings per Share, the company\'s net income divided by its number of shares.'),
              _buildFieldRow('Diluted EPS (TTM)', latestInfo!.dilutedEPSTTM, 'Earnings per share adjusted for potential dilution from stock options, etc.'),
              _buildFieldRow('Quarterly Earnings Growth', latestInfo!.quarterlyEarningsGrowthYOY, 'Year-over-year percentage growth in quarterly earnings.'),
              _buildFieldRow('Quarterly Revenue Growth', latestInfo!.quarterlyRevenueGrowthYOY, 'Year-over-year percentage growth in quarterly revenue.'),
            ]),

            // Analyst Ratings Section
            _buildSection('Analyst Ratings', [
              _buildFieldRow('Target price', latestInfo!.analystTargetPrice, 'The average target price estimated by analysts.'),
              _buildFieldRow('Strong buy', latestInfo!.analystRatingStrongBuy, 'Number of analysts who strongly recommend buying this stock.'),
              _buildFieldRow('Buy', latestInfo!.analystRatingBuy, 'Number of analysts who recommend buying this stock.'),
              _buildFieldRow('Hold', latestInfo!.analystRatingHold, 'Number of analysts who recommend holding this stock.'),
              _buildFieldRow('Sell', latestInfo!.analystRatingSell, 'Number of analysts who recommend selling this stock.'),
              _buildFieldRow('Strong sell', latestInfo!.analystRatingStrongSell, 'Number of analysts who strongly recommend selling this stock.'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String sectionTitle, List<Widget> fields) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getSectionIcon(sectionTitle),
              SizedBox(width: 8.0),
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F3F),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WriteArticlePage(
                   symbol: widget.symbol,
                    category: "$sectionTitle",
                    selectedDate: null,
                    articleData: latestInfo,
                    selectedCompany: widget.companyName,
                )),
              );
            },
            child: Text(
              "Create your article about $sectionTitle",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue, 
                decoration: TextDecoration.underline, 
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fields,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String title, String value, String info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Color(0xFF001F3F), 
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.right,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(info),
          ),
        ],
      ),
    );
  }

  Icon _getSectionIcon(String sectionTitle) {
    switch (sectionTitle) {
      case 'Fundamental Data':
        return Icon(Icons.business, color: Color(0xFF001F3F)); 
      case 'Financial Data':
        return Icon(Icons.account_balance, color: Color(0xFF001F3F)); 
      case 'Profitability':
        return Icon(Icons.attach_money, color: Color(0xFF001F3F)); 
      case 'Revenue & Growth':
        return Icon(Icons.show_chart, color: Color(0xFF001F3F)); 
      case 'Analyst Ratings':
        return Icon(Icons.star, color: Color(0xFF001F3F)); 
      default:
        return Icon(Icons.info, color: Color(0xFF001F3F)); 
    }
  }
}
