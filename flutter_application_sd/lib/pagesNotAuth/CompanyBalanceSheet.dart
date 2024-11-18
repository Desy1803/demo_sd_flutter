import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class CompanyBalanceSheet extends StatefulWidget {
  final String symbol;

  CompanyBalanceSheet({Key? key, required this.symbol}) : super(key: key);

  @override
  _CompanyBalanceSheetState createState() => _CompanyBalanceSheetState();
}

class _CompanyBalanceSheetState extends State<CompanyBalanceSheet>
    with SingleTickerProviderStateMixin {
  List<AnnualReport>? reports;
  bool isLoading = true;
  String errorMessage = '';
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    try {
      reports = await Model.sharedInstance.getCompaniesReport(widget.symbol);
      if (reports == null || reports!.isEmpty) {
        _generateMockReports(); 
      }
    } catch (e) {
      _generateMockReports(); 
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.symbol} Balance Sheet',
        backgroundColor: const Color(0xFF001F3F), 
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _buildBalanceSheetView(),
      );
    }


   _buildBalanceSheetView() {
    reports!.sort((a, b) => b.fiscalDateEnding.compareTo(a.fiscalDateEnding));

    return Column(
      children: [
        Expanded(
          child: _buildReportsCarousel(),
        ),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildReportsCarousel() {
    return PageView.builder(
      controller: _pageController,
      itemCount: reports!.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index; 
        });
      },
      itemBuilder: (context, index) {
        return _buildReportCard(reports![index]);
      },
    );
  }

  Widget _buildReportCard(AnnualReport report) {
  return Card(
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, 
            child: _buildFinancialChart(report),
          ),
          SizedBox(width: 20), 
          
          Expanded(
            flex: 1, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Annual Report (${report.fiscalDateEnding})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildReportDetails(report), // I dettagli finanziari
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildReportDetails(AnnualReport report) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2, 
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), 
      children: [
        _buildDetailCard('Total Assets', report.totalAssets),
        _buildDetailCard('Total Liabilities', report.totalLiabilities),
        _buildDetailCard('Total Shareholder Equity', report.totalShareholderEquity),
        _buildDetailCard('Cash and Cash Equivalents', report.cashAndCashEquivalentsAtCarryingValue),
        _buildDetailCard('Current Assets', report.totalCurrentAssets),
        _buildDetailCard('Inventory', report.inventory),
        _buildDetailCard('Current Liabilities', report.totalCurrentLiabilities),
        _buildDetailCard('Long Term Debt', report.longTermDebt),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.all(6.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text('\$${formatNumber(value)}'), 
            Spacer(),
          ],
        ),
      ),
    );
  }


  Widget _buildFinancialChart(AnnualReport report) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitles: (value) {
                return formatNumber(value.toString()); 
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Assets';
                  case 1:
                    return 'Liabilities';
                  case 2:
                    return 'Equity';
                  default:
                    return '';
                }
              },
            ),
            topTitles: SideTitles(showTitles: false), 
            rightTitles: SideTitles(showTitles: false), 
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(y: double.parse(report.totalAssets), colors: [Colors.blue]),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(y: double.parse(report.totalLiabilities), colors: [Colors.red]),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(y: double.parse(report.totalShareholderEquity), colors: [Colors.green]),
            ]),
          ],
        ),
      ),
    );
  }

    Widget _buildPageIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(reports!.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            width: _currentIndex == index ? 24.0 : 8.0,
            decoration: BoxDecoration(
              color: _currentIndex == index ? Color.fromRGBO(0, 4, 254, 1) : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      );
    }


  void _generateMockReports() {
    reports = [
      AnnualReport(
        fiscalDateEnding: '2023-12-31',
        reportedCurrency: 'USD',
        totalAssets: '135241000000',
        totalCurrentAssets: '32908000000',
        cashAndCashEquivalentsAtCarryingValue: '13068000000',
        cashAndShortTermInvestments: '13000000000',
        inventory: '1161000000',
        currentNetReceivables: '7725000000',
        totalNonCurrentAssets: '101302000000',
        propertyPlantEquipment: '30000000000',
        accumulatedDepreciationAmortizationPPE: '5000000000',
        intangibleAssets: '71214000000',
        intangibleAssetsExcludingGoodwill: '20000000000',
        goodwill: '60178000000',
        investments: '5000000000',
        longTermInvestments: '125000000',
        shortTermInvestments: '15000000000',
        otherCurrentAssets: '3000000000',
        otherNonCurrentAssets: '4000000000',
        totalLiabilities: '112628000000',
        totalCurrentLiabilities: '34122000000',
        currentAccountsPayable: '4132000000',
        deferredRevenue: '16984000000',
        currentDebt: '12851000000',
        shortTermDebt: '2000000000',
        totalNonCurrentLiabilities: '87072000000',
        capitalLeaseObligations: '1000000000',
        longTermDebt: '54588000000',
        currentLongTermDebt: '1500000000',
        longTermDebtNoncurrent: '53000000000',
        shortLongTermDebtTotal: '3000000000',
        otherCurrentLiabilities: '2500000000',
        otherNonCurrentLiabilities: '1500000000',
        totalShareholderEquity: '22533000000',
        treasuryStock: '1000000000',
        retainedEarnings: '151276000000',
        commonStock: '59643000000',
        commonStockSharesOutstanding: '2000000000',
      ),
      AnnualReport(
        fiscalDateEnding: '2022-12-31',
        reportedCurrency: 'USD',
        totalAssets: '130000000000',
        totalCurrentAssets: '32000000000',
        cashAndCashEquivalentsAtCarryingValue: '12000000000',
        cashAndShortTermInvestments: '11000000000',
        inventory: '1000000000',
        currentNetReceivables: '7000000000',
        totalNonCurrentAssets: '98000000000',
        propertyPlantEquipment: '29000000000',
        accumulatedDepreciationAmortizationPPE: '4500000000',
        intangibleAssets: '70000000000',
        intangibleAssetsExcludingGoodwill: '18000000000',
        goodwill: '59000000000',
        investments: '100000000',
        longTermInvestments: '100000000',
        shortTermInvestments: '12000000000',
        otherCurrentAssets: '2500000000',
        otherNonCurrentAssets: '3000000000',
        totalLiabilities: '110000000000',
        totalCurrentLiabilities: '33000000000',
        currentAccountsPayable: '4000000000',
        deferredRevenue: '15000000000',
        currentDebt: '12000000000',
        shortTermDebt: '1500000000',
        totalNonCurrentLiabilities: '85000000000',
        capitalLeaseObligations: '900000000',
        longTermDebt: '54000000000',
        currentLongTermDebt: '1600000000',
        longTermDebtNoncurrent: '53000000000',
        shortLongTermDebtTotal: '2800000000',
        otherCurrentLiabilities: '2400000000',
        otherNonCurrentLiabilities: '1400000000',
        totalShareholderEquity: '20000000000',
        treasuryStock: '800000000',
        retainedEarnings: '150000000000',
        commonStock: '59000000000',
        commonStockSharesOutstanding: '1950000000',
      ),
      AnnualReport(
        fiscalDateEnding: '2021-12-31',
        reportedCurrency: 'USD',
        totalAssets: '125000000000',
        totalCurrentAssets: '31000000000',
        cashAndCashEquivalentsAtCarryingValue: '11000000000',
        cashAndShortTermInvestments: '10000000000',
        inventory: '900000000',
        currentNetReceivables: '6500000000',
        totalNonCurrentAssets: '94000000000',
        propertyPlantEquipment: '28000000000',
        accumulatedDepreciationAmortizationPPE: '4200000000',
        intangibleAssets: '65000000000',
        intangibleAssetsExcludingGoodwill: '16000000000',
        goodwill: '57000000000',
        investments: '90000000',
        longTermInvestments: '90000000',
        shortTermInvestments: '11000000000',
        otherCurrentAssets: '2200000000',
        otherNonCurrentAssets: '2800000000',
        totalLiabilities: '108000000000',
        totalCurrentLiabilities: '32000000000',
        currentAccountsPayable: '3900000000',
        deferredRevenue: '14000000000',
        currentDebt: '11000000000',
        shortTermDebt: '1600000000',
        totalNonCurrentLiabilities: '83000000000',
        capitalLeaseObligations: '800000000',
        longTermDebt: '53000000000',
        currentLongTermDebt: '1400000000',
        longTermDebtNoncurrent: '53000000000',
        shortLongTermDebtTotal: '2400000000',
        otherCurrentLiabilities: '2300000000',
        otherNonCurrentLiabilities: '1300000000',
        totalShareholderEquity: '17000000000',
        treasuryStock: '700000000',
        retainedEarnings: '140000000000',
        commonStock: '58000000000',
        commonStockSharesOutstanding: '1900000000',
      ),
      AnnualReport(
        fiscalDateEnding: '2020-12-31',
        reportedCurrency: 'USD',
        totalAssets: '120000000000',
        totalCurrentAssets: '30000000000',
        cashAndCashEquivalentsAtCarryingValue: '10000000000',
        cashAndShortTermInvestments: '9500000000',
        inventory: '800000000',
        currentNetReceivables: '6000000000',
        totalNonCurrentAssets: '90000000000',
        propertyPlantEquipment: '27000000000',
        accumulatedDepreciationAmortizationPPE: '4000000000',
        intangibleAssets: '60000000000',
        intangibleAssetsExcludingGoodwill: '15000000000',
        goodwill: '45000000000',
        investments: '80000000',
        longTermInvestments: '80000000',
        shortTermInvestments: '9000000000',
        otherCurrentAssets: '2000000000',
        otherNonCurrentAssets: '2500000000',
        totalLiabilities: '104000000000',
        totalCurrentLiabilities: '31000000000',
        currentAccountsPayable: '3800000000',
        deferredRevenue: '13000000000',
        currentDebt: '10000000000',
        shortTermDebt: '1400000000',
        totalNonCurrentLiabilities: '73000000000',
        capitalLeaseObligations: '700000000',
        longTermDebt: '51000000000',
        currentLongTermDebt: '1300000000',
        longTermDebtNoncurrent: '51000000000',
        shortLongTermDebtTotal: '2200000000',
        otherCurrentLiabilities: '2100000000',
        otherNonCurrentLiabilities: '1200000000',
        totalShareholderEquity: '16000000000',
        treasuryStock: '600000000',
        retainedEarnings: '130000000000',
        commonStock: '57000000000',
        commonStockSharesOutstanding: '1850000000',
      ),
    ];
  }

  String formatNumber(String number) {
    double value = double.parse(number);
    
    if (value >= 1e12) {
      // Trilioni
      return (value / 1e12).toStringAsFixed(1) + 'T';
    } else if (value >= 1e9) {
      // Miliardi
      return (value / 1e9).toStringAsFixed(1) + 'B';
    } else if (value >= 1e6) {
      // Milioni
      return (value / 1e6).toStringAsFixed(1) + 'M';
    } else if (value >= 1e3) {
      // Migliaia
      return (value / 1e3).toStringAsFixed(1) + 'K';
    } else {
      // Numero intero
      return value.toStringAsFixed(1);
    }
}


}