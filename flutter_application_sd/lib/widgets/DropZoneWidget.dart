import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DropZoneWidget extends StatefulWidget {
  final void Function(List<PlatformFile>? files) onFilesSelected;
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const DropZoneWidget({
    Key? key,
    required this.onFilesSelected,
    this.title = "Click to Upload Files",
    this.subtitle = "Supports all platforms",
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  bool _isLoading = false; // Stato per indicare il caricamento

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload,
                      size: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: widget.titleStyle ??
                          TextStyle(
                            fontSize: 16,
                            color: Colors.blue[700],
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      style: widget.subtitleStyle ??
                          TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    setState(() {
      _isLoading = true; 
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
      );

      setState(() {
        _isLoading = false; 
      });

      if (result != null) {
        widget.onFilesSelected(result.files);
      } else {
        widget.onFilesSelected(null);
      }
    } catch (e) {
      debugPrint('Error selecting files: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting files: $e'),
          backgroundColor: Colors.red,
        ),
      );
      widget.onFilesSelected(null);
    }
  }
}
