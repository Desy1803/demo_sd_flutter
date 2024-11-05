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
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : companyDetails == null
                ? Center(child: Text('Error during loading company details'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome: ${companyDetails!.name}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Symbol: ${companyDetails!.symbol}', style: TextStyle(fontSize: 18)),
                      Text('Categoria: ${widget.company.category}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Descrizione: ${companyDetails!.description}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text('Settore: ${companyDetails!.sector}', style: TextStyle(fontSize: 18)),
                      Text('Industria: ${companyDetails!.industry}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Sito Ufficiale: ${companyDetails!.officialSite}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
      ),
    );
  }
}
