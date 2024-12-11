import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/LatestInfoDto.dart';
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
                selectionColor: Colors.white,
              ),
            ),
            _buildSection('Fundamental Data', [
              _buildFieldRow('Symbol', latestInfo!.symbol, 'Unique identifier for the company\'s stock.'),
              _buildFieldRow('Name', latestInfo!.name, 'The official name of the company.'),
              _buildFieldRow('Sector', latestInfo!.sector, 'The economic sector to which the company belongs.'),
              _buildFieldRow('Industry', latestInfo!.industry, 'The specific industry category for the company.'),
              _buildFieldRow('Description', latestInfo!.description, 'A brief description of the company and its operations.'),
              _buildFieldRow('CIK', latestInfo!.cik, 'Central Index Key used for SEC filings.'),
              _buildFieldRow('Exchange', latestInfo!.exchange, 'The stock exchange where the company is listed.'),
              _buildFieldRow('Currency', latestInfo!.currency, 'The currency in which the stock is traded.'),
              _buildFieldRow('Address', latestInfo!.address, 'The company\'s official address.'),
              _buildFieldRow('Official site', latestInfo!.officialSite, 'The URL of the company\'s official website.'),
              _buildFieldRow('Fiscal year end', latestInfo!.fiscalYearEnd, 'The month in which the company\'s fiscal year ends.'),
            ]),

            // Financial Data Section
            _buildSection('Financial Data', [
              _buildFieldRow('Market Capitalization', '${latestInfo!.marketCapitalization} USD', 'The total market value of the company\'s outstanding shares.'),
              _buildFieldRow('EBITDA', '${latestInfo!.ebitda} USD', 'Earnings before interest, taxes, depreciation, and amortization.'),
              _buildFieldRow('PE Ratio', latestInfo!.pERatio.toString(), 'Price-to-Earnings ratio, calculated as stock price divided by earnings per share.'),
              _buildFieldRow('PEG Ratio', latestInfo!.pEGRatio.toString(), 'Price/Earnings-to-Growth ratio, a valuation metric that considers growth.'),
              _buildFieldRow('Book value', latestInfo!.bookValue, 'Value of the company\'s net assets per share.'),
              _buildFieldRow('Trailing P/E', latestInfo!.trailingPE, 'P/E ratio based on the company\'s trailing 12-month earnings.'),
              _buildFieldRow('Forward P/E', latestInfo!.forwardPE, 'P/E ratio based on the company\'s estimated future earnings.'),
              _buildFieldRow('Price to Sales Ratio', latestInfo!.priceToSalesRatioTTM, 'A ratio comparing the company\'s stock price to its revenue per share.'),
              _buildFieldRow('Price to Book Ratio', latestInfo!.priceToBookRatio, 'A ratio comparing the company\'s market price to its book value.'),
              _buildFieldRow('EV to Revenue', latestInfo!.eVToRevenue, 'Enterprise Value to Revenue, a valuation metric for comparing a company\'s revenues.'),
              _buildFieldRow('EV to EBITDA', latestInfo!.eVToEBITDA, 'Enterprise Value to EBITDA, a valuation metric that considers debt.'),
            ]),
            
          _buildSection('Profitability & Margins', [
            _buildFieldRow('Profit Margin', '${latestInfo!.profitMargin}%', 'The percentage of revenue that becomes profit.'),
            _buildFieldRow('Operating Margin (TTM)', latestInfo!.operatingMarginTTM, 'The company\'s operating income divided by its revenue over the trailing 12 months.'),
            _buildFieldRow('Return on Assets (TTM)', latestInfo!.returnOnAssetsTTM, 'A profitability ratio showing net income relative to total assets.'),
            _buildFieldRow('Return on Equity (TTM)', latestInfo!.returnOnEquityTTM, 'A profitability ratio showing net income relative to shareholder\'s equity.'),
          ]),

          // Revenue & Growth Section
          _buildSection('Revenue & Growth', [
            _buildFieldRow('Revenue (TTM)', latestInfo!.revenueTTM, 'The total revenue generated over the trailing 12 months.'),
            _buildFieldRow('Gross Profit (TTM)', latestInfo!.grossProfitTTM, 'Total revenue minus the cost of goods sold over the trailing 12 months.'),
            _buildFieldRow('Revenue per Share (TTM)', latestInfo!.revenuePerShareTTM, 'Total revenue divided by the total number of shares.'),
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
      color: Colors.white, // Light background for the section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getSectionIcon(sectionTitle), // Icon for the section
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
        return Icon(Icons.business, color: Color(0xFF001F3F)); // Business icon per Fundamental Data
      case 'Financial Data':
        return Icon(Icons.account_balance, color: Color(0xFF001F3F)); // Account balance icon per Financial Data
      case 'Profitability':
        return Icon(Icons.attach_money, color: Color(0xFF001F3F)); // Money icon per Profitability
      case 'Revenue & Growth':
        return Icon(Icons.show_chart, color: Color(0xFF001F3F)); // Chart icon per Revenue & Growth
      case 'Analyst Ratings':
        return Icon(Icons.star, color: Color(0xFF001F3F)); // Star icon per Analyst Ratings
      default:
        return Icon(Icons.info, color: Color(0xFF001F3F)); // Default icon
    }
  }

}
