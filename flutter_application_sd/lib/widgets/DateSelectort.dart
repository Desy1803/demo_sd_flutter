import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final int initialYear;
  final int startYear;
  final int endYear;
  final ValueChanged<int> onYearSelected;

  const DateSelector({
    Key? key,
    required this.initialYear,
    required this.startYear,
    required this.endYear,
    required this.onYearSelected,
  }) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            final selected = await showDialog<int>(
              context: context,
              builder: (context) => _YearPickerDialog(
                initialYear: selectedYear ?? widget.initialYear,
                startYear: widget.startYear,
                endYear: widget.endYear,
              ),
            );
            if (selected != null) {
              setState(() {
                selectedYear = selected;
              });
              widget.onYearSelected(selected);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF001F3F),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          child: Text(
            selectedYear == null
                ? "Select Year"
                : "Selected Year: $selectedYear", 
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        
      ],
    );
  }
}

class _YearPickerDialog extends StatefulWidget {
  final int initialYear;
  final int startYear;
  final int endYear;

  const _YearPickerDialog({
    Key? key,
    required this.initialYear,
    required this.startYear,
    required this.endYear,
  }) : super(key: key);

  @override
  _YearPickerDialogState createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<_YearPickerDialog> {
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.startYear} - ${widget.endYear}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: widget.endYear - widget.startYear + 1,
                itemBuilder: (context, index) {
                  int year = widget.startYear + index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedYear = year;
                      });
                      Navigator.pop(context, year); 
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedYear == year
                            ? Color(0xFF001F3F) 
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$year',
                        style: TextStyle(
                          color: selectedYear == year
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
