import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/pagesAuth/GeneratedArticlePage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CompanySelector.dart';
import 'package:flutter_application_sd/widgets/CategorySelector.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:flutter_application_sd/widgets/DateSelectort.dart';
import 'dart:html' as html;
class CreateArticleWithAIWidget extends StatefulWidget {
  dynamic data;
  String? symbol;
  String? selectedCompany;
  String? selectedCategory;
  String? imageUrl;
  String? imagePreviewUrl;
  bool? isPublic = true;
  DateTime? selectedDate;
  bool? isCompanyEditable = true;
  bool? isCategoryEditable = true;

  CreateArticleWithAIWidget({
    super.key,
    this.data,
    this.symbol,
    this.selectedCategory,
    this.selectedCompany,
    this.imagePreviewUrl,
    this.imageUrl,
    this.isPublic,
    this.selectedDate,
    this.isCompanyEditable,
    this.isCategoryEditable
  });

  @override
  _CreateArticleWithAIWidgetState createState() =>
      _CreateArticleWithAIWidgetState();
}

class _CreateArticleWithAIWidgetState extends State<CreateArticleWithAIWidget> {
  String? selectedCompany;
  String? selectedCategory;
  DateTime? selectedDate;
  bool useGoogle = true;
  String? imageUrl = '';
  String? imagePreviewUrl;
  bool? isPublic = true;
  dynamic data;
  bool? isCompanyEditable ;
  bool? isCategoryEditable ;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    selectedCategory = widget.selectedCategory;
    selectedCompany = widget.selectedCompany;
    imagePreviewUrl = widget.imagePreviewUrl;
    imageUrl = widget.imageUrl;
    selectedDate = widget.selectedDate;
    isCompanyEditable = widget.isCompanyEditable;
    isCategoryEditable = widget.isCategoryEditable;
    if (data != null) {
      useGoogle = false;
    }
  }

  void handleImageUpload() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onLoadEnd.listen((e) {
        if (mounted) {  
          setState(() {
            imagePreviewUrl = reader.result as String;
            imageUrl = imagePreviewUrl!.split(',').last;
          });
        }
      });
    });
  }


  Future<void> createArticleWithAI() async {
    if (selectedCompany == null ||
        selectedCategory == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required fields.')),
      );
      return;
    }

    dynamic filteredData;
    if (data is List<AnnualReport>) {
      filteredData = AnnualReport.getReportByYear(data, selectedDate!.year.toString());
    } else {
      filteredData = data; 
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'We are generating your article using AI. Please wait a moment...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            )
    );

    try {
      final response = await Model.sharedInstance.fetchAIArticle(
        company: selectedCompany!,
        category: selectedCategory!,
        date: selectedDate!,
        useGoogle: useGoogle.toString(),
        data: filteredData,
      );

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratedArticlePage(
            article: response,
            imagePreviewUrl: imagePreviewUrl,
            imageUrl: imageUrl!,
            date: selectedDate!,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create article: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write Your Article With AI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F3F),
                ),
              ),
              const SizedBox(height: 16),
              CompanySelector(
                selectedCompany: selectedCompany,
                onCompanySelected: (value) {
                  setState(() {
                    selectedCompany = value;
                  });
                },
                isEditable: isCompanyEditable!,
              ),
              const SizedBox(height: 16),
              CategorySelector(
                selectedCategory: selectedCategory,
                onCategorySelected: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                isEditable: isCompanyEditable!,
              ),
              const SizedBox(height: 16),
              DateSelector(
              initialYear: selectedDate?.year ?? DateTime.now().year,
              startYear: 2008,
              endYear: DateTime.now().year,
              onYearSelected: (year) {
                setState(() {
                  selectedDate = DateTime(year, 12, 31);
                });
              },
            ),
              const SizedBox(height: 16),
              if (data==null)
               const Text('This AI uses Google information, so pay attention.'),
              const SizedBox(height: 24),
              if (imagePreviewUrl != null)
                Column(
                  children: [
                    const Text('Image Preview:'),
                    const SizedBox(height: 8),
                    Image.network(imagePreviewUrl!),
                  ],
                ),
              ElevatedButton(
                onPressed: handleImageUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F3F),
                ),
                child: const Text('Upload Image', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isPublic,
                    onChanged: (value) {
                      setState(() {
                        isPublic = value!;
                      });
                    },
                  ),
                  const Text('Public Article'),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: createArticleWithAI,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    backgroundColor: const Color(0xFF001F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Create Article",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
