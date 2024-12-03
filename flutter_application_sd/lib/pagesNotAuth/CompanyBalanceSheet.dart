import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/pagesAuth/WriterArticlePage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CompanyBalanceSheet extends StatefulWidget {
  final String symbol;  // Assuming `symbol` is passed to the widget

  CompanyBalanceSheet({required this.symbol});

  @override
  _CompanyBalanceSheetState createState() => _CompanyBalanceSheetState();
}

class _CompanyBalanceSheetState extends State<CompanyBalanceSheet> {
  List<AnnualReport> annualReports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    try {
      List<AnnualReport>? reports = await Model.sharedInstance.getCompaniesReport(widget.symbol);

      if (reports == null || reports.isEmpty) {
        print('No reports found');
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          annualReports = reports;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Company Symbol: ${widget.symbol}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                  items: [
                    _buildPriceVolumeChart(),
                    ...annualReports.map((report) => _buildYearlyDataCard(report)).toList(),
                  ],
                ),
          
          
                _buildPageIndicator(),
              ],
            ),
    );
  }


  
Widget _buildPageIndicator() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int i = 0; i < annualReports.length + 1; i++)
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == _currentCarouselIndex ? Color(0xFF001F3F) : Colors.grey,
          ),
        ),
    ],
  );
}

Widget _buildYearlyDataCard(AnnualReport report) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Year: ${report.fiscalDateEnding}",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 16),
                 _buildDataRow("Total Assets", report.totalAssets,
                  "Total value of everything the company owns."),
                _buildDataRow("Total Liabilities", report.totalLiabilities,
                    "Total amount the company owes."),
                _buildDataRow("Shareholder Equity", report.totalShareholderEquity,
                    "Total value of the company's shares held by owners."),
                _buildDataRow("Cash & Short-Term Investments", report.cashAndShortTermInvestments,
                    "The money available for short-term use."),
                _buildDataRow("Goodwill", report.goodwill,
                    "The premium paid over fair value for acquisitions.")

              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF001F3F),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriterArticlePage(
                    symbol: widget.symbol,
                    category: "Analysis Data",
                    year: report.fiscalDateEnding, 
                  ),
                ),
              );
            },
            child: Text("Create your Article"),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildDataRow(String title, String value, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: \$${(int.parse(value) / 1e9).toStringAsFixed(2)}B",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }




 Widget _buildPriceVolumeChart() {
  if (annualReports.isEmpty) return Center(child: Text("No data available"));

  List<FlSpot> priceSpots = [];
  List<BarChartGroupData> volumeBars = [];
  double minPrice = double.infinity;
  double maxPrice = double.negativeInfinity;
  double maxVolume = double.negativeInfinity;

  for (int i = 0; i < annualReports.length; i++) {
    final yearData = annualReports[i];
    double price = int.parse(yearData.totalAssets) /
        int.parse(yearData.commonStockSharesOutstanding);
    double volume = double.parse(yearData.cashAndShortTermInvestments);

    priceSpots.add(FlSpot(i.toDouble(), price));

    volumeBars.add(BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          y: volume,
          colors: [Colors.blue],
          width: 16,
        ),
      ],
    ));

    minPrice = price < minPrice ? price : minPrice;
    maxPrice = price > maxPrice ? price : maxPrice;
    maxVolume = volume > maxVolume ? volume : maxVolume;
  }

  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price and Volume Over the Years",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.grey[700]),
                  tooltip: "Click to learn more",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Price and Volume Chart"),
                          content: Text(
                            "This chart shows the relationship between:\n\n"
                            "- **Price**: Calculated as Total Assets divided by "
                            "Common Stock Shares Outstanding, representing the asset-backed "
                            "value per share.\n"
                            "- **Volume**: Indicates the company's cash and short-term "
                            "investments, reflecting liquidity.\n\n"
                            "Together, these metrics provide insights into the company's "
                            "value and financial health over time.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Close", style: TextStyle(color: Color(0xFF001F3F))),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: volumeBars,
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) => value.toInt() < annualReports.length
                          ? "'" + annualReports[value.toInt()].fiscalDateEnding.substring(2, 4)
                          : '',
                      margin: 8,
                    ),
                    leftTitles: SideTitles(showTitles: true),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF001F3F),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriterArticlePage(
                  symbol: widget.symbol,
                  category: "Analysis Data",
                  year: "All past years",
                ),
              ),
            );
          },
          child: Text("Create your Article"),
        ),
      ),
    ],
  );
}

}
