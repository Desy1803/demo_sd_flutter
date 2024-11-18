import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Market.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class GlobalMarketStatusPage extends StatefulWidget {
  @override
  _GlobalMarketStatusState createState() => _GlobalMarketStatusState();
}

class _GlobalMarketStatusState extends State<GlobalMarketStatusPage> {
  List<Market>? markets;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGlobalMarketStatus();
  }

  Future<void> _fetchGlobalMarketStatus() async {
    try {
      markets = await Model.sharedInstance.getGlobalStatusMarket();
      if (markets == null || markets!.isEmpty) {
        _generateMockMarkets(); 
      }
    } catch (e) {
      _generateMockMarkets(); 
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _generateMockMarkets() {
    markets = [
      Market(
        marketType: 'Equity',
        region: 'United States',
        primaryExchanges: 'NASDAQ, NYSE, AMEX, BATS',
        localOpen: '09:30',
        localClose: '16:15',
        currentStatus: 'closed',
        notes: 'Closed for the day',
      ),
      Market(
        marketType: 'Equity',
        region: 'Canada',
        primaryExchanges: 'Toronto, Toronto Ventures',
        localOpen: '09:30',
        localClose: '16:00',
        currentStatus: 'closed',
        notes: '',
      ),
      Market(
        marketType: 'Forex',
        region: 'Europe',
        primaryExchanges: 'London, Frankfurt',
        localOpen: '07:00',
        localClose: '15:30',
        currentStatus: 'open',
        notes: 'Active trading hours',
      ),
      Market(
        marketType: 'Equity',
        region: 'Japan',
        primaryExchanges: 'Tokyo Stock Exchange',
        localOpen: '09:00',
        localClose: '15:00',
        currentStatus: 'closed',
        notes: 'Reopens tomorrow',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Global Market Status',
        backgroundColor: const Color(0xFF001F3F), 
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _buildMarketStatusList(),
    );
  }

    Widget _buildMarketStatusList() {
    return ListView.builder(
      itemCount: markets!.length,
      itemBuilder: (context, index) {
        final market = markets![index];
        return Card(
          color: Colors.blueGrey[900],
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            title: Text(
              market.region,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Market Type: ${market.marketType}',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 5),
                Text(
                  'Primary Exchanges: ${market.primaryExchanges}',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      market.currentStatus == 'open'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: market.currentStatus == 'open'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Status: ${market.currentStatus}',
                      style: TextStyle(
                        color: market.currentStatus == 'open'
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Open: ${market.localOpen} - Close: ${market.localClose}',
                  style: TextStyle(color: Colors.white70),
                ),
                if (market.notes.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Text(
                    'Notes: ${market.notes}',
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                ],
              ],
            ),
            trailing: Icon(
              Icons.trending_up,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}