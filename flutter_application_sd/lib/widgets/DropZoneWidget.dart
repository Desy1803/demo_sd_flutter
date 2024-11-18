import 'package:flutter/material.dart';
import 'package:drop_zone/drop_zone.dart';
import 'dart:html' as html;

class DropZoneWidget extends StatelessWidget {
  final Function(List<html.File>?) onDrop;

  const DropZoneWidget({required this.onDrop});

  @override
  Widget build(BuildContext context) {
    return DropZone(
      onDrop: (List<html.File>? files) {
        if (files != null) {
          // Chiama la funzione onDrop passando la lista di file
          onDrop(files);
        }
      },
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Text("Drag and Drop your image here"),
        ),
      ),
    );
  }
}
