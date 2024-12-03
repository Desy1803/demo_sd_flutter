import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/dtos/CompanyDetails.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class CompanyDetailPage extends StatefulWidget {
  final Company company;

  const CompanyDetailPage({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  CompanyDetails? companyDetails;
  bool isLoading = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    CompanyDetails? details = await Model.sharedInstance.getCompanyDetails(widget.company.symbol); 
    setState(() {
      companyDetails = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : companyDetails == null
                ? Center(child: Text('Error during loading company details'))
                : ListView(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                companyDetails!.name,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.business, color: Colors.grey[700]),
                                  SizedBox(width: 8),
                                  Text(
                                    'Symbol: ${companyDetails!.symbol}',
                                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.category, color: Colors.grey[700]),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.company.category,
                                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 30, thickness: 1),

                      Text(
                        'Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text(
                        isExpanded
                            ? companyDetails!.description
                            : companyDetails!.description.length > 1000
                                ? companyDetails!.description.substring(0, 1000) + '...'
                                : companyDetails!.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      if (companyDetails!.description.length > 1000)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(isExpanded ? 'Show less' : 'Show more'),
                        ),
                      Divider(height: 30, thickness: 1),
                      Row(
                        children: [
                          Icon(Icons.business_center, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            'Sector:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(companyDetails!.sector, style: TextStyle(fontSize: 16)),
                      Divider(height: 30, thickness: 1),

                      // Industry
                      Row(
                        children: [
                          Icon(Icons.inbox, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            'Industry:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(companyDetails!.industry, style: TextStyle(fontSize: 16)),
                      Divider(height: 30, thickness: 1),

                      Row(
                        children: [
                          Icon(Icons.link, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            'Official Site:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        companyDetails!.officialSite,
                        style: TextStyle(fontSize: 16, color: Colors.blue, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
      ),
    );
  }
}
